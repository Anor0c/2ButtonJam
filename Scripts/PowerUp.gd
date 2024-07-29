class_name BasePowerUp
extends Area2D

@onready var player : CharacterBody2D = get_node("../PlayerCharacter")

func _ready()->void:
	print (player)
	
func _on_area_entered(col : Area2D)->void:
	if col.owner == player:
		PowerUpCollected(player)
		print ("pickedUp")
		queue_free()

func PowerUpCollected(_player : CharacterBody2D)->void:
	pass
