extends AnimatedSprite2D

@export var enemyBody : CharacterBody2D 
# Called when the node enters the scene tree for the first time.


func _ready():
	self.play("Idle")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta : float) ->void:
	if enemyBody.velocity.x>0 :
		self.flip_h = true
	else :
		self.flip_h=false
