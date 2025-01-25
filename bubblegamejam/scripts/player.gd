extends CharacterBody3D

const MAX_BUBBLES:int = 3

@export var moveSpeed:float = 5.0
@export var jumpPower:float = 4.5

@export var numBubbles:int = MAX_BUBBLES


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	#Blow bubbles
	if Input.is_action_just_pressed("p_blowbubble") and numBubbles > 0:
		numBubbles -= 1
	
	#for testing UI
	if Input.is_action_just_pressed("p_blowbubble") and numBubbles <= 0:
		numBubbles = MAX_BUBBLES

	# Handle jump.
	if Input.is_action_just_pressed("p_jump") and is_on_floor():
		velocity.y = jumpPower

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("p_left", "p_right", "p_foreward", "p_backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * moveSpeed
		velocity.z = direction.z * moveSpeed
	else:
		velocity.x = move_toward(velocity.x, 0, moveSpeed)
		velocity.z = move_toward(velocity.z, 0, moveSpeed)

	move_and_slide()
