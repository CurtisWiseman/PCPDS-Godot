extends Node

var systems # Define systems for use globally.

func _ready():
	systems = $Systems # Load systems with the Systems node.
	systems.dialogue("res://scripts/script_document.txt"); # Provides the script to be used and activates the pause menu.
	systems.display.background('res://images/backgrounds/WayToSchool - colors without J.PNG', 'image') # Set the background.

# Where all non-script processing of a scene takes place.
func scene(text):
	
	# The "LINE" portion should be a unique substring.
	# Meaning it should identify only one line in the script.
	if "LINE".is_subsequence_ofi(text):
		pass