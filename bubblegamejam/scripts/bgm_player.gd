extends AudioStreamPlayer

@export var loopTime:float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if stream:
		play();
	else:
		print("You forgot to add a stream")

func onBGMFinished() -> void:
	if stream:
		play(loopTime)
