extends Control

@export var focusButton : Button
@onready var startButton : Button = get_node("PlayButton")
@onready var creditButton : Button = get_node("CreditButton")
@onready var quitButton : Button = get_node("QuitButton")
@onready var backButton : Button = get_node("Label/BackButton")
@onready var retryButton : Button = get_node("RetryButton")

@export var creditLabel : Label

func _ready()->void:
	focusButton.grab_focus()
	

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
	focusButton.grab_focus()


func _on_retry_button_pressed()->void:
	self.visible = false 
	get_tree().reload_current_scene()
	
