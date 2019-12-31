extends TextureRect

var dialogue = PoolStringArray() #All of the lines in the current text file. Not using a regular array for better performance
var index #Index of current line of dialogue
var start
var script
var regex = RegEx.new()
var systems
var choices
var inChoice
var chosenChoices
var displayChoices = []
var displayingChoices = false
var waitTimer = Timer.new()
var numOfChoices = 0
var fade = false
var notsame

signal empty_line
signal sentence_end
signal choiceChosen
signal dupeCheckFinished

var lastBody
var lastSpoken = 0
var lastLayers
var lastBGNode
var lastBGType
var lastChoices
var lastInChoice
var lastChosenChoices


func _ready(): 
	systems = global.rootnode.get_node("Systems") # Assign the systems no to systems.

	#Opens the document containing the scene's script (as in the dialogue)
	var f = File.new()
	f.open(script, File.READ)
	
#	var err = f.open_encrypted_with_pass("res://document.txt", File.READ, "password") ability to read encrypted files 
	#Stores every line of dialogue in the array
	while not f.eof_reached():
		dialogue.push_back(f.get_line())
	f.close()
	self.connect("empty_line", self, "_on_Dialogue_has_been_read")
	start = index
	emit_signal("empty_line") #Signals to display first line of dialogue
	
	# Define a wait timer.
	waitTimer.one_shot = true
	waitTimer.autostart = false
	add_child(waitTimer)
	
	global.pause_input = true # Pause input during first load.


#Nametag is the label above the textbox, dialogue's say is what updates the textbox.
func say(words, character = ""):
	$Nametag.text = character
	$Dialogue.say(words)


