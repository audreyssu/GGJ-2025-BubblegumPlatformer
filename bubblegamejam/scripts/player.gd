extends CharacterBody3D

const MAX_BUBBLES:int = 3

@export_category("Movement Values")
@export var moveSpeed:float = 5.0
@export var jumpPower:float = 4.5
@export var acceleration:float = 3
@export var airAcceleration:float = 0 #Need to implement this
@export var friction:float = 5

@export_category("Misc. Values")
@export var numBubbles:int = MAX_BUBBLES

var jumpSound = preload("res://assets/sounds/Bounce!.mp3")

signal numBubblesChanged(value)

func _init() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	pass

func _input(event: InputEvent) -> void:
	#Rotates the camera using the mouse
	if event is InputEventMouseMotion:
		#Found out I had to seperate the rotation across two nodes from the link below
		#https://godotforums.org/d/24512-how-do-a-rotate-an-object-around-a-point/5
		$h.rotate_y(deg_to_rad(-event.screen_relative.x * Settings.sensitivity))
		$h/v.rotate_x(deg_to_rad(-event.relative.y * Settings.sensitivity))
		$h/v.rotation.x = clampf($h/v.rotation.x, deg_to_rad(-89), deg_to_rad(89))
		pass

#Rotates the camera using a controller
func rotateCameraController():
	var rotationDir = Input.get_vector("cam_left", "cam_right", "cam_up", "cam_down")
	
	if rotationDir:
		$h.rotate_y(deg_to_rad(-rotationDir.x * 3))
		$h/v.rotate_x(deg_to_rad(-rotationDir.y * 3))
		$h/v.rotation.x = clampf($h/v.rotation.x, deg_to_rad(-89), deg_to_rad(89))
	pass
	
func jump():
	velocity.y = jumpPower
	$playerSoundSource.stream = jumpSound
	$playerSoundSource.play()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	rotateCameraController()
	
	#Blow bubbles
	if Input.is_action_just_pressed("p_blowbubble") and numBubbles > 0:
		#print("Spawn bubble")
		numBubbles -= 1
		numBubblesChanged.emit(numBubbles)
	
	#for testing UI
	#if Input.is_action_just_pressed("p_blowbubble") and numBubbles < 0:
	#	numBubbles = MAX_BUBBLES

	if Input.is_action_just_pressed("p_jump"):
		if is_on_floor():
			jump()
		else:
			$jumpBufferTimer.start()
			
	#Jump buffering
	if is_on_floor() and $jumpBufferTimer.get_time_left() > 0:
		jump()

	var input_dir := Input.get_vector("p_left", "p_right", "p_foreward", "p_backward")
	var direction = (Vector3(input_dir.x, 0, input_dir.y).rotated(Vector3.UP, $h.rotation.y)).normalized()
	
	if direction:
		#velocity.x = direction.x * moveSpeed
		#velocity.z = direction.z * moveSpeed
		velocity.x = move_toward(velocity.x, direction.x * moveSpeed, acceleration * delta)
		velocity.z = move_toward(velocity.z, direction.z * moveSpeed, acceleration * delta)
		$charMesh.look_at(global_position + direction, Vector3.UP)
	else:
		#velocity.x = move_toward(velocity.x, 0, moveSpeed)
		#velocity.z = move_toward(velocity.z, 0, moveSpeed)
		velocity.x = move_toward(velocity.x, 0, friction * delta)
		velocity.z = move_toward(velocity.z, 0, friction * delta)

	move_and_slide()

func collectGum():
	if !(numBubbles + 1 > MAX_BUBBLES):
		numBubbles += 1
		numBubblesChanged.emit(numBubbles)
		return true
	return false
