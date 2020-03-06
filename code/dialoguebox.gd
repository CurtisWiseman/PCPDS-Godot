extends TextureRect

signal empty_line
signal sentence_end
signal choiceChosen
signal dupeCheckFinished
signal mouse_click
signal transition_finish

var dialogue := PoolStringArray() #All of the lines in the current text file. Not using a regular array for better performance
var index := 0 #Index of current line of dialogue
var start := 0
var dialogueScript: String
var regex := RegEx.new()
var systems
var choices
var inChoice
var chosenChoices
var displayChoices = []
var displayingChoices := false
var waitTimer := Timer.new()
var numOfChoices := 0
var fade = false
var notsame
var overlays = []
var lastCG
var lastBody
var lastSpoken = 0
var lastLayers
var lastBGNode
var lastBGType
var lastChoices
var lastInChoice
var lastChosenChoices
var CG = null

func _ready(): 
	systems = global.rootnode.get_node("Systems") # Assign the systems no to systems.

	#Opens the document containing the scene's script (as in the dialogue)
	var f = File.new()
	f.open(dialogueScript, File.READ)
	
#	var err = f.open_encrypted_with_pass("res://document.txt", File.READ, "password") ability to read encrypted files 
	#Stores every line of dialogue in the array
	while not f.eof_reached():
		dialogue.push_back(f.get_line())
	f.close()
	self.connect("empty_line", self, "_on_Dialogue_has_been_read")
	start = index
	
	# Define a wait timer.
	waitTimer.one_shot = true
	waitTimer.autostart = false
	add_child(waitTimer)
	
	global.pause_input = true # Pause input during first load.
	emit_signal("empty_line") #Signals to display first line of dialogue


#Nametag is the label above the textbox, dialogue's say is what updates the textbox.
func say(words, character = "", voice = null):
	$Nametag.text = character
	$Dialogue.say(words, voice)


# Function to calculate the number of unseen choices.
func choice_calc(choice):
	# Figure out if there are more unseen choices.
	var pastChoice = false
	for item in choices:
		if choice == item:
			pastChoice = true
	if dialogue[index].findn('UNDO') != -1:
		pastChoice = true
	
	if !pastChoice:
		choices.append(choice) # Add to choices that have been seen.
		displayChoices.append(choice) # The choices to display.
		numOfChoices += 1
		index += 1
	
	# If no more unseen choices then display the gathered choices.
	if dialogue[index].length() == 0 or dialogue[index][0] != '*' or pastChoice:
		if numOfChoices == 1:
			choice_display(displayChoices[0], 370, 420)
		elif numOfChoices == 2:
			choice_display(displayChoices[0], 335, 385)
			choice_display(displayChoices[1], 405, 455)
		elif numOfChoices == 3:
			choice_display(displayChoices[0], 300, 350)
			choice_display(displayChoices[1], 370, 420)
			choice_display(displayChoices[2], 440, 490)
		elif numOfChoices == 4:
			choice_display(displayChoices[0], 265, 315)
			choice_display(displayChoices[1], 335, 385)
			choice_display(displayChoices[2], 405, 455)
			choice_display(displayChoices[3], 475, 525)
		elif numOfChoices == 5:
			choice_display(displayChoices[0], 230, 280)
			choice_display(displayChoices[1], 300, 350)
			choice_display(displayChoices[2], 370, 420)
			choice_display(displayChoices[3], 440, 490)
			choice_display(displayChoices[4], 510, 560)
		
		return
	
	choice  = dialogue[index].lstrip('*')
	choice = choice.rstrip('*')
	choice_calc(choice) # Recusivly call until choice_display() is called.


# Function to display unseen choices.
func choice_display(text, top, bot):
	
	var choice = TextureRect.new()
	choice.name = text
	choice.texture = load('res://images/dialoguebox/choiceButton.png')
	choice.margin_top = top
	choice.margin_bottom = bot
	choice.margin_left = 0
	choice.margin_right = 1920
	
	var choicebutton = TextureButton.new()
	choicebutton.margin_top = 0
	choicebutton.margin_bottom = 50
	choicebutton.margin_left = 400
	choicebutton.margin_right = 1520
	
	var choicetext = RichTextLabel.new();
	choicetext.name = 'Choice 1 Text'
	choicetext.bbcode_enabled = true
	choicetext.margin_top = 10
	choicetext.margin_bottom = 50
	choicetext.margin_left = 0
	choicetext.margin_right = 1920
	choicetext.add_font_override("normal_font", global.defaultChoiceFont)
	choicetext.add_font_override("italics_font", global.defaultChoiceFontItalic)
	choicetext.add_font_override("bold_font", global.defaultChoiceFontBold)
	choicetext.set_theme(global.textTheme)
	choicetext.bbcode_text = '[center]' + text + '[/center]'
	
	choicebutton.connect('pressed', self, 'choice_pressed', [text, choicebutton])
	choicebutton.connect('mouse_entered', self, 'choice_hovered', [choice])
	choicebutton.connect('mouse_exited', self, 'choice_unhovered', [choice])
	
	choice.add_child(choicetext)
	choice.add_child(choicebutton)
	systems.canvas.add_child(choice)


# Handle what happens when a choice is chosen.
func choice_pressed(choice, button):
	
	for item in displayChoices:
		systems.canvas.remove_child(systems.canvas.get_node(item))
	
	waitTimer.wait_time = 1
	waitTimer.start()
	yield(waitTimer, 'timeout')
	
	displayChoices = []
	numOfChoices = 0
	chosenChoices.append(choice)
	emit_signal('choiceChosen')
	global.pause_input = false
	displayingChoices = false


# Functions to change color when hovered/unhovered.
func choice_hovered(choiceNode): choiceNode.texture = load('res://images/dialoguebox/choiceButtonHovered.png')
func choice_unhovered(choiceNode): choiceNode.texture = load('res://images/dialoguebox/choiceButton.png')


