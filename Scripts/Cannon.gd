extends Node2D

const packedProj : PackedScene = preload("res://Scenes/projectile.tscn")
@onready var player : CharacterBody2D = get_node("/root/GameplayScene/PlayerCharacter")
@export var TimeToShoot : float = 1.5
var currentTimeToShoot : float
@export var AimSpeed : float = 50
@export var shootDistanceX : float 
@export var shootDistanceY : float

func  _ready()->void:
	currentTimeToShoot = TimeToShoot

func Shoot ()->void:
	var aimVector : Vector2 =player.global_position-global_position
	if abs(aimVector.x)<abs(shootDistanceX) and abs(aimVector.y)<abs(shootDistanceY):
		print (aimVector)
		var projectInstance:Projectile= packedProj.instantiate()
		projectInstance.direction= aimVector.normalized()
		projectInstance.global_position = global_position
		get_tree().current_scene.add_child(projectInstance)

	else :
		print ("X is ",aimVector.x)
		print ("Y is ", aimVector.y)



func _process(delta:float)->void:
	if currentTimeToShoot>0: 
		currentTimeToShoot-=delta
		return
	else : 
		Shoot()
		currentTimeToShoot = TimeToShoot
		
