extends Control
@onready var gum_bar = $Gum1

var gum_remaining = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gum_bar.value = gum_remaining
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_player_num_bubbles_changed(value: Variant) -> void:
	if Input.is_action_just_pressed("p_blowbubble"):
		gum_remaining -= .334
		gum_bar.value = gum_remaining
	
	else:
		gum_remaining += .334
		gum_bar.value = gum_remaining
