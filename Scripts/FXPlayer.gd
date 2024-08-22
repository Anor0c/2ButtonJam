extends AudioStreamPlayer

var collectibles : Array[BasePowerUp] 
var collectibleSound : AudioStream = preload("res://pickup3.ogg")


func _on_doudou_on_power_up_collected()->void:
	stream=collectibleSound
	play()
