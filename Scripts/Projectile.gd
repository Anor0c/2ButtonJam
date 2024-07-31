class_name Projectile
extends GDHitbox

var speed:float = 200

var direction :Vector2= Vector2.LEFT

func _physics_process(delta:float)->void:
	position += speed*direction * delta


func _on_area_entered(_area:Area2D)->void:
	print(_area)
	queue_free()
