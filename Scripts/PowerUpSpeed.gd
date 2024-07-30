class_name Slippers
extends BasePowerUp


func _on_area_entered(col:Area2D)->void:
	print (col, " has touched Slippers")
	super(col)
	
func PowerUpCollected(_player : CharacterBody2D)->void:
	if _player is PlayerChar : 
		_player.PlayerSpeed *=2
		
