class_name Hurtbox
extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready()->void :
	##self.area_entered.connect(on_hitbox_hit)
	self.area_entered.connect(on_gdhitbox_hit)

"""func on_hitbox_hit(col : Hitbox, )->void :
	print (col)
	if owner.has_method("TakeDamage"):
		owner.TakeDamage( col.Damage)
		print ("Health Present")"""

func on_gdhitbox_hit(gdCol : GDHitbox)->void :
	print (gdCol.owner)
	if owner.has_method("TakeDamage"):
		owner.TakeDamage (gdCol.damage)
