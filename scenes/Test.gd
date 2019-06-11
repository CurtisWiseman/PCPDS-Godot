extends Node

var systems # Define systems for use globally.

func _ready():
	systems = get_node('Systems') # Load systems with the Systems node.
	systems.window.screensetting() # Set the default screen setting.
	
	systems.dialogue() # Put the dialogue box on the scene.