# Function to keep items from the last spoken line.
func lastKeep(idx):
	lastCG = CG
	lastSpoken = idx
	lastChoices = choices.duplicate(true)
	lastInChoice = inChoice
	lastChosenChoices = chosenChoices.duplicate(true)
	lastLayers = systems.display.layers.duplicate(true)
	lastBGNode = systems.display.bgnode
	lastBGType = systems.display.bgtype


# The main dialogue function.
func _on_Dialogue_has_been_read(setIndex=false):
	
	if index < dialogue.size(): #Checks to see if end of document has been reached
		#Skips empty lines e.g spacing
		while dialogue[index].length() == 0:
			index += 1
	
	#Reacts differently depending on the start of the current line.
		# Load while on first line.
		if index == start:
			waitTimer.wait_time = 0.5
			waitTimer.start()
			yield(waitTimer, "timeout")
			global.pause_input = false
			game.safeToSave = true
			# Emit a signal letting nodes know a scene finished loading.
			global.emit_signal('finished_loading')
		
		# COMMENTS/COMMANDS
		if  dialogue[index].begins_with("["):
			
			if dialogue[index].findn('9/11') != -1:
				regex.compile('9/11')
				dialogue[index] = regex.sub(dialogue[index], "911", true)
			
			if dialogue[index].findn('leaves') != -1:
				global.pause_input = true
				var command = dialogue[index].lstrip('[')
				command = command.rstrip(']')
				command = command.split(' ', false)
				
				var character = command[0]
				var speed = 3
				
				if command.size() == 3:
					speed = int(command[2])
				
				var characterToRemove = null
				var rmIndex

				for i in range(0, systems.display.layers.size()):
					var layer = systems.display.layers[i]['name']
					#QUICK HACK! Layers can also be CG etc!
					#This caused problems if the character leaving has a name that appears in the CG name
					if layer.findn(character.to_lower()) != -1 and (CG == null or systems.display.getname(CG) != layer):
						characterToRemove = systems.display.layers[i]['node']
						rmIndex = i
						break
				
				if characterToRemove != null:
					systems.display.fadealpha(characterToRemove, 'out', speed)
					yield(systems.display, 'transition_finish')
					systems.display.remove(characterToRemove, rmIndex)
				
				global.pause_input = false
			
			elif dialogue[index].findn('fade to black') != -1:
				if global.fading: yield(global, 'finished_fading')
				global.pause_input = true
				fadeblackalpha(systems.blackScreen, 'out', 1, 0.01)
				yield(self, 'transition_finish')
				global.pause_input = false
			
			elif dialogue[index].findn('fade from black') != -1:
				if global.fading: yield(global, 'finished_fading')
				global.pause_input = true
				fadeblackalpha(systems.blackScreen, 'in', 1, 0.01)
				yield(self, 'transition_finish')
				global.pause_input = false
			
			elif dialogue[index].findn('cut to black') != -1: fadeblackalpha(systems.blackScreen, 'out', 100)
			elif dialogue[index].findn('cut from black') != -1: fadeblackalpha(systems.blackScreen, 'in', 100)
			
			elif dialogue[index].findn('SLIDE') != -1:
				var command = dialogue[index].lstrip('[')
				command = command.rstrip(']')
				command = command.replace(',', '')
				command = command.split(' ')
				var did_slide = false
				for i in range(0, systems.display.layers.size()):
					var layer = systems.display.layers[i]['name']
					if layer.findn(command[1].to_lower()) != -1:
						if command.size() == 3:
							did_slide = true
							parse_move(['slide', command[2]], '"'+systems.display.layers[i]['path']+'"', 0)
						elif command.size() == 4:
							did_slide = true
							parse_move(['slide', command[2], command[3]], '"'+systems.display.layers[i]['path']+'"', 0)
						break
				if not did_slide:
					prints("WARNING: BAD SLIDE COMMAND: ", command)
					#unpause it here because parse_move would noramlly do that for us, but this is a safety fallback
					global.pause_input = false
			elif dialogue[index].findn('Song:') != -1:
				var track = dialogue[index].lstrip('[')
				track = track.rstrip(']')
				track = track.substr(6,dialogue[index].length()-1)
				systems.sound.music("res://sounds/music/" + track + ".ogg", true)
			
			elif dialogue[index].findn('SFX:') != -1:
				var sfx = dialogue[index].lstrip('[')
				sfx = sfx.rstrip(']')
				sfx = sfx.substr(5,dialogue[index].length()-1)
				systems.sound.sfx("res://sounds/sfx/" + sfx + ".ogg")
			
			elif dialogue[index].findn('StopMusic') != -1:
				systems.sound.stop(systems.sound.audioname(systems.sound.playing['path']))
			
			elif dialogue[index].findn('StopSFX') != -1:
				systems.sound.stop_SFX(systems.sound.audioname(systems.sound.playingSFX['path']))
			
			elif dialogue[index].findn('Location:') != -1:
				
				if overlays != []:
					for path in overlays:
						systems.display.remove_name(path)
					
					overlays = []
				
				var loc = dialogue[index].lstrip('[')
				var ovr = null
				
				loc = loc.strip_edges(true, true)
				loc = loc.rstrip(']')
				loc = loc.substr(10,dialogue[index].length()-1)
				loc = loc.strip_edges(true, true)
				
				if loc.find(',') != -1:
					var arr = loc.split(',', false, 1)
					loc = arr[0]
					ovr = [arr[1]]
				
				var locIndex = global.locationNames.find(loc)
				if locIndex != -1:
					systems.display.background(global.locations[locIndex], 'image')
				else:
					print('Error: No background named ' + loc)
				
				if ovr != null:
					var ovrLayer = [3]
					
					if ovr[0].find(',') != -1:
						ovr = ovr[0].split(',', false)
						
						ovrLayer = []
						for i in range(0, ovr.size()):
							ovrLayer.append(3)
					
					for i in range(0, ovr.size()):
						ovr[i] = ovr[i].strip_edges(true, true)
						
						if ovr[i].find('|') != -1:
							var arr = ovr[i].split('|', false, 1)
							ovr[i] = arr[0]
							ovrLayer[i] = int(arr[1])
					
					for i in range(0, ovr.size()):
						var ovrIndex = global.locationNames.find(ovr[i])
						if ovrIndex != -1:
							systems.display.image(global.locations[ovrIndex], ovrLayer[i])
							overlays.append(global.locations[ovrIndex])
						else:
							print('Error: No overlay named ' + ovr[i])
			
			elif dialogue[index].findn('pause') != -1:
				game.safeToSave = false
				global.pause_input = true
				say("","")
				yield(self, 'mouse_click')
				global.pause_input = false
				game.safeToSave = true
			
			elif dialogue[index].findn('CG:') != -1:
				global.pause_input = true
				
				var imageName = dialogue[index].lstrip('[')
				imageName = imageName.rstrip(']')
				imageName = imageName.substr(4,dialogue[index].length()-1)
				
				var imagePath = 'res://images/CG/' + imageName + '.png'
				
				systems.display.image(imagePath, 10)
				systems.display.fadealpha(imagePath, 'in', 1, 'self', 0.01)
				CG = imagePath
				
				yield(systems.display, 'transition_finish')
				global.pause_input = false
			
			elif dialogue[index].findn('CG|cut:') != -1:
				global.pause_input = true
				
				var imageName = dialogue[index].lstrip('[')
				imageName = imageName.rstrip(']')
				imageName = imageName.substr(8,dialogue[index].length()-1)
				
				var imagePath = 'res://images/CG/' + imageName + '.png'
				
				systems.display.image(imagePath, 10)
				CG = imagePath
				
				global.pause_input = false
			
			elif dialogue[index].findn('CG END|cut') != -1:
				global.pause_input = true
				
				if CG != null:
					systems.display.remove_name(CG)
					CG = null
				
				global.pause_input = false
			
			elif dialogue[index].findn('CG END') != -1:
				global.pause_input = true
				if CG != null:
					systems.display.fadealpha(CG, 'out', 1, 'self', 0.01)
					yield(systems.display, 'transition_finish')
					
					systems.display.remove_name(CG)
					CG = null
				global.pause_input = false
			
			elif dialogue[index].findn('Scene:') != -1:
				
				var saveChosenChoices = chosenChoices
				var saveInChoice = inChoice
				var saveChoices = choices
				
				if saveChoices == []:
					saveChoices = "NULL"
				else:
					var choiceArray = saveChoices
					saveChoices = ''
					var i = 1
					for choice in choiceArray:
						if i == choiceArray.size():
							saveChoices += choice
							break
						else:
							saveChoices += choice + ','
							i += 1
				
				if saveChosenChoices == []:
					saveChosenChoices = "NULL"
				else:
					var choiceArray = saveChosenChoices
					saveChosenChoices = ''
					var i = 1
					for choice in choiceArray:
						if i == choiceArray.size():
							saveChosenChoices += choice
							break
						else:
							saveChosenChoices += choice + ','
							i += 1
				
				var sceneSave = dialogue[index].substr(8,dialogue[index].length()-1).rstrip(']')
				
				var file = File.new()
				file.open_encrypted_with_pass('user://scenes/' + sceneSave, File.WRITE, 'HELPLETMEOUT')
				file.store_line(str(saveInChoice))
				file.store_line(saveChoices)
				file.store_line(saveChosenChoices)
				file.close()
			
			elif dialogue[index].findn('==>') != -1:
				global.pause_input = true
				
				var sceneName = '[Scene: ' + dialogue[index].substr(5,dialogue[index].length()-1)
				var found = null
				
				for i in range(0, dialogue.size()):
					if dialogue[i].find(sceneName) != -1:
						found = i
						break
				
				if found != null:
					if found < index:
						var loadInChoice = false
						var loadChoices = []
						var loadChosenChoices = []
						
						var file = File.new()
						var sceneSave = dialogue[index].substr(5,dialogue[index].length()-1).rstrip(']')
						file.open_encrypted_with_pass('user://scenes/' + sceneSave, File.READ, 'HELPLETMEOUT')
						var choiceText = file.get_as_text().split('\n', false, 3)
						file.close()
						
						if choiceText[0] == 'True': loadInChoice = true
						if choiceText[1] != 'NULL':
							var stringArray = choiceText[1].split(',', true)
							for string in stringArray: loadChoices.append(string)
						if choiceText[2] != 'NULL':
							var stringArray = choiceText[2].split(',', true)
							for string in stringArray: loadChosenChoices.append(string)
						
						choices = loadChoices
						inChoice = loadInChoice
						chosenChoices = loadChosenChoices
						
						index = found
					else:
						index = found
				else:
					print('Could not find: ' + sceneName)
				
				global.pause_input = false
			
			elif dialogue[index].findn('CHANGE') != -1:
				global.pause_input = true
				game.safeToSave = false
				var command = dialogue[index].lstrip('[')
				command = command.rstrip(']')
				command = command.split(' ', false)
				if command.size() == 2: scene.change(command[1])
				elif command.size() == 3: scene.change(command[1], command[2])
				elif command.size() == 4: scene.change(command[1], command[2], int(command[3]))
				elif command.size() == 5: scene.change(command[1], command[2], int(command[3]), float(command[4]))
				else: print('Invalid number of commands for CHANGE on line ' + str(index) + '!')
			
			elif dialogue[index].findn('ENDING') != -1:
				scene.change('main_menu', 'fadeblack', 1, 0.01)
			
			waitTimer.wait_time = 0.01
			waitTimer.start()
			yield(waitTimer, "timeout")
			
			var halt = global.rootnode.scene(dialogue[index], index+1, self)
			index += 1
			emit_signal('empty_line')
		
		
		# CHOICES
		elif dialogue[index].begins_with("*"):
			
			# Deal with the end of a choice.
			if inChoice:
				if dialogue[index] == '*':
					inChoice = false
				index += 1
				emit_signal('empty_line')
				return
			
			var choice  = dialogue[index].lstrip('*')
			choice = choice.rstrip('*')
			var pastChoice = false
			var chosenChoice = false
			
			# UNDO the specified choice.
			if 'UNDO' == choice.substr(0, 4):
				chosenChoices.erase(choice.substr(5, choice.length()))
				index += 1
				emit_signal('empty_line')
				return
			
			# Determine if the choice has been seen before.
			elif choices.size() != 0:
				for i in range(0, choices.size()):
					if choice == choices[i]:
						pastChoice = true
						break
			
			# If the choice has been seen before...
			if pastChoice:
				# and there are no chosenChoices then skip the choice block.
				if chosenChoices.size() == 0:
					index += 1
					while dialogue[index] != '*':
						index += 1
				else:
					# If chosenChoices is > 0 then determine if choice is a chosenChoice.
					for i in range(0, chosenChoices.size()):
						# If choice is a chosenChoice then set inChoice to true.
						if choice == chosenChoices[i]:
							inChoice = true
						# else skip the choice block.
						else:
							index += 1
							while dialogue[index] != '*':
								index += 1
			# If an unseen choice then display it and adjacent unseen choices.
			else:
				global.pause_input = true
				displayingChoices = true
				choice_calc(choice)
				yield(self, 'choiceChosen')
				emit_signal('empty_line')
				return
			
			index += 1
			emit_signal('empty_line')
		
		
		# DIALOGUE
		elif dialogue[index].begins_with("("):
			global.pause_input = true
			var info # Contains provided character information.
			var text # Contains the words the character says.
			var say = true # Whether or not say the character text.
