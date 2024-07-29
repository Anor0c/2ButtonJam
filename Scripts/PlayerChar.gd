class_name PlayerChar
extends CharacterBody2D

signal OnStaminaChanged(currentStamina:float, maxStamina:float)
signal OnHealthChanged(currentHealth : int, maxHealth : int)

@export_category("PlayerStats")
@export var PlayerSpeed : float = 300.0
@export var JumpVelocity : float = -600.0
@export var MaxStamina : float = 100.0
@export var MaxHealth : int = 3
var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")
var canMove : bool = true
var velocityInternal : Vector2  = velocity

@export_category("StaminaCost")
@export var runStaminaCost :float  = -5.0
@export var jumpStaminaCost : float= -5.0
@export var fwdAttackStaminaCost: float= -5.0
@export var stabStaminaCost: float= -5.0
@export var sleepStaminaRegen :float= 35.0
@export var idleStaminaRegen :float= 5.0

var currentStamina : float = 0.0
var currentHealth : int= 1
var sleepCounter : int= 0


@onready var jumpHitbox:CollisionShape2D = get_node("JumpHit/JumpHitShape")
@onready var fwdAtkHitbox:CollisionShape2D = get_node("SlashHit/SlashHitShape")
@onready var turnHitbox: CollisionShape2D = get_node("StabHit/StabHitShape")

@onready var anim : AnimatedSprite2D = get_node("AnimatedSprite2D")
@onready var cam : Camera2D = get_node("Camera2D")

func _ready() ->void:
	currentStamina = MaxStamina
	currentHealth = MaxHealth

func _physics_process(delta : float)->void:
#Gravity
	if !is_on_floor():
		velocityInternal.y += gravity * delta
		anim.wasInAir = true
		anim.isRunning = false
	else  :
		anim.isJumping = false
		anim.wasInAir = false
		velocityInternal= Vector2(velocityInternal.x, 0)

	if (anim.isHurt):
		velocityInternal = Vector2(-PlayerSpeed / 2.0, -300.0 / 2.0)
		velocity = velocityInternal
		move_and_slide()
		return

	if (not canMove):
		velocityInternal = Vector2 (0,velocityInternal.y)
		velocity = velocityInternal
		move_and_slide()
		return

	# Handle Jump.
	if Input.is_action_just_pressed("Up") && is_on_floor():
		if (anim.isSleeping):
			anim.isSleeping = false
		sleepCounter = 0
		velocityInternal.y = JumpVelocity
		anim.JumpAnim()
		anim.wasInAir = true
		anim.isJumping = true
		anim.isAttacking = true

	#Handle Forward Input
	if Input.is_action_just_pressed("Forward") && is_on_floor():
		if (anim.isSleeping):
			anim.isSleeping = false
		if (anim.isAttacking == false):
			anim.SlashAnim()
			anim.isAttacking = true
		elif (anim.animation=="Slash"||anim.frame_progress>=0.6):
			anim.StabAnim()
			anim.isAttacking = true
			TurnAround()

	if Input.is_action_pressed("Forward"):
		if (anim.isSleeping):
			anim.isSleeping = false
		velocityInternal.x = PlayerSpeed
		sleepCounter = 0
		if (is_on_floor()&&anim.isAttacking==false) :
			anim.RunAnim()
			anim.isRunning = true
		else:
			anim.isRunning = false
	else:
		if is_on_floor():
			velocityInternal.x = move_toward(velocity.x, 0, 300)
		else:
			velocityInternal.x = move_toward(velocity.x, 0, 10)       
		anim.isRunning = false
		anim.canIdle = true
	velocity = velocityInternal
	move_and_slide()
	print ("Speed : ", PlayerSpeed, ", Velocity : ", velocity, ", Internal Velocity : ", velocityInternal)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta : float)->void:
	if (not canMove):
		canMove=HasEnoughStamina(MaxStamina)
	#print ("Can Move is ", canMove)
	
func TurnAround()->void:
	PlayerSpeed=-PlayerSpeed
	anim.flip_h = not anim.flip_h
	fwdAtkHitbox.position.x = -fwdAtkHitbox.position.x
	jumpHitbox.position.x = -jumpHitbox.position.x
	
	

#region Stamina
func StaminaUpdate(delta : float)->void:
	currentStamina = clamp(currentStamina+delta, 0, MaxStamina)
	emit_signal("OnStaminaChanged", currentStamina, MaxStamina)
	if currentStamina<=0 : 
		StaminaDepleted()

func HasEnoughStamina(staminaNeeded: float)->bool:
	if currentStamina>=staminaNeeded:  return true
	else : return false 

func StaminaDepleted()->void :
	anim.SleepAnim()
	canMove=false
#endregion

func TakeDamage (Damage : float) ->void :
	currentHealth = clamp(currentHealth + Damage, 0, MaxHealth)
	emit_signal("OnHealthChanged", currentHealth, MaxHealth)
	print(currentHealth)
	if (currentHealth == 0):
		anim.DeathAnim()
	else:
		anim.HurtAnim()

#region AnimSignals
func _on_animated_sprite_2d_state_changed(animState : StringName)->void:
	if animState == "Hurt":
		set_deferred("fwdAtkHitbox.disabled", true)  
		set_deferred("turnHitbox.disabled", true) 
		set_deferred("jumpHitbox.disabled", true) 

	if animState == "Jump":
		fwdAtkHitbox.disabled = true
		turnHitbox.disabled = true
		jumpHitbox.disabled = false

	if animState == "Slash": 
		fwdAtkHitbox.disabled = false

	if animState == "TurnAttack": 
		fwdAtkHitbox.disabled = true
		turnHitbox.disabled = false

	if animState == "Run" or animState=="Sleep":
		fwdAtkHitbox.disabled = true
		turnHitbox.disabled = true
		jumpHitbox.disabled = true


func _on_animated_sprite_2d_state_looped(animState:StringName)->void:
	if (animState == "Run"):
		StaminaUpdate(runStaminaCost)
	if (animState == "Idle"):
		sleepCounter+=1
		if (sleepCounter >= 3):
			anim.SleepAnim()
			sleepCounter = 0
			return
		StaminaUpdate(idleStaminaRegen)
	if (animState == "Sleep"):
		StaminaUpdate(sleepStaminaRegen)


func _on_animated_sprite_2d_state_ended(animState:StringName)->void:
	if(animState == "Slash"):
		fwdAtkHitbox.disabled = true
	if(animState == "TurnAttack"):
		turnHitbox.disabled = true
	if(animState == "Jump"):
		jumpHitbox.disabled = true
	if (animState == "Hurt"):
		canMove = true

#endregion
