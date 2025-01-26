extends Node3D

@onready var pause_menu = $Pause_Menu
var game_paused = false

@onready var settings_menu = $Settings_Menu
var settings_open = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause_game"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		pauseMenu()
		
func pauseMenu():
	if game_paused:
		pause_menu.hide()
		Engine.time_scale = 1
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		pause_menu.show()
		Engine.time_scale = 0
		
	game_paused = !game_paused

func _on_settings_pressed() -> void:
	pause_menu.hide()
	settings_menu.show()


func _on_button_pressed() -> void:
	settings_menu.hide()
	pause_menu.show()