#			var lastChar = dialogue[index].length()-1 # The position of the last character.
			var wait = true # Whether or not to wait when no text to say.
			var noChar = false
			
			# Handle 'soft' newlines so that a newline does't sperate lines of dialogue when displayed.
			if dialogue[index][dialogue[index].length()-1] == 'n' and dialogue[index][dialogue[index].length()-2] == '/':
				dialogue[index+1] = dialogue[index].substr(0, dialogue[index].length()-1-1) + "\n" + dialogue[index+1]
				index += 1
			
			# Replaces every instance of the word "PCPG" with the player name.
			if global.playerName != null:
				regex.compile("PCPG")
				dialogue[index] = regex.sub(dialogue[index], global.playerName, true)
			
			# If there is no text on the line then don't say anything.
			if dialogue[index][dialogue[index].length()-1] == ')' or dialogue[index][dialogue[index].length()-1] == '$':
				global.pause_input = true
				say = false
				if dialogue[index][dialogue[index].length()-1] == '$': wait = false
				var stripParentheses = dialogue[index].substr(dialogue[index].find("(") + 1, dialogue[index].find(")") - 1) #"Crop" the info inside of the parentheses.
				info = stripParentheses.split(',') # Split the info inside the parentheses on commas.
			
			# If there is text to say then prepare it.
			else:
				var splitLine = dialogue[index].split(")", true, 1) #Split current line into 2 strings.
				if splitLine[1][0] == ':': # If they used a colon then adjust for it.
					splitLine[1] = splitLine[1].substr(1, (dialogue[index].length() - (splitLine[0].length() + 1))) #Start string after the colon.
				splitLine[0] = splitLine[0].substr(splitLine[0].find("(") + 1, splitLine[0].length()-1) #"Crop" the info inside of the parentheses.
			
				info = splitLine[0].split(',') # Split the info inside the parentheses on commas.
				text = splitLine[1]
				if text.begins_with(" "):
					var t = text.substr(1, text.length())
			
			# Remove all spaces before and after the info.
			for i in range(0, info.size()):
				info[i] = info[i].strip_edges(true, true)
			
			# Make all information lowercase except info[0].
			for i in range(1, info.size()):
				info[i] = info[i].to_lower()
			
			var chrName = info[0] # Set the chrName to info[0].
			
			var voice = null
			
