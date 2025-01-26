extends Node
# make an area that when player touches, save position to global script
# on player death, telport them back to last checkpoint
# particle effects that change colors depending on active checkpoint?
# could group all checkpoints and reset all others when current one is activated

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Inactive_Checkpoints")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_collision(body):
	if body.is_in_group("Player") and self.is_in_group("Inactive_Checkpoints"):
		get_tree().call_group("Active_Checkpoint", "set_to_inactive") # Just in case there is more than one active for some reason
		self.set_to_active()
		body.cur_checkpoint = $respawnPoint.global_position
		print("checkpoint set")
	elif self.is_in_group("Active_Checkpoint"):
		print("this checkpoint is already active")
	else:
		print("checkpoint not set")
		
		
		
func set_to_active():
	#$checkpointMesh.mesh.material.albedo_color = Color(0, 1, 0, 1)
	add_to_group("Active_Checkpoint")
	remove_from_group("Inactive_Checkpoints")

func set_to_inactive():
	#$checkpointMesh.mesh.material.albedo_color = Color(1, 1, 1, 1)
	add_to_group("Inactive_Checkpoints")
	remove_from_group("Active_Checkpoint")
	
	
