extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func swap_fullscreen_mode():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _on_increase_sensitivity_pressed() -> void:
	Settings.sensitivity += .01
	print(Settings.sensitivity)

func _on_decrease_sensitivity_pressed() -> void:
	Settings.sensitivity -= .01
	print(Settings.sensitivity)


func _on_fullscreen_toggle_pressed() -> void:
	swap_fullscreen_mode()
