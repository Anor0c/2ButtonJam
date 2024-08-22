extends Area2D
signal OnWin

@onready var winScreen = get_node ("../PlayerCharacter/Camera2D/WinMenu")
@onready var audio = get_node("../MusicPlayer")
@onready var winMusic = preload("res://AdhesiveWombat - Night Shade.mp3")

func _on_area_2d_area_entered(_area : Area2D)->void:
	print("You Win Visible")
	winScreen.visible=true
	audio.stream = winMusic
	audio.play()
	emit_signal("OnWin")
