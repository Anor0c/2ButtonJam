extends Label


# Called when the node enters the scene tree for the first time.


func _on_area_2d_area_entered(_area : Area2D)->void:
	print("You Win Visible")
	visible=true
