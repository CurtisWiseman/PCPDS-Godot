extends Node

var systems # Define systems for use globally.
var input # Defines variable for taking input.
var playerName # Value to store input in.

signal MyInput_Handled

func _ready():
	systems = $Systems # Load systems with the Systems node.
	
	if !game.loadSaveFile: # Run if not loading a save file.
		systems.dialogue("res://scripts/test_script.tres"); # Provides the script to be used and activates the pause menu.
		systems.display.background('res://images/backgrounds/WayToSchool - colors without J.PNG', 'image') # Set the background.
	
	global.emit_signal('finished_loading') # Emit a signal letting nodes know a scene finished loading.



# Where all non-script processing of a scene takes place.
func scene(lineText, index, dialogueNode):
	
	# Use the index to match what line to make something happen on.
	match(index):
		7:	# Take User Input
			global.pause_input = true
			
			input = LineEdit.new()
			input.name = 'HandleMyInput'
			input = load('res://scenes/UI/HandleInput.tscn').instance()
			input.node = self
			input.position = Vector2(620,872)
			input.connect('return_signal', self, 'HandleMyInput')
			systems.canvas.add_child(input)
			yield(self, "MyInput_Handled")
			
			global.playerName = playerName;
			
			# Create a player name file.
			var file = File.new()
			file.open("user://playername.tres", File.WRITE)
			file.store_string(playerName)
			file.close()
			
			systems.canvas.remove_child(input)
			global.pause_input = false
			dialogueNode.emit_signal('empty_line')
	
	return true



func HandleMyInput(value, passed):
	if passed:
		playerName = value;
		emit_signal("MyInput_Handled")
	else :
		print('Do something about failure')