extends CanvasLayer

@onready var retryButton:Button = get_node("Control/RetryButton")
@export var mainMenu: Node
@export var plushesUI : Array[TextureRect] 
var plush1 : int = 1
var plush2 : int = 2
var plush3 : int = 3
var plush4 : int = 4
func _on_retry_button_pressed()->void:
	self.visible = false 
	ScoreManager.ResetScore()
	get_tree().reload_current_scene()

func _on_quit_button_pressed()->void:
	get_tree().quit()


func _on_game_over()->void:
	visible = true
	retryButton.grab_focus()


func _on_win_box_on_win():
	print (ScoreManager.plushesCollected)
	if not ScoreManager.plushesCollected.has(plush1):
		plushesUI[0].modulate= Color.BLACK
	if not ScoreManager.plushesCollected.has(plush2):
		plushesUI[1].modulate= Color.BLACK
	if not ScoreManager.plushesCollected.has(plush3):
		plushesUI[2].modulate= Color.BLACK
	if not ScoreManager.plushesCollected.has(plush4):
		plushesUI[3].modulate= Color.BLACK
			
