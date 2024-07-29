extends AnimatedSprite2D

signal StateChanged(state : StringName)
signal StateLooped(state : StringName)
signal StateEnded(state : StringName)

var isRunning : bool= false
var isAttacking : bool= false
var isJumping : bool= false
var wasInAir : bool= false
var canIdle: bool = true
var isIdle : bool= false
var isSleeping : bool= false
var isHurt : bool= false

@export var playerChar : CharacterBody2D

func _ready()->void:
	IdleAnim()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta : float)->void:
	if (!playerChar.canMove):
		return;

	if (animation != "Idle"):
		isIdle = false;

func _physics_process(_delta: float)->void:
	if (isRunning or isJumping or not playerChar.is_on_floor() or isSleeping or isAttacking or isHurt):
		canIdle = false; 
	else:
		canIdle = true;
		IdleAnim();

func IdleAnim()->void:
	if  not canIdle or isIdle : return
	stop()
	play("Idle")
	canIdle = false;
	isIdle = true;

func RunAnim()->void:
	if isRunning : return
	stop()
	play("Run")

func JumpAnim()->void:
	if isJumping : return
	stop()
	play("Jump")

func SlashAnim()->void:
	stop()
	play("Slash")

func StabAnim()->void:
	stop()
	play("TurnAttack")

func HurtAnim()->void:
	stop()
	play("Hurt")

func SleepAnim()->void:
	stop()
	play("Sleep")
	isSleeping = true

func DeathAnim()->void:
	playerChar.canMove=false
	stop()
	play("Death")




func _on_animation_changed() ->void:
	print (animation, " Switch")
	emit_signal("StateChanged", animation)
	if animation == "Hurt":
		playerChar.canMove = false;
		isHurt = true;
		isRunning = false;

	 
	if animation == "Jump": 
		playerChar.StaminaUpdate(playerChar.jumpStaminaCost) #A remettre dans playerChara, pas de l'anim
	 
	if animation == "Slash": 
		playerChar.StaminaUpdate(playerChar.fwdAttackStaminaCost);
		
	if animation == "TurnAttack": 
		playerChar.StaminaUpdate(playerChar.stabStaminaCost);
		
	if animation == "Run"||isSleeping: 
		isAttacking = false;
	 

func _on_animation_finished()->void:
	print (animation, " Ended")
	emit_signal("StateEnded", animation)
	if (animation == "Slash"||animation=="TurnAttack"||animation=="Jump"):
		isAttacking = false; 
	if (animation == "Hurt"):
		isHurt = false



func _on_animation_looped()->void:
	print (animation, " Loop")
	emit_signal("StateLooped", animation)
	