# Function to calculate the number of unseen choices.
func choice_calc(choice):
	# Figure out if there are more unseen choices.
	var pastChoice = false
	for item in choices:
		if choice == item:
			pastChoice = true
	if 'UNDO'.is_subsequence_of(dialogue[index]):
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
			waitTimer.wait_time = 1
			waitTimer.start()
			yield(waitTimer, "timeout")
			global.pause_input = false
			game.safeToSave = true
		
		
		# COMMENTS/COMMANDS
		if dialogue[index].begins_with("["):
			
			if '9/11'.is_subsequence_of(dialogue[index]):
				regex.compile('9/11')
				dialogue[index] = regex.sub(dialogue[index], "911", true)
			
			if 'leaves'.is_subsequence_ofi(dialogue[index]):
				for character in characterImages.chararray:
					if character.is_subsequence_ofi(dialogue[index]):
						for i in range(0, systems.display.layers.size()):
							var layer = systems.display.layers[i]['name']
							if layer.findn(character.to_lower()) != -1:
								systems.display.remove(systems.display.layers[i]['path'])
								break
						break
			
			elif 'fade to black'.is_subsequence_ofi(dialogue[index]):
				global.pause_input = true
				systems.display.fadeblack(systems.display.bgnode, 'out', 15, 'children')
				if !'unpause'.is_subsequence_ofi(dialogue[index]):
					yield(systems.display, 'transition_finish')
				global.pause_input = false
			
			elif 'fade from black'.is_subsequence_ofi(dialogue[index]):
				global.pause_input = true
				systems.display.fadeblack(systems.display.bgnode, 'in', 15, 'children')
				if !'unpause'.is_subsequence_ofi(dialogue[index]):
					yield(systems.display, 'transition_finish')
				global.pause_input = false
			
			elif 'cut to black'.is_subsequence_ofi(dialogue[index]): systems.display.fadeblack(systems.display.bgnode, 'out', 100, 'children')
			elif 'cut from black'.is_subsequence_ofi(dialogue[index]): systems.display.fadeblack(systems.display.bgnode, 'in', 100, 'children')
			
			elif dialogue[index].findn('REMOVE') != -1:
				var command = dialogue[index].lstrip('[')
				command = command.rstrip(']')
				command = command.split(' ', false, 1)
				for i in range(0, systems.display.layers.size()):
					var layer = systems.display.layers[i]['name']
					if layer.findn(command[1].to_lower()) != -1:
						systems.display.remove(systems.display.layers[i]['path'])
						break
			
			elif dialogue[index].findn('SLIDE') != -1:
				var command = dialogue[index].lstrip('[')
				command = command.rstrip(']')
				command = command.split(' ')
				for i in range(0, systems.display.layers.size()):
					var layer = systems.display.layers[i]['name']
					if layer.findn(command[1].to_lower()) != -1:
						if command.size() == 3:
							parse_move(['slide', command[2]], '"'+systems.display.layers[i]['path']+'"', 0)
						elif command.size() == 4:
							parse_move(['slide', command[2], command[3]], '"'+systems.display.layers[i]['path']+'"', 0)
						break
			
			elif dialogue[index].findn('CHANGE') != -1:
				global.pause_input = true
				game.safeToSave = false
				var command = dialogue[index].lstrip('[')
				command = command.rstrip(']')
				command = command.split(' ', false)
				if command.size() == 2: scene.change(command[1])
				elif command.size() == 3: scene.change(command[1], command[2])
				elif command.size() == 4: scene.change(command[1], command[2], int(command[3]))
				elif command.size() == 5: scene.change(command[1], command[2], int(command[3]), int(command[4]))
				else: print('Invalid number of commands for CHANGE on line ' + str(index) + '!')
			
			elif dialogue[index].findn('Song:') != -1:
				var track = dialogue[index].lstrip('[')
				track = track.rstrip(']')
				track = track.substr(6,dialogue[index].length()-1)
				get_parent().sound.music("res://sounds/music/" + track + ".wav")
			
			elif dialogue[index].findn('SFX:') != -1:
				var sfx = dialogue[index].lstrip('[')
				sfx = sfx.rstrip(']')
				sfx = sfx.substr(5,dialogue[index].length()-1)
				get_parent().sound.sfx("res://sounds/sfx/" + sfx + ".wav")
			
			elif dialogue[index].findn('StopMusic') != -1:
				get_parent().sound.stop(get_parent().sound.audioname(get_parent().sound.queue[0]['path']))
			
			elif dialogue[index].findn('Location') != -1: 
				var loc = dialogue[index]
				loc = loc.left(loc.find_first(','))
				loc = loc.right(loc.find_last(':'))
				var type = dialogue[index];
				type = type.right(type.find_first('.'))
				type = type.right(type.find_first('.'))
				type = type.left(type.find_first(','))
				if(type == "mp4"):
					type = 'video'
				elif(type == "png"):
					type = 'image'
				get_parent().display.background(global.location[global.locationNames.find()],type)
			global.rootnode.scene(dialogue[index], index+1)
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
			
			var info # Contains provided character information.
			var text # Contains the words the character says.
			var say = true # Whether or not say the character text.
			var lastChar = dialogue[index].length()-1 # The position of the last character.
			var wait = true # Whether or not to wait when no text to say.
			
			# Handle 'soft' newlines so that a newline does't sperate lines of dialogue when displayed.
			if dialogue[index][lastChar] == 'n' and dialogue[index][lastChar-1] == '/':
				dialogue[index+1] = dialogue[index].substr(0, lastChar-1) + "\n" + dialogue[index+1]
				index += 1
			
			#Replaces every instance of the word "Player" with "PCPGuy". You can easily
			#tweak this to replace another word, or to replace it with a varia le index.e an inputted player name
			regex.compile("Player")
			dialogue[index] = regex.sub(dialogue[index], "PCPGuy", true)
			
			# If there is no text on the line then don't say anything.
			if dialogue[index][lastChar] == ')' or dialogue[index][lastChar] == '$':
				global.pause_input = true
				say = false
				if dialogue[index][lastChar] == '$': wait = false
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
			
			# Remove all spaces before and after the info.
			for i in range(0, info.size()):
				while info[i][0] == ' ':
					info[i] = info[i].right(1)
				while info[i][info[i].length() - 1] == ' ':
					info[i] = info[i].left(info[i].length() - 1)
			
			# Make all information lowercase except info[0].
			for i in range(1, info.size()):
				info[i] = info[i].to_lower()
			
			var chrName = info[0] # Set the chrName to info[0].
			
			# Change nametag color depending on the current speaker
			match info[0]:
				"Tom":
					$Nametag.add_color_override("font_color", global.tom.color)
				"Mage":
					$Nametag.add_color_override("font_color", global.mage.color)
				"Ben":
					$Nametag.add_color_override("font_color", Color('8d8d8d'))
				"Digi":
					$Nametag.add_color_override("font_color", global.digibro.color)
				"Davoo":
					$Nametag.add_color_override("font_color", Color('408ff2'))
				"Jess":
					$Nametag.add_color_override("font_color", Color('fdf759'))
				"Munchy":
					$Nametag.add_color_override("font_color", global.munchy.color)
				"Hippo":
					$Nametag.add_color_override("font_color", global.hippo.color)
				"Endless War":
					$Nametag.add_color_override("font_color", global.endlesswar.color)
				_:
					$Nametag.add_color_override("font_color", Color.white)
			
			# Check if another name needs to be used.
			if info[0].find('|') != -1:
				var tmp = info[0].split('|', false)
				info[0] = tmp[0]
				chrName = tmp[1]
				if !say: say("", chrName)
			elif !say: say("", "")
			
			parse_info(info); # Parse the info so that is displays a character.
			
