extends RigidBody3D

var max_height = self.position.y + 3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if self.position.y >= max_height:
		self.queue_free()
	self.position.y+= 0.002
	pass


func _on_body_entered(body: Node) -> void:
	print(body.name)
	if body.name == "player":
		body.velocity.y = 10
		self.queue_free()
