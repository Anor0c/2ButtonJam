extends CanvasLayer

@onready var retryButton:Button = get_node("Control/RetryButton")
@export var mainMenu: Node

func _on_retry_button_pressed()->void:
	self.visible = false 
	ScoreManager.ResetScore()
	get_tree().reload_current_scene()

func _on_quit_button_pressed()->void:
	get_tree().quit()


func _on_game_over()->void:
	visible = true
	retryButton.grab_focus()
