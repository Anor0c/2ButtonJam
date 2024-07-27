extends CharacterBody2D


signal OnStaminaChanged
signal OnHealthChanged
@export_category("PlayerStats")
@export var PlayerSpeed : float = 300.0
@export var JumpVelocity : float = -400.0
@export var MaxStamina : float = 100.0
@export var MaxHealth : float = 300.0
var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")

@export_category("StaminaCost")
@export var runStaminaCost :float  = -5.0
@export var jumpStaminaCost : float= -5.0
@export var fwdAttackStaminaCost: float= -5.0
@export var stabStaminaCost: float= -5.0
@export var sleepStaminaRegen :float= 35.0
@export var idleStaminaRegenfloat :float= 5.0

var currentStamina : float = 0.0
var currentHealth : int= 1
var sleepCounter : int= 0


@export_category("HitboxReferences")
@export var jumpHitbox:CollisionShape2D
@export var fwdAtkHitbox:CollisionShape2D 
@export var stabHitbox: CollisionShape2D

@export_category("AnimReference")
@export var anim : AnimatedSprite2D

func _ready() ->void:
	currentStamina = MaxStamina
	currentHealth = MaxHealth

func _physics_process(delta : float)->void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float)->void:
		pass

func StaminaUpdate(delta : float)->void:
	pass