#			# Do stuff depending on the current speaker
#			match info[0]:
#				"Tom":
#					$Nametag.add_color_override("font_color", global.tom.color)
#				"Mage":
#					$Nametag.add_color_override("font_color", global.mage.color)
#				"Ben":
#					$Nametag.add_color_override("font_color", Color('8d8d8d'))
#				"Digi":
#					$Nametag.add_color_override("font_color", global.digibro.color)
#				"Davoo":
#					$Nametag.add_color_override("font_color", Color('408ff2'))
#				"Jess":
#					$Nametag.add_color_override("font_color", Color('fdf759'))
#				"Munchy":
#					$Nametag.add_color_override("font_color", global.munchy.color)
#				"Gibbon":
#					voice = load('res://sounds/speech/pcp-voice_gibbontake.ogg')
#				"Endless War":
#					$Nametag.add_color_override("font_color", global.endlesswar.color)
#				_:
#					$Nametag.add_color_override("font_color", Color.white)
			
			# Check if another name needs to be used.
			if info[0].find('|') != -1:
				var tmp = info[0].split('|', false)
				info[0] = tmp[0]
				chrName = tmp[1]
				if !say: say("", chrName)
			elif !say: say("", "")
			
			if info.size() > 1:
				parse_info(info); # Parse the info so that is displays a character.
			else:
				noChar = true
			
			if say: # If the text is to be said then...
				
				lastKeep(index)
				var halt = global.rootnode.scene(dialogue[index], index+1, self) # Send the dialogue to the scene function in the root of the scene.
				say(text, chrName, voice)
				get_node("Dialogue").isCompartmentalized = false #Set so next line can be compartmentalized