#			Function for custom fonts. This can be incorporated in the following
#			"match" section to use different fonts for differents speakers 
#			var mageFontData = DynamicFontData.new()
#			mageFontData.font_path = "res://fonts/Nametag/karmatic_arcade/ka1.ttf"
#			var mageFont = DynamicFont.new()
#			mageFont.font_data = mageFontData
#			mageFont.size = 68
#			$Nametag.add_font_override("normal_font", mageFont)
			
			if say: # If the text is to be said then...
				
				lastKeep(index)
				global.rootnode.scene(dialogue[index], index+1) # Send the dialogue to the scene function in the root of the scene.
				say(text, chrName)
				get_node("Dialogue").isCompartmentalized = false #Set so next line can be compartmentalized
				emit_signal('sentence_end', dialogue[index])
				index += 1
			
			else: # Click if nothing was said after 0.5 seconds or not if !wait.
				if wait:
					game.safeToSave = false
					waitTimer.wait_time = 1
					waitTimer.start()
					yield(waitTimer, 'timeout')
					game.safeToSave = true
					
				index += 1
				emit_signal('empty_line')
				global.pause_input = false
		
#		If line doesn't start with anything particular, register it as the player's thoughts
		else:
			lastKeep(index)
			var lastChar = dialogue[index].length()-1 # The position of the last character.
			
			# Handle 'soft' newlines so that a newline does't sperate lines of dialogue when displayed.
			if dialogue[index][lastChar] == 'n' and dialogue[index][lastChar-1] == '/':
				dialogue[index+1] = dialogue[index].substr(0, lastChar-1) + "\n" + dialogue[index+1]
				index += 1
			
			$Nametag.add_color_override("font_color", Color.white)
			global.rootnode.scene(dialogue[index], index+1) # Send the dialogue to the scene function in the root of the scene.
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
		"Artso Fartso":
			info[0] = 'artso'
			remove_dupes('artso', info)
			yield(self, 'dupeCheckFinished')
			if notsame[0]: parse_outfit(info, 'artso', 1, notsame[1])
		"Action Giraffe":
			info[0] = 'actiongiraffe'
			remove_dupes('ag', info)
			yield(self, 'dupeCheckFinished')
			if notsame[0]: parse_outfit(info, 'actiongiraffe', 1, notsame[1])
		"Digibro":
			info[0] = 'digibro'
			remove_dupes('digi', info)
			yield(self, 'dupeCheckFinished')
			if notsame[0]: parse_outfit(info, 'digibro', 1, notsame[1])
		"Endless War":
			info[0] = 'endlesswar'
			remove_dupes('endlesswar', info)
			yield(self, 'dupeCheckFinished')
			if notsame[0]: parse_outfit(info, 'endlesswar', 1, notsame[1])
		"Hippo":
			info[0] = 'hippo'
			remove_dupes('hippo', info)
			yield(self, 'dupeCheckFinished')
			if notsame[0]: parse_outfit(info, 'hippo', 1, notsame[1])
		"Mage":
			info[0] = 'mage'
			remove_dupes('mage', info)
			yield(self, 'dupeCheckFinished')
			if notsame[0]: parse_outfit(info, 'mage', 1, notsame[1])
		"Munchy":
			info[0] = 'munchy'
			remove_dupes('munchy', info)
			yield(self, 'dupeCheckFinished')
			if notsame[0]: parse_outfit(info, 'munchy', 1, notsame[1])
		"Nate":
			info[0] = 'nate'
			remove_dupes('nate', info)
			yield(self, 'dupeCheckFinished')
			if notsame[0]: parse_outfit(info, 'nate', 1, notsame[1])
		"Thoth":
			info[0] = 'thoth'
			remove_dupes('thoth', info)
			yield(self, 'dupeCheckFinished')
			parse_position(info, 'systems.display.image("res://images/characters/Thoth/thoth.png", 1)', "'res://images/characters/Thoth/thoth.png'", 1, notsame[1])
		"Tom":
			info[0] = 'tom'
			remove_dupes('tom', info)
			yield(self, 'dupeCheckFinished')
			if notsame[0]: parse_expression(info, 'tom', 'global.chr.tom.body[0]', 1, 'null', notsame[1])

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
				
				elif 'fade'.is_subsequence_of(info):
					if systems.display.layers[i]['path'] != get_body(info):
						global.pause_input = true
						game.safeToSave = false
						fade = true
						var indx
						var speed = 0.02
						var path = systems.display.layers[i]['path']
						var pos = systems.display.layers[i]['node'].position
						for i in range(0, info.size()): if info[i] == 'fade': indx = i
						if indx != size - 1: if info[indx+1].find('/') != -1:
							speed = info[indx+1].split('/', false)
							speed = float(speed[1])
						execute('systems.display.fadealpha("'+path+'", "out", 10, "self", ' + str(speed) + ', true)')
						notsame = [true, pos]
						emit_signal('dupeCheckFinished')
						yield(systems.display, 'transition_finish_fade')
						fade = false
						systems.display.remove(path)
						lastLayers = systems.display.layers.duplicate(true)
						game.safeToSave = true
						global.pause_input = false
						return
					else:
						var pos = systems.display.layers[i]['node'].position
						systems.display.remove(systems.display.layers[i]['path'])
						notsame = [true, pos]
						emit_signal('dupeCheckFinished')
						return
				
				else:
					var pos = systems.display.layers[i]['node'].position
					systems.display.remove(systems.display.layers[i]['path'])
					notsame = [true, pos]
					emit_signal('dupeCheckFinished')
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
	var num
	match info[i]:
		"campus":
			num = str(search('return global.chr.'+parsedInfo+'.campus.body', info[i+1]))
			parse_expression(info, parsedInfo+'.campus', 'global.chr.'+parsedInfo+'.campus.body['+num+']', i+2, info[i+1], pos)
		"casual":
			num = str(search('return global.chr.'+parsedInfo+'.casual.body', info[i+1]))
			parse_expression(info, parsedInfo+'.casual', 'global.chr.'+parsedInfo+'.casual.body['+num+']', i+2, info[i+1], pos)
		_:
			num = str(search('return global.chr.'+parsedInfo+'.body', info[i]))
			parse_expression(info, parsedInfo, 'global.chr.'+parsedInfo+'.body['+num+']', i+1, info[i], pos)

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
	
	if 'squat'.is_subsequence_ofi(bodyType):
		parsedInfo += '.squatting'
	elif 'knife'.is_subsequence_ofi(bodyType):
		parsedInfo += '.knife'
	
	if info[i].find('|') != -1:
		var tmp = info[i].split('|', false)
		info[i] = tmp[0]
		if tmp.size() == 3:
			blush = true
			shades = true
		elif 'blush'.is_subsequence_ofi(tmp[1]):
			if tmp[1][tmp[1].length()-1].is_valid_integer():
				blushNum = int(tmp[1][tmp[1].length()-1]) - 1
			blush = true
		elif tmp[1] == 'shades':
			shades = true
	
	if blush:
		if blushNum != null:
			AFL += '\n\tsystems.display.face(global.chr.'+parsedInfo+'.blush['+str(blushNum)+'], '+body+', 0, 0, "blush")'
		else:
			AFL += '\n\tsystems.display.face(global.chr.'+parsedInfo+'.blush, '+body+', 0, 0, "blush")'
	if shades:
		AFL += '\n\tsystems.display.face(global.chr.nate.afl[0], '+body+', 0, 0, "shades")'
	
	if "happy".is_subsequence_of(info[i]):
		num = parse_expnum(info[i], parsedInfo)
		parse_position(info, 'systems.display.image('+body+', 1)\n\tsystems.display.face(global.chr.'+parsedInfo+'.happy['+num+'], '+body+')'+AFL, body, i+1, pos)
	elif "angry".is_subsequence_of(info[i]):
		num = parse_expnum(info[i], parsedInfo)
		parse_position(info, 'systems.display.image('+body+', 1)\n\tsystems.display.face(global.chr.'+parsedInfo+'.angry['+num+'], '+body+')'+AFL, body, i+1, pos)
	elif "confused".is_subsequence_of(info[i]):
		num = parse_expnum(info[i], parsedInfo)
		parse_position(info, 'systems.display.image('+body+', 1)\n\tsystems.display.face(global.chr.'+parsedInfo+'.confused['+num+'], '+body+')'+AFL, body, i+1, pos)
	elif "neutral".is_subsequence_of(info[i]):
		num = parse_expnum(info[i], parsedInfo)
		parse_position(info, 'systems.display.image('+body+', 1)\n\tsystems.display.face(global.chr.'+parsedInfo+'.neutral['+num+'], '+body+')'+AFL, body, i+1, pos)
	elif "sad".is_subsequence_of(info[i]):
		num = parse_expnum(info[i], parsedInfo)
		parse_position(info, 'systems.display.image('+body+', 1)\n\tsystems.display.face(global.chr.'+parsedInfo+'.sad['+num+'], '+body+')'+AFL, body, i+1, pos)
	elif "shock".is_subsequence_of(info[i]):
		num = parse_expnum(info[i], parsedInfo)
		parse_position(info, 'systems.display.image('+body+', 1)\n\tsystems.display.face(global.chr.'+parsedInfo+'.shock['+num+'], '+body+')'+AFL, body, i+1, pos)
	elif "smitten".is_subsequence_of(info[i]):
		num = parse_expnum(info[i], parsedInfo)
		parse_position(info, 'systems.display.image('+body+', 1)\n\tsystems.display.face(global.chr.'+parsedInfo+'.smitten['+num+'], '+body+')'+AFL, body, i+1, pos)
	else:
		parse_position(info, 'systems.display.image('+body+', 1)'+AFL, body, i, pos)

