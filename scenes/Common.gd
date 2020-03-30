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
	if index < 100:
		if lineText.find("Well, nice to meet you Gibbon. I’m") > -1:
			game.blockInput = true
			global.pause_input = true
			global.dialogueBox.waiting_for_player_name = true
			game.safeToSave = false
			
			input = LineEdit.new()
			input.name = 'HandleMyInput'
			input = load('res://scenes/UI/HandleInput.tscn').instance()
			input.node = self
			input.rect_size.x = 1000
			var x_offset = global.defaultFont.get_string_size("Well, nice to meet you Gibbon. I’m ").x
			input.position = global.dialogueBox.get_node("Dialogue").get_global_position()+Vector2(x_offset, 0)
			input.connect('return_signal', self, 'HandleMyInput')
			systems.canvas.add_child(input)
			yield(self, "MyInput_Handled")

			global.playerName = playerName;
			global.dialogueBox.waiting_for_player_name = false
			global.pause_input = false
			game.safeToSave = true
			game.blockInput = false
			dialogueNode.emit_signal('empty_line')
			systems.canvas.remove_child(input)
		
		elif lineText.find("[If the player inputs") > -1:
			if global.playerName.to_lower().replace(" ", "").find('bradgarlinghouse') == -1 :
				for i in range(index, index+300):
					if dialogueNode.dialogue[i].find("[placeholder]") > -1:
						dialogueNode.index = i
	return true



func HandleMyInput(value, passed):
	if passed:
		playerName = value;
		emit_signal("MyInput_Handled")
	else :
		print('Do something about failure')
