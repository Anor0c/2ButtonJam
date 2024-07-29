extends CharacterBody2D


const SPEED : float = 300.0
@export var paternLocationArray : Array[Vector2]
var currentPaternLocation : Vector2
var currentLocationIndex : int = 0
var direction : float = 0
#A changer pour faire des patern d'ennemis qui soit modifiables dans l'inspecteur!!!!

func _ready()->void:
	choose_pattern_location()

func choose_pattern_location() ->void: 
	currentLocationIndex +=1
	if currentLocationIndex>paternLocationArray.size()-1:
		currentLocationIndex = 0
	currentPaternLocation = paternLocationArray[currentLocationIndex]
	##print("new Location is Index ",currentLocationIndex ," Its value is ",currentPaternLocation)

func _physics_process(_delta : float)->void:
	direction = clamp (self.position.x - currentPaternLocation.x, -1, 1) 
	if direction > 0.3 or direction < -0.3:
		velocity.x = -direction * SPEED
	else:
		choose_pattern_location()
	move_and_slide()
