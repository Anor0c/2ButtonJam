extends BasePowerUp


func _on_area_entered(col:Area2D)->void:
	print (col, " has touched Doudou")
	super(col)
	
func PowerUpCollected(_player : CharacterBody2D)->void:
	if _player is PlayerChar : 
		ScoreManager.IncrementScore()
		print (ScoreManager.score)
