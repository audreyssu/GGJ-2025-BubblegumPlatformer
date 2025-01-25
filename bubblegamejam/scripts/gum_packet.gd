extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	rotate_y(deg_to_rad(1 * delta * 100))
	
func toggle(value:bool):
	set_visible(value)
	set_deferred("monitoring", value)
	set_deferred("monitorable", value)

#Handles collision events
func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		if body.get_node(body.get_path()).collectGum() == true:
			#queue_free()
			toggle(false)
			$respawnTimer.start()

func respawnTimerTimeout() -> void:
	toggle(true)
