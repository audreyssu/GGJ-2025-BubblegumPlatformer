extends Node3D

@export var moveSpeedScale: float = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	$platformAnimPlayer.speed_scale *= moveSpeedScale


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
