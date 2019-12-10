extends Node

var systems # Define systems for use globally.

func _ready():
	systems = $Systems # Load systems with the Systems node.
	
	if !game.loadSaveFile: # Run if not loading a save file.
		systems.dialogue("res://scripts/test_script.tres"); # Provides the script to be used and activates the pause menu.
		systems.display.background('res://images/backgrounds/WayToSchool - colors without J.PNG', 'image') # Set the background.
	
	global.emit_signal('finished_loading') # Emit a signal letting nodes know a scene finished loading.



# Where all non-script processing of a scene takes place.
func scene(lineText, index):
	
	# Use the index to match what line to make something happen on.
	match(index):
		0: pass