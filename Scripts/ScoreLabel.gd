extends Label

func _ready()->void:
	ScoreManager.connect("OnScoreUpdated", UpdateLabel)

func UpdateLabel(score : int)->void: 
	text = str(score)
