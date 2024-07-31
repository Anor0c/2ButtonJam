class_name Hurtbox
extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready()->void :
	##self.area_entered.connect(on_hitbox_hit)
	self.area_entered.connect(on_gdhitbox_hit)


func on_gdhitbox_hit(col : Area2D)->void :
	print (col)
	if owner.has_method("TakeDamage") and col is GDHitbox:
		owner.TakeDamage (col.damage)
	else :
		print (col.owner," is not a hitbox")
