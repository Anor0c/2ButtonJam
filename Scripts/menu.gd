extends Control

@export var focusButton : Button
@onready var startButton : Button = get_node("PlayButton")
@onready var creditButton : Button = get_node("CreditButton")
@onready var quitButton : Button = get_node("QuitButton")
@onready var backButton : Button = get_node("BackButton")
@onready var controlsButton : Button = get_node("ControlsButton")
@onready var title : TextureRect = get_node("Title")

@export var creditLabel : Label
@export var controlsLabel : Label

func _ready()->void:
	if not MenuManager.showMainMenu : queue_free()
	_on_controls_button_pressed()
	

func _on_play_button_pressed()->void:
	MenuManager.showMainMenu = false
	queue_free()


func _on_credit_button_pressed()->void:
	creditLabel.visible=true
	startButton.visible = false
	creditButton.visible = false
	quitButton.visible = false
	backButton.visible = true
	controlsButton.visible = false
	title.visible = false
	backButton.grab_focus()


func _on_quit_button_pressed()->void:
	get_tree().quit()


func _on_back_button_pressed()->void:
	creditLabel.visible= false
	controlsLabel.visible = false
	startButton.visible = true
	creditButton.visible =true
	quitButton.visible = true
	controlsButton.visible = true
	title.visible = true
	backButton.visible=false
	focusButton.grab_focus()



func _on_controls_button_pressed():
	controlsLabel.visible=true
	startButton.visible = false
	creditButton.visible = false
	quitButton.visible = false
	controlsButton.visible = false
	backButton.visible = true
	title.visible = false
	backButton.grab_focus()
