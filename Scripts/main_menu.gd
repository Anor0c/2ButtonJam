extends Control
@export var startButton : Button
@export var creditButton : Button
@export var quitButton : Button
@export var backButton : Button

@export var creditLabel : Label

func _ready()->void:
	startButton.grab_focus()

func _on_play_button_pressed()->void:
	self.visible = false


func _on_credit_button_pressed()->void:
	creditLabel.visible=true
	startButton.visible = false
	creditButton.visible = false
	quitButton.visible = false
	backButton.grab_focus()


func _on_quit_button_pressed()->void:
	get_tree().quit()


func _on_back_button_pressed()->void:
	creditLabel.visible= false
	startButton.visible = true
	creditButton.visible =true
	quitButton.visible = true
	startButton.grab_focus()