#				emit_signal('sentence_end', dialogue[index])
				index += 1
				if noChar: 
					global.pause_input = false
			else:
				if wait:
					game.safeToSave = false
					waitTimer.wait_time = 0.1
					waitTimer.start()
					yield(waitTimer, 'timeout')
					game.safeToSave = true
					
				index += 1
				emit_signal('empty_line')
				global.pause_input = false
		
		# Don't display anything but call scene function.
		elif dialogue[index] == ("&&&&&"):
			var halt = global.rootnode.scene("", index+1, self)
			index += 1
			emit_signal('empty_line')
		
#		If line doesn't start with anything particular, register it as the player's thoughts
		else:
			
			# Skip line if it only contains spaces.
			if dialogue[index].begins_with(' '):
				var string = dialogue[index]
				string = string.replace(' ', '')
				if string.length() == 0:
					index += 1
					emit_signal('empty_line')
					return
			
			lastKeep(index)
			
			# Replaces every instance of the word "PCPG" with the player name.
			if global.playerName != null:
				regex.compile("PCPG")
				dialogue[index] = regex.sub(dialogue[index], global.playerName, true)
			
			# Handle 'soft' newlines so that a newline does't sperate lines of dialogue when displayed.
			var lastChar = dialogue[index].length()-1 # The position of the last character.
			if dialogue[index][lastChar] == 'n' and dialogue[index][lastChar-1] == '/':
				dialogue[index+1] = dialogue[index].substr(0, lastChar-1) + "\n" + dialogue[index+1]
				index += 1
			
			if dialogue[index].begins_with("$(") and dialogue[index].ends_with(")"):
				dialogue[index] = dialogue[index].substr(1, dialogue[index].length())
			
			$Nametag.add_color_override("font_color", Color.white)
			var halt = global.rootnode.scene(dialogue[index], index+1, self) # Send the dialogue to the scene function in the root of the scene.
			say(dialogue[index], "")
			emit_signal('sentence_end', dialogue[index])
			index += 1

# Generates function calls to the image system by parsing the script.
func parse_info(info):
	match info[0]:
		"9/11":
			info[0] = 'nine11'
			remove_dupes('911', info)
			yield(self, 'dupeCheckFinished')
			if notsame[0]: parse_911(info, 'nine11', 1, notsame[1])
		"Tom":
			info[0] = 'tom'
			var poseNum = 1
			var i = 1
			if info.size() > 1 and info[1].is_valid_integer():
				poseNum = int(info[1])
				i += 1
			remove_dupes('tom', info)
			yield(self, 'dupeCheckFinished')
			if notsame[0]: parse_expression(info, 'tom.pose' + str(poseNum), 'characterImages.tom.pose' + str(poseNum) +'.body[0]', i, 'null', notsame[1])
		"Colt Corona":
			var charName = info[0].to_lower();
			charName = charName.replace(' ', '');
			remove_dupes(charName, info)
			yield(self, 'dupeCheckFinished')
			if notsame[0]: parse_outfit(info, charName+'.'+info[1], 1, notsame[1])
		_:
			var charName = info[0].to_lower();
			charName = charName.replace(' ', '');
			remove_dupes(charName, info)
			yield(self, 'dupeCheckFinished')
			if notsame[0]: parse_outfit(info, charName, 1, notsame[1])

# Removes duplicate bodies of characters if they exist.
func remove_dupes(character, info):
	waitTimer.wait_time = 0.01
	waitTimer.start()
	yield(waitTimer, 'timeout')
	
	var size = info.size()
	for i in range(0, systems.display.layers.size()):
		
		var layer = systems.display.layers[i]['name']
		
		if layer.findn(character) != -1:
			if size == 1:
				notsame = [false, null]
				emit_signal('dupeCheckFinished')
				return
			
			elif size >= 2:
				if info[1] == 'fade':
					info.remove(1)
					size = info.size()
					if size > 1: if info[1].find('|') != -1:
						info.remove(1)
						size = info.size()
					if size == 1:
						notsame = [false, null]
						emit_signal('dupeCheckFinished')
						return
				
				if info[1] == 'right' or info[1] == 'left' or info[1] == 'center' or info[1] == 'offleft' or info[1] == 'offright' or info[1] == 'slide' or info[1] == 'off' or info[1] == 'silhouette':
					if info[1] == 'slide': info[1] = 'slideNoChange'
					parse_position(info, '', '"'+systems.display.layers[i]['path']+'"', 1, systems.display.layers[i]['node'].position)
					notsame = [false, null]
					emit_signal('dupeCheckFinished')
					return
				
				else:
					if !global.pause_input: global.pause_input = true
					var pos = systems.display.layers[i]['node'].position
					systems.display.remove(systems.display.layers[i]['node'], i)
					notsame = [true, pos]
					emit_signal('dupeCheckFinished')
					if global.pause_input: global.pause_input = false
					return
	
	if size == 2:
		if info[1] == 'off':
			notsame = [false, null]
			emit_signal('dupeCheckFinished')
			return
	
	notsame = [true, Vector2(0,0)]
	emit_signal('dupeCheckFinished')

