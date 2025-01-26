extends CharacterBody3D

const MAX_BUBBLES:int = 3

@export_category("Movement Values")
@export var maxSpeed:float = 1.5
var speed:float = 0.0
@export var jumpPower:float = 4.5
@export var acceleration:float = 0.5
@export var airAcceleration:float = 0 #Need to implement this
@export var friction:float = 0.1
@export var airResistance:float = 0 #Need to implement this

@export_category("Misc. Values")
@export var numBubbles:int = MAX_BUBBLES

@onready var cur_checkpoint:Vector3 = position # No checkpoints at start, just go to initial spawn

var jumpSound = preload("res://assets/sounds/Bounce!.mp3")
var bubbleSound = preload("res://assets/sounds/Bubble_Spawn.mp3")

var bubbleScene:PackedScene = preload("res://scenes/bubble.tscn")

signal numBubblesChanged(value)

func _init() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _input(event: InputEvent) -> void:
	#Rotates the camera using the mouse
	if event is InputEventMouseMotion:
		#Found out I had to seperate the rotation across two nodes from the link below
		#https://godotforums.org/d/24512-how-do-a-rotate-an-object-around-a-point/5
		$h.rotate_y(deg_to_rad(-event.screen_relative.x * Settings.sensitivity))
		$h/v.rotate_x(deg_to_rad(-event.relative.y * Settings.sensitivity))
		$h/v.rotation.x = clampf($h/v.rotation.x, deg_to_rad(-89), deg_to_rad(89))

#Rotates the camera using a controller
func rotateCameraController():
	var rotationDir = Input.get_vector("cam_left", "cam_right", "cam_up", "cam_down")
	
	if rotationDir:
		$h.rotate_y(deg_to_rad(-rotationDir.x * 3))
		$h/v.rotate_x(deg_to_rad(-rotationDir.y * 3))
		$h/v.rotation.x = clampf($h/v.rotation.x, deg_to_rad(-89), deg_to_rad(89))
	pass
	
func jump(delta: float):
	velocity.y = jumpPower
	$playerSoundSource.stream = jumpSound
	$playerSoundSource.play()
	
func blowBubble():
	#Blow bubbles
	if Input.is_action_just_pressed("p_blowbubble") and numBubbles > 0:
		numBubbles -= 1
		numBubblesChanged.emit(numBubbles)
		
		var newBubble = bubbleScene.instantiate()
		get_tree().root.get_child(0).add_child(newBubble)
		newBubble.global_position = $charMesh/bubbleSpawnPoint.global_position
		#newBubble.set_scale(Vector3(0.02, 0.02, 0.02))
		
		$bubbleSoundSource.stream = bubbleSound
		$bubbleSoundSource.play()

func _physics_process(delta: float) -> void:	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	rotateCameraController()
	
	blowBubble()

	if Input.is_action_just_pressed("p_jump"):
		if is_on_floor():
			jump(delta)
		else:
			$jumpBufferTimer.start()
			
	#Jump buffering
	if is_on_floor() and $jumpBufferTimer.get_time_left() > 0:
		jump(delta)

	var input_dir := Input.get_vector("p_left", "p_right", "p_foreward", "p_backward")
	var direction = (Vector3(input_dir.x, 0, input_dir.y).rotated(Vector3.UP, $h.rotation.y)).normalized()
	
	var yVel:float = velocity.y
	velocity.y = 0
	
	if direction:
		velocity.x = lerp(velocity.x, direction.x * maxSpeed, acceleration)
		velocity.z = lerp(velocity.z, direction.z * maxSpeed, acceleration)
		
		if is_on_floor():
			$charMesh.look_at(global_position + direction, Vector3.UP)
		
	else:
		velocity.x = lerp(velocity.x, 0.0, friction)
		velocity.z = lerp(velocity.z, 0.0, friction)

	velocity.y = yVel
	#print(velocity)
	
	if Input.is_action_just_pressed("reset"):
			killPlayer()
	
	move_and_slide()


func collectGum():
	if !(numBubbles + 1 > MAX_BUBBLES):
		numBubbles += 1
		numBubblesChanged.emit(numBubbles)
		return true
	return false

func killPlayer():
	print("player killed")
	self.position = cur_checkpoint
