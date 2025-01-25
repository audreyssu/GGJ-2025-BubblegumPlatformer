extends RigidBody3D


# Experimental Variables
#var collided_player_body
#var colliding_player_index
#var change_velocity = false




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Changes player velocity on contact
func _on_body_entered(body: Node) -> void:
	print("getting something")
	if body.is_in_group("player"):
		print("got player")
		body.velocity.y = 10
		print("velocity changed")
		
	# ----- Experimental normals code
	#print("getting something")
	#if body.is_in_group("player"):
		#collided_player_body = body
		#print("got player")
		#colliding_player_index = get_contact_count()
		#change_velocity = true
		#print("velocity changed")
		
		

	
# ----- Experimental normals code
#func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	#if change_velocity == true:
		#collided_player_body.velocity = state.get_contact_local_normal(colliding_player_index) * 10
		#change_velocity = false
	
	
	
	
	
