extends ColorRect

var barSize : float

func _ready()->void:
	barSize=scale.x


func _on_player_character_on_health_changed(currentHealth: int, maxHealth: int)->void:
		scale.x=barSize* currentHealth/maxHealth 
