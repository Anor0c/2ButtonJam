extends BasePowerUp

@export var plushIndex : int
func _on_area_entered(col:Area2D)->void:
	print (col, " has touched Doudou")
	super(col)
	
func PowerUpCollected(_player : CharacterBody2D)->void:
	if _player is PlayerChar : 
		ScoreManager.IncrementScore()
		ScoreManager.plushesCollected.append(plushIndex)
		print (ScoreManager.score)
