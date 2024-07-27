extends AnimatedSprite2D

var isRunning : bool= false
var isAttacking : bool= false
var isJumping : bool= false
var wasInAir : bool= false
var canIdle: bool = true
var isIdle : bool= false
var isSleeping : bool= false
var isHurt : bool= false
var canMove: bool = true

@export var playerChar : CharacterBody2D
func _ready()->void:
	IdleAnim()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float)->void:
	pass


func IdleAnim()->void:
	if isIdle or not canIdle : return
	stop()
	play("Idle")

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
	play("ForwardAttack")

func StabAnim()->void:
	stop()
	play("ForwardStab")

func HurtAnim()->void:
	stop()
	play("Hurt")

func SleepAnim()->void:
	stop()
	play("Sleep")
	isSleeping = true

func DeathAnim()->void:
	canMove=false
	stop()
	play("Death")




func _on_animation_changed() ->void:
	print (animation, " Switch")
	if animation == "Hurt":
		canMove = false;
		isHurt = true;
		isRunning = false;
		playerChar.fwdAtkHitbox.Disabled = true;
		playerChar.stabHitbox.Disabled = true;
		playerChar.jumpHitbox.Disabled = true;
	 
	if animation == "Jump": 
		playerChar.StaminaUpdate(playerChar.jumpStaminaCost) #A remettre dans playerChara, pas de l'anim
		playerChar.fwdAtkHitbox.Disabled = true
		playerChar.stabHitbox.Disabled = true
		playerChar.jumpHitbox.Disabled = false
	 
	if animation == "ForwardAttack": 
		playerChar.StaminaUpdate(playerChar.fwdAttackStaminaCost);
		playerChar.fwdAtkHitbox.Disabled = false;
	if animation == "ForwardStab": 
		playerChar.StaminaUpdate(playerChar.stabStaminaCost);
		playerChar.fwdAtkHitbox.Disabled = true;
		playerChar.stabHitbox.Disabled = false;
	if animation == "Run"||isSleeping: 
		isAttacking = false;
		playerChar.fwdAtkHitbox.Disabled = true;
		playerChar.stabHitbox.Disabled = true;
		playerChar.jumpHitbox.Disabled = true;
	 

func _on_animation_finished()->void:
	print (animation, " Ended")
	if (animation == "Run"):
		playerChar.StaminaUpdate(playerChar.runStaminaCost)
	if (animation == "Idle"):
		playerChar.sleepCounter+=1
		if (playerChar.sleepCounter >= 3):
			SleepAnim()
			playerChar.sleepCounter = 0
			return
		playerChar.StaminaUpdate(playerChar.idleStaminaRegen)
	if (animation == "Sleep"):
		playerChar.StaminaUpdate(playerChar.sleepStaminaRegen)

func _on_animation_looped()->void:
	print (animation, " Loop")
	if (animation == "ForwardAttack"||animation=="ForwardStab"||animation=="Jump"):
		isAttacking = false; 
	if(animation == "ForwardAttack"):
		playerChar.fwdAtkHitbox.Disabled = true
	if(animation == "ForwardStab"):
		playerChar.stabHitbox.Disabled = true
	if(animation == "Jump"):
		playerChar.jumpHitbox.Disabled = true
	if (animation == "Hurt"):
		canMove = true
		isHurt = false
