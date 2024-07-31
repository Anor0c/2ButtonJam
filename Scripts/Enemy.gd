extends Node2D
signal EnemyDeath
const packedExplosion : PackedScene = preload("res://Scenes/feather_explosion.tscn")

@onready var explosion : AnimatedSprite2D = packedExplosion.instantiate() 
@onready var hitbox : GDHitbox = get_node("CharacterBody2D/GDHitbox")
@export var health : int =1

func _ready():
	explosion.connect("animation_finished", self.Death)

func TakeDamage (damage : int)->void:
	health+=damage
	print (self, " has taken ", damage, " damage")
	if health==0:
		emit_signal("EnemyDeath")
		hitbox.monitorable = false 
		hitbox.monitoring = false
		add_child(explosion)
		explosion.play()

func Death(): 
	queue_free()
