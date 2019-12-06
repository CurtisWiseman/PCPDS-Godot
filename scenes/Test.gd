extends Node

var systems # Define systems for use globally.

func _ready():
	systems = $Systems # Load systems with the Systems node.
	
	if !game.loadSaveFile: # Run if not loading a save file.
		systems.dialogue("res://scripts/test_script.tres"); # Provides the script to be used and activates the pause menu.
		systems.display.background('res://images/backgrounds/WayToSchool - colors without J.PNG', 'image') # Set the background.
		game.safeToSave = true # Tell the game it's safe to save.
	
	else: # If loading a save file then emit a signal to continue loading once scene is ready.
		game.emit_signal('continue_loading')



# Where all non-script processing of a scene takes place.
func scene(text):
	
	# The "LINE" portion should be a unique substring.
	# Meaning it should identify only one line in the script.
	if "LINE".is_subsequence_ofi(text):
		pass