# Parses the characters outfit.
func parse_outfit(info, parsedInfo, i, pos):
	if info.size() == 1: return
	var next
	var num
	
	if 'knife'.is_subsequence_ofi(info[i]):
		parsedInfo += '.knife'
	
	match info[i]:
		"campus":
			num = str(search('return characterImages.'+parsedInfo+'.campus.body', info[i+1]))
			if num == '-1' or num == '-2':
				num = '0'
				next = 1
			else:
				next = 2
			parsedInfo += '.campus'
			var extra = ''
			if 'squat'.is_subsequence_ofi(info[i+1]): extra += '.squatting'
			parse_expression(info, parsedInfo+extra, 'characterImages.'+parsedInfo+'.body['+num+']', i+next, info[i+1], pos)
		"casual":
			num = str(search('return characterImages.'+parsedInfo+'.casual.body', info[i+1]))
			if num == '-1' or num == '-2':
				num = '0'
				next = 1
			else:
				next = 2
			parsedInfo += '.casual'
			var extra = ''
			if 'squat'.is_subsequence_ofi(info[i+1]): extra += '.squatting'
			parse_expression(info, parsedInfo+extra, 'characterImages.'+parsedInfo+'.body['+num+']', i+next, info[i+1], pos)
		"special":
			num = str(search('return characterImages.'+parsedInfo+'.special.body', info[i+1]))
			if num == '-1' or num == '-2':
				num = '0'
				next = 1
			else:
				next = 2
			parsedInfo += '.special'
			var extra = ''
			if 'squat'.is_subsequence_ofi(info[i+1]): extra += '.squatting'
			parse_expression(info, parsedInfo+extra, 'characterImages.'+parsedInfo+'.body['+num+']', i+next, info[i+1], pos)
		"newgle":
			parse_expression(info, parsedInfo+'.newgle', 'characterImages.'+parsedInfo+'.newgle.body['+0+']', i+1, info[i+1], pos)
		"base":
			parse_expression(info, parsedInfo+'.base', 'characterImages.'+parsedInfo+'.base.body['+0+']', i+1, info[i+1], pos)
		"bigboi":
			parse_expression(info, parsedInfo+'.bigboi', 'characterImages.'+parsedInfo+'.bigboi.body['+0+']', i+1, info[i+1], pos)
		"hazmat":
			var expression = info[i+1]
			var expNum = parse_expnum(expression, parsedInfo+'.hazmat')[0]
			
			if "angry".is_subsequence_of(expression): expression = 'angry'
			elif "confused".is_subsequence_of(expression): expression = 'confused'
			elif "sad".is_subsequence_of(expression): expression = 'sad'
			elif "shock".is_subsequence_of(expression): expression = 'shock'
			elif "smitten".is_subsequence_of(expression): expression = 'smitten'
			
			var body = 'characterImages.'+parsedInfo+'.hazmat.'+expression+'['+expNum+']'
			parse_position(info, 'systems.display.image('+body+', 1)', body, i+2, pos)
		_:
			num = str(search('return characterImages.'+parsedInfo+'.body', info[i]))
			parse_expression(info, parsedInfo, 'characterImages.'+parsedInfo+'.body['+num+']', i+1, info[i], pos)

# Parses the characters expression.
func parse_expression(info, parsedInfo, body, i, bodyType, pos):
	var blush = false
	var shades = false
	var knife = false
	var AFL = ''
	var blushNum
	var num
	
	if i == info.size(): # Don't use an expression if none is given.
		parse_position(info, 'systems.display.image('+body+', 1)', body, i, pos)
		return
	
	if info[i].find('|') != -1:
		var tmp = info[i].split('|', false)
		info[i] = tmp[0]
		
		if tmp.size() == 2:
			if 'blush'.is_subsequence_ofi(tmp[1]):
				blushNum = int(parse_expnum(tmp[1], parsedInfo)[0])
				blush = true
			elif tmp[1] == 'shades':
				shades = true
		else:
			for k in range(1, tmp.size()):
				if 'blush'.is_subsequence_ofi(tmp[k]):
					blushNum = int(parse_expnum(tmp[k], parsedInfo)[0]);
					blush = true
				elif tmp[k] == 'shades':
					shades = true
		
#		if tmp.size() == 3:
#			blushNum = int(parse_expnum(info[i], parsedInfo)[0]);
#			blush = true
#			shades = true
#		elif 'blush'.is_subsequence_ofi(tmp[1]):
#			blushNum = int(parse_expnum(tmp[1], parsedInfo)[0]);
#			blush = true
#		elif tmp[1] == 'shades':
#			shades = true
	
	if blush:
		var blushFace = search('return characterImages.'+parsedInfo+'.blush', info[i]) + 1
		if blushFace != -1 and blushFace != -2: blushNum = blushNum -1 + blushFace
		AFL += '\n\tsystems.display.face(characterImages.'+parsedInfo+'.blush['+str(blushNum)+'], '+body+', 0, 0, "blush")'
	if shades:
		AFL += '\n\tsystems.display.face(characterImages.nate.afl[0], '+body+', 0, 0, "shades")'
	
	var useDefault = false
	if "happy".is_subsequence_of(info[i]):
		useDefault = true
	elif "angry".is_subsequence_of(info[i]):
		useDefault = true
	elif "confused".is_subsequence_of(info[i]):
		useDefault = true
	elif "neutral".is_subsequence_of(info[i]):
		useDefault = true
	elif "sad".is_subsequence_of(info[i]):
		useDefault = true
	elif "shock".is_subsequence_of(info[i]):
		useDefault = true
	elif "smitten".is_subsequence_of(info[i]):
		useDefault = true
	elif "face".is_subsequence_of(info[i]):
		useDefault = true
	if not useDefault and (info[i] == 'right' or info[i] == 'left' or info[i] == 'center' or info[i] == 'offleft' or info[i] == 'offright' or info[i] == 'slide' or info[i] == 'off' or info[i] == 'silhouette'):
		parse_position(info, 'systems.display.image('+body+', 1)'+AFL, body, i, pos)
	else:
		var expression_num_stuff = parse_expnum(info[i], parsedInfo)
		num = expression_num_stuff[0]
		var faceType = expression_num_stuff[1]
		parse_position(info, 'systems.display.image('+body+', 1)\n\tsystems.display.face(characterImages.'+parsedInfo+'.'+faceType+'['+num+'], '+body+')'+AFL, body, i+1, pos)