# Determines the correct face number for an epxression.
func parse_expnum(expression, parsedInfo):
	var length = expression.length()
	
	if expression[length-1].is_valid_integer():
		var num = int(expression[length-1])
		if num == 1:
			return '0'
		elif num == 2:
			return '1'
		elif num == 3:
			return '2'
	elif 'min' == expression.substr(length-3, 3):
		return '0'
	elif 'med' == expression.substr(length-3, 3):
		return '1'
	elif 'max' == expression.substr(length-3, 3):
		var num = execreturn('return global.chr.'+parsedInfo+'.'+expression.rstrip('max')+'.size()')
		if num == 3:
			return '2'
		elif num == 2:
			return '1'
	else:
		return '0'

# Parses 911's special mask case.
func parse_911(info, parsedInfo, i, pos):
	
	if 'pew'.is_subsequence_ofi(info[i]):
		parse_position(info, 'systems.display.mask(global.chr.'+parsedInfo+'.body[2], global.chr.'+parsedInfo+'.video[2], "video", 1)', 'global.chr.'+parsedInfo+'.body[2]', 2, pos)
	elif 'boi' == info[i]:
		parse_position(info, 'systems.display.mask(global.chr.'+parsedInfo+'.body[0], global.chr.'+parsedInfo+'.video[0], "video", 1)', 'global.chr.'+parsedInfo+'.body[0]', 2, pos)
	elif 'standin'.is_subsequence_ofi(info[i]):
		parse_position(info, 'systems.display.mask(global.chr.'+parsedInfo+'.body[3], global.chr.'+parsedInfo+'.video[3], "video", 1)', 'global.chr.'+parsedInfo+'.body[3]', 2, pos)
	elif 'concern' == info[i]:
		parse_position(info, 'systems.display.mask(global.chr.'+parsedInfo+'.body[1], global.chr.'+parsedInfo+'.video[1], "video", 1)', 'global.chr.'+parsedInfo+'.body[1]', 2, pos)

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
		
		if fade: if i < info.size(): if info[i].find('/') != -1:
				speed = info[i].split('/', false)
				speed = float(speed[0])
				info.remove(i)
		
		if i == info.size():
			if transition == 'silhouette': execute(parsedInfo+'\n\tsystems.display.fadeblack('+body+', "in", 0)\n\tsystems.display.position('+body+', '+str(pos[0])+', '+str(pos[1])+')')
			elif fade: execute(parsedInfo+'\n\tsystems.display.fadealpha('+body+', "in", 10, "self", 0.01)\n\tsystems.display.position('+body+', '+str(pos[0])+', '+str(pos[1])+')')
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
		print('hi')
		pass # Do nothing if the character is speaking off screen.
	else:
		return

# Function to parse position movement.
func parse_move(info, body, i):
	var speed = '20'
	var extra = 0
	var num
	
	if info.size()-1 > i+1:
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

# Function to search bodies for the correct one.
func search(body, info):
	body = execreturn(body)
	for i in range(0, body.size()):
		if body[i].findn(info) != -1:
			return i

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
			num = str(search('return global.chr.'+info[0]+'.campus.body', info[i+1]))
			body = 'global.chr.'+info[0]+'.campus.body['+num+']'
		"casual":
			num = str(search('return global.chr.'+info[0]+'.casual.body', info[i+1]))
			body = 'global.chr.'+info[0]+'.casual.body['+num+']'
		_:
			num = str(search('return global.chr.'+info[0]+'.body', info[i]))
			body = 'global.chr.'+info[0]+'.body['+num+']'
	
	body = execreturn('return ' + body)
	if info[0] == 'nine11': body = body.rstrip('png') + 'ogv'
	return body