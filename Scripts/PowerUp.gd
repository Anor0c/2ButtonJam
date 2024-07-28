class_name BasePowerUp
extends Area2D

@export var player : CharacterBody2D

func _ready()->void:
	print (player)
	
func _on_area_entered(col : Area2D)->void:
	if col.owner == player:
		PowerUpCollected(player)
		queue_free()

func PowerUpCollected(_player : CharacterBody2D)->void:
	pass
