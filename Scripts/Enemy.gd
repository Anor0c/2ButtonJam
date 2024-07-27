extends Node2D

@export var health : int =1
# Called when the node enters the scene tree for the first time.
func TakeDamage (damage : int)->void:
	health+=damage
	print (self, " has taken ", damage, " damage")
	if health==0:
		queue_free()