# Determines the correct face number for an epxression, returns
#[face_type, number]
func parse_expnum(expression, parsedInfo):
	var length = expression.length()
	
	if expression[length-1].is_valid_integer():
		var num = int(expression[length-1])
		#STUPID HACK! This used to only check up to and including three...
		#I'm making it more useful, notably fixing use cases with four faces, but it may break things...
		if num > 0: 
			return [str(num-1), expression.left(length-1)]
	elif 'min' == expression.substr(length-3, 3):
		return ['0', expression.left(length-3)]
	elif 'med' == expression.substr(length-3, 3):
		return ['1', expression.left(length-3)]
	elif 'max' == expression.substr(length-3, 3):
		if "angry".is_subsequence_of(expression): expression = 'angry'
		elif "confused".is_subsequence_of(expression): expression = 'confused'
		elif "sad".is_subsequence_of(expression): expression = 'sad'
		elif "shock".is_subsequence_of(expression): expression = 'shock'
		elif "smitten".is_subsequence_of(expression): expression = 'smitten'
		var num = execreturn('return characterImages.'+parsedInfo+'.'+expression.rstrip('max')+'.size()')
		if num == 3:
			return ['2', expression.rstrip('max')]
		else:
			return ['1', expression.rstrip('max')]
	else:
		return ['0', expression]

# Parses 911's special mask case.
func parse_911(info, parsedInfo, i, pos):
	
	if 'pew'.is_subsequence_ofi(info[i]):
		parse_position(info, 'systems.display.mask(characterImages.'+parsedInfo+'.body[2], characterImages.'+parsedInfo+'.video[2], "video", 1)', 'characterImages.'+parsedInfo+'.body[2]', 2, pos)
	elif 'boi' == info[i]:
		parse_position(info, 'systems.display.mask(characterImages.'+parsedInfo+'.body[0], characterImages.'+parsedInfo+'.video[0], "video", 1)', 'characterImages.'+parsedInfo+'.body[0]', 2, pos)
	elif 'standin'.is_subsequence_ofi(info[i]):
		parse_position(info, 'systems.display.mask(characterImages.'+parsedInfo+'.body[3], characterImages.'+parsedInfo+'.video[3], "video", 1)', 'characterImages.'+parsedInfo+'.body[3]', 2, pos)
	elif 'concern' == info[i]:
		parse_position(info, 'systems.display.mask(characterImages.'+parsedInfo+'.body[1], characterImages.'+parsedInfo+'.video[1], "video", 1)', 'characterImages.'+parsedInfo+'.body[1]', 2, pos)

# Parses the position for a character.
func parse_position(info, parsedInfo, body, i, pos):
	var transition = false
	var extra = 0
	var move = false
	var num
	
	if i == info.size():
		execute(parsedInfo+'\n\tsystems.display.position('+body+', '+str(pos[0])+', '+str(pos[1])+')')
		return
	
	if info[i] == 'silhouette' or info[i] == 'fade':
		var speed = 0.01
		transition = info[i]
		info.remove(i)
		
		if fade: info.remove(i)
		
		if i == info.size():
			if transition == 'silhouette': execute(parsedInfo+'\n\tsystems.display.fadeblack('+body+', "in", 0)\n\tsystems.display.position('+body+', '+str(pos[0])+', '+str(pos[1])+')')
			else: execute(parsedInfo+'\n\tsystems.display.position('+body+', '+str(pos[0])+', '+str(pos[1])+')')
			return
	
	if i + 2 == info.size()-1:
		move = true
	elif i + 3 == info.size()-1:
		for chr in info[i+3]:
			if int(chr) == 0:
				print('Invalid speed on line ' + String(index+1) + ' of the script!')
				return
		move = true
	
	if info[i].findn('+') != -1:
		var tmp = info[i].split('+', true, 1)
		info[i] = tmp[0]
		extra = int(tmp[1])
	elif info[i].findn('-') != -1:
		var tmp = info[i].split('-', true, 1)
		info[i] = tmp[0]
		extra = int(tmp[1]) * -1
	elif info[i] == 'slideNoChange':
		info[i] = 'slide'
		parse_move(info, body, i)
		return
	elif info[i] == 'slide':
		execute(parsedInfo+'\n\tsystems.display.position('+body+', '+str(pos[0])+', '+str(pos[1])+')')
		parse_move(info, body, i)
		return
	
	if info[i].findn('|') != -1:
		var cords = info[i].split('|', false, 1)
		if transition: parsedInfo += _transition(transition, body, fade)
		execute(parsedInfo+'\n\tsystems.display.position('+body+', '+cords[0]+', '+cords[1]+')')
		if move: parse_move(info, body, i+1)
	elif info[i] == 'right':
		num = 600 + extra
		if transition: parsedInfo += _transition(transition, body, fade)
		execute(parsedInfo+'\n\tsystems.display.position('+body+', '+str(num)+', 0)')
		if move: parse_move(info, body, i+1)
	elif info[i] == 'left':
		num = -600 + extra
		if transition: parsedInfo += _transition(transition, body, fade)
		execute(parsedInfo+'\n\tsystems.display.position('+body+', '+str(num)+', 0)')
		if move: parse_move(info, body, i+1)
	elif info[i] == 'center':
		if transition: parsedInfo += _transition(transition, body, fade)
		execute(parsedInfo+'\n\tsystems.display.position('+body+', '+str(extra)+', 0)')
		if move: parse_move(info, body, i+1)
	elif info[i] == 'offleft':
		if transition: parsedInfo += _transition(transition, body, fade)
		execute(parsedInfo+'\n\tsystems.display.position('+body+', -1650, 0)')
		if move: parse_move(info, body, i+1)
	elif info[i] == 'offright':
		if transition: parsedInfo += _transition(transition, body, fade)
		execute(parsedInfo+'\n\tsystems.display.position('+body+', 1650, 0)')
		if move: parse_move(info, body, i+1)
	elif info[i] == 'off':
		pass # Do nothing if the character is speaking off screen.
	else:
		return

