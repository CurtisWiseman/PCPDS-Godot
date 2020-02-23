extends Node

var systems # Define systems for use globally.
var input # Defines variable for taking input.
var playerName # Value to store input in.

signal MyInput_Handled

func _ready():
	systems = $Systems # Load systems with the Systems node.
	
	if !game.loadSaveFile: # Run if not loading a save file.
		systems.dialogue("res://scripts/Common.tres"); # Provides the script to be used and activates the pause menu.
	
	global.emit_signal('finished_loading') # Emit a signal letting nodes know a scene finished loading.

# Where all non-script processing of a scene takes place.
func scene(lineText, index, dialogueNode):
	
	# Use the index to match what line to make something happen on.
	match(index):
		27:	# Take User Input
			game.blockInput = true
			global.pause_input = true

			input = LineEdit.new()
			input.name = 'HandleMyInput'
			input = load('res://scenes/UI/HandleInput.tscn').instance()
			input.node = self
			input.rect_size.x = 500
			input.position = Vector2(990,870)
			input.connect('return_signal', self, 'HandleMyInput')
			systems.canvas.add_child(input)
			yield(self, "MyInput_Handled")

			global.playerName = playerName;

			# Create a player name file.
			var file = File.new()
			file.open("user://playername.tres", File.WRITE)
			file.store_string(playerName)
			file.close()

			global.pause_input = false
			game.blockInput = false
			dialogueNode.emit_signal('empty_line')
			systems.canvas.remove_child(input)
		
		31: # Read the player name
			var file = File.new()
			file.open("user://playername.tres", File.READ)
			var username = file.get_as_text()
			file.close()
			
			if username.findn('Brad Garlinghouse') == -1 and username.findn('BradGarlinghouse') == -1:
				dialogueNode.index = 44
	
	return true



func HandleMyInput(value, passed):
	if passed:
		playerName = value;
		emit_signal("MyInput_Handled")
	else :
		print('Do something about failure')