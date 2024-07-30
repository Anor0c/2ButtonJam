class_name PlayerChar
extends CharacterBody2D

signal OnStaminaChanged(currentStamina:float, maxStamina:float)
signal OnHealthChanged(currentHealth : int, maxHealth : int)
signal OnPlayerDied

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


@onready var jumpHitbox:GDHitbox = get_node("JumpHit")
@onready var fwdAtkHitbox:GDHitbox = get_node("SlashHit")
@onready var turnHitbox: GDHitbox = get_node("StabHit")
@onready var hurtBox : Hurtbox = get_node("Hurtbox")

@onready var anim : AnimatedSprite2D = get_node("AnimatedSprite2D")
@onready var cam : Camera2D = get_node("Camera2D")
@onready var deathScreen : CanvasLayer = get_node("Camera2D/DeathMenu")
@onready var winScreen : CanvasLayer = get_node("Camera2D/WinMenu")
func _ready() ->void:
	currentStamina = MaxStamina
	currentHealth = MaxHealth
	cam.make_current()

func _physics_process(delta : float)->void:
#Gravity
	if !is_on_floor():
		velocityInternal.y += gravity * delta
		anim.wasInAir = true
		anim.isRunning = false
		if not anim.isJumping and not anim.isHurt and not anim.isSleeping: 
			anim.FallAnim()
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
	#print ("Speed : ", PlayerSpeed, ", Velocity : ", velocity, ", Internal Velocity : ", velocityInternal)

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
		Death()
		anim.DeathAnim()
	else:
		anim.HurtAnim()

func Death()->void: 
	hurtBox.queue_free()
	emit_signal("OnPlayerDied")
	canMove =false 
	currentStamina = 0
	
#region AnimSignals
func _on_animated_sprite_2d_state_changed(animState : StringName)->void:
	if animState == "Hurt" or animState == "Run" or animState=="Sleep" or animState == "Falling":
		set_deferred("fwdAtkHitbox.monitorable", false)  
		set_deferred("turnHitbox.monitorable", false) 
		set_deferred("jumpHitbox.monitorable", false) 

	if animState == "Jump":
		fwdAtkHitbox.monitorable = false
		turnHitbox.monitorable = false
		jumpHitbox.monitorable = true

	if animState == "Slash": 
		fwdAtkHitbox.monitorable = true

	if animState == "TurnAttack": 
		fwdAtkHitbox.monitorable = false
		turnHitbox.monitorable = true

	#if animState == "Run" or animState=="Sleep":
		#fwdAtkHitbox.disabled = true
		#turnHitbox.disabled = true
		#jumpHitbox.disabled = true


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
		fwdAtkHitbox.monitorable = false
	if(animState == "TurnAttack"):
		turnHitbox.monitorable = false
	if(animState == "Jump"):
		jumpHitbox.monitorable = false
	if (animState == "Hurt"):
		canMove = true

#endregion