# Function to parse position movement.
func parse_move(info, body, i):
	var speed = '20'
	var extra = 0
	var num
	
	#the second part of this and checks that if the speed param is a string, it BETTER be valid float (integers are valid for that too)
	if info.size()-1 > i+1 and ((typeof(info[i+2]) == TYPE_STRING) == (info[i+2].is_valid_float())):
		speed = info[i+2]
	
	if info[i] == 'slide':
		
		if info[i+1].findn('|') != -1:
			var cords = info[i+1].split('|', false, 1)
			execute('systems.display.position('+body+', '+cords[0]+', "slide", '+speed+')')
		elif info[i+1] == 'right':
			num = 600 + extra
			execute('systems.display.position('+body+', '+str(num)+', "slide", '+speed+')')
		elif info[i+1] == 'left':
			num = -600 + extra
			execute('systems.display.position('+body+', '+str(num)+', "slide", '+speed+')')
		elif info[i+1] == 'center':
			execute('systems.display.position('+body+', '+str(extra)+', "slide", '+speed+')')
		elif info[i+1] == 'offleft':
			execute('systems.display.position('+body+', -1650, "slide", '+speed+')')
		elif info[i+1] == 'offright':
			execute('systems.display.position('+body+', 1650, "slide", '+speed+')')
		else:
			return
		
		lastBody = execreturn('return ' + body) # For saving purposes.

# Function to execute the code generated through parsing.
func execute(parsedInfo):
	var source = GDScript.new()
	source.set_source_code('func eval():\n\tvar systems = global.rootnode.get_node("Systems")\n\t' + parsedInfo)
	source.reload()
	var script = Reference.new()
	script.set_script(source)
	script.eval()
	emit_signal("sentence_end", dialogue[index])
	global.pause_input = false

# Function to search bodies for the correct one.
func search(body, info):
	body = execreturn(body)
	
	if body.size() == 1: return -1
	
	for i in range(0, body.size()):
		if body[i].findn(info) != -1:
			return i
	
	return -2

# Function to execute code and return a result.
func execreturn(parsedInfo):
	var source = GDScript.new()
	source.set_source_code('func eval():\n\tvar systems = global.rootnode.get_node("Systems")\n\t' + parsedInfo)
	source.reload()
	var script = Reference.new()
	script.set_script(source)
	return script.eval()

# Function to return a transition of a character.
func _transition(transition, body, fade):
	if transition == 'silhouette':
		return '\n\tsystems.display.fadeblack('+body+', "in", 0)'
	elif fade:
		return '\n\tsystems.display.fadealpha('+body+', "in", 10, "self", 0.01)'
	else:
		return ''

# Function to get the body path for preventing fade errors.
func get_body(info, i=1):
	var num
	var body
	match info[i]:
		"campus":
			num = str(search('return characterImages.'+info[0]+'.campus.body', info[i+1]))
			body = 'characterImages.'+info[0]+'.campus.body['+num+']'
		"casual":
			num = str(search('return characterImages.'+info[0]+'.casual.body', info[i+1]))
			body = 'characterImages.'+info[0]+'.casual.body['+num+']'
		_:
			num = str(search('return characterImages.'+info[0]+'.body', info[i]))
			body = 'characterImages.'+info[0]+'.body['+num+']'
	
	body = execreturn('return ' + body)
	if info[0] == 'nine11': body = body.rstrip('png') + 'ogv'
	return body





func fadeblackalpha(node, fade, spd, time=0.5):
	global.fading = true # Let the game know fading is occuring.
	var percent # Used to calculate modulation.
	var ftimer = Timer.new() # A timer node.
	var p # A var for percentage calculation.
	add_child(ftimer) # Add the timer as a child.
	ftimer.one_shot = true # Make the timer one shot.
		
	
	# If speed is outside the range 1-50 then print an error and return.
	if spd <= 0 or spd > 100:
		print('Error: The 3rd parameter on fadealpha only accepts values 0 < x <= 100!')
		return
	
	# If fade is out then fade out.
	if fade == 'in':
		percent = 100
		# While percent isn't 0 fade to black.
		while percent != 0 and global.fading:
			percent -= spd # Subtract spd from percent.
			if percent < 0: percent = 0 # Make percent 0 if it falls below.
			p = float(percent)/100 # Make p percent/100
			node.set_self_modulate(Color(1,1,1,p)) # Modulate the node by p.
			ftimer.start(time) # Start the timer at 0.5 seconds.
			yield(ftimer, 'timeout') # Wait for the timer to finish before continuing.
	
	# If fade is in then fade in.
	elif fade == 'out':
		percent = 0
		# While percent isn't 0 fade from black.
		while percent != 100:
			percent += spd # Add spd to percent.
			if percent > 100: percent = 100 # Make percent 100 if it goes above.
			p = float(percent)/100 # Make p percent/100
			node.set_self_modulate(Color(1,1,1,p)) # Modulate the node by p.
			ftimer.start(time) # Start the timer at 0.5 seconds.
			yield(ftimer, 'timeout') # Wait for the timer to finish before continuing.
	
	# Else print an error if fade is not in or out.
	else:
		print("Error: The 2nd parameter on fadeblack can only be 'in' or 'out'!")
	
	emit_signal('transition_finish')
	global.finish_fading()
	ftimer.queue_free()
