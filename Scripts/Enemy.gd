extends Node2D
signal EnemyDeath
const packedExplosion : PackedScene = preload("res://Scenes/feather_explosion.tscn")

@onready var explosion : AnimatedSprite2D = packedExplosion.instantiate() 
@onready var hitbox : GDHitbox = get_node("CharacterBody2D/GDHitbox")
@onready var audio : AudioStreamPlayer = get_node("AudioStreamPlayer")
@export var health : int =1

func _ready()->void:
	explosion.connect("animation_finished", self.Death)

func TakeDamage (damage : int)->void:
	health+=damage
	print (self, " has taken ", damage, " damage")
	if health==0:
		emit_signal("EnemyDeath")
		hitbox.queue_free()
		#explosion.global_position = global_position
		#print (explosion.global_position, global_position)
		add_child(explosion)
		explosion.play()
		audio.play()

func Death()->void: 
	queue_free()
