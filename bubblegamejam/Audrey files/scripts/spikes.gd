extends Area3D


func _ready():
	pass
	
	
func _process(delta):
	pass


func _on_player_collision(body):
	if body.is_in_group("Player"):
		body.killPlayer()
