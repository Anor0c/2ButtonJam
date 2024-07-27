extends ColorRect

var barSize : float
# Called when the node enters the scene tree for the first time.
func _ready()->void:
	barSize=scale.x

func _on_player_character_on_stamina_changed(currentStamina : float, maxStamina : float)->void:
	scale.x=barSize* currentStamina/maxStamina 
