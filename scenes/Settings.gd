extends Node

var systems # Define systems for use globally.

func _ready():
	systems = $Systems # Load systems with the Systems node.
	systems.window.screensetting() # Set the default screen setting.

func _process(delta):
	if systems.winBMvisible == true and Input.is_action_just_pressed("advance_text"):
		systems.remove_child(systems.winBM)
		systems.winBMvisible = false