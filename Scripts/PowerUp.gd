class_name BasePowerUp
extends Area2D

signal OnPowerUpCollected

@onready var player : CharacterBody2D = get_node("../PlayerCharacter")


func _on_area_entered(col : Area2D)->void:
	if col.owner == player:
		emit_signal("OnPowerUpCollected")
		PowerUpCollected(player)
		print ("pickedUp")
		queue_free()

func PowerUpCollected(_player : CharacterBody2D)->void:
	pass
