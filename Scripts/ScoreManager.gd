extends Node

signal OnScoreUpdated (_score:int) 
var score : int = 0

func ResetScore()->void:
	score = 0
	emit_signal("OnScoreUpdated", score)

func IncrementScore()->void:
	score+=1
	emit_signal("OnScoreUpdated", score)
