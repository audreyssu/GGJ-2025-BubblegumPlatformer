extends RigidBody3D

#vars for saving the player node and it's collision index
var player_node
var collider_player_index

#flag for the _integrate_forces func
var change_velocity = false

#max hieght for bubble, value is arbitrary. Found 3 to be ok
var max_height = self.position.y + 3

#how much we want the player to bounce off the bubble
var bounce_factor = 10

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#increase height over time and deletes itself
	if self.position.y >= max_height:
		#self.queue_free()
		playPopSound()
	self.position.y+= 0.002
	pass

#gets collision. Saves player if found and changes velocity flag
func _on_body_entered(body: Node) -> void:
	if body.name == "player":
		collider_player_index =self.get_colliding_bodies().find(body)
		player_node = body
		change_velocity = true
		#body.velocity.y = 10
		
#built-in func that allows us to change aspect with more control
func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	#if we have contact with player, change their velocity
	if change_velocity == true:
		player_node.velocity = -state.get_contact_local_normal(collider_player_index)* bounce_factor
		change_velocity = false
		#self.queue_free()
		playPopSound()
		
		
# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.

func playPopSound():
	set_contact_monitor(false)
	set_visible(false)
	if $popSoundSource.stream:
		$popSoundSource.play()
	else:
		call_deferred("queue_free")

func _on_pop_sound_source_finished() -> void:
	call_deferred("queue_free")
	pass # Replace with function body.
