#I use a ColorRect as the dialogue box, but replacing it with a TextureRect shouldn't be a problem
extends ColorRect

var dialogue = PoolStringArray() #All of the lines in the current text file. Not using a regular array for better performance
var i = 0 #Index of current line of dialogue
var regex = RegEx.new()
var systems
var click = InputEventMouseButton.new()

signal empty_line
signal sentence_end

#Colors:
#	Tom - d23735
#	Mage - 551A8B
#	Ben - 8d8d8d
#	Digi - b21069
#	Davoo - 408ff2
#	Jess - fdf759
#	Munchy - ff7ab9
#	Hippo - 78ffb5

func _ready(): 
	systems = global.rootnode.get_node("Systems") # Assign the systems no to systems.

	#Opens the document containing the scene's script (as in the dialogue)
	var f = File.new()
	f.open("res://script_document.txt", File.READ)
	
#	var err = f.open_encrypted_with_pass("res://document.txt", File.READ, "password") ability to read encrypted files 
	#Stores every line of dialogue in the array
	while not f.eof_reached():
		dialogue.push_back(f.get_line())
		i += 1
	f.close()
	self.connect("empty_line", self, "_on_Dialogue_has_been_read")
	self.connect('sentence_end', global.rootnode, 'scene')
	i = 0 #Reset index of dialogue
	emit_signal("empty_line") #Signals to display first line of dialogue
	
	# Define a click event.
	click.button_index = 1
	click.pressed = true



func say(words, character = ""):
	#Nametag is the label above the textbox, dialogue's say is what updates the textbox.
	$Nametag.text = character
	$Dialogue.say(words)


func _on_Dialogue_has_been_read():
	if i < dialogue.size(): #Checks to see if end of document has been reached
		#Skips empty lines e.g spacing
		while dialogue[i].length() == 0:
			i += 1
	
	#Reacts differently depending on the start of the current line. Choices and commands are still WIP, but dialogue is pretty much done.
	
		if dialogue[i].begins_with("["):
			if dialogue[i].findn('REMOVE') != -1:
				var command = dialogue[i].lstrip('[')
				command = command.rstrip(']')
				command = command.split(' ', false, 1)
				for i in range(0, systems.display.layers.size() - 1):
					var layer = systems.display.layers[i]['name']
					if layer.findn(command[1].to_lower()) != -1:
						systems.display.remove(layer)
			i += 1
			get_tree().input_event(click)
		
		elif dialogue[i].begins_with("*"):
			print("Choice - " + dialogue[i])
			i += 1
			get_tree().input_event(click)
		
		elif dialogue[i].begins_with("("):
			
			#Dialogue template:
			#(Speaker): Dialogue text here
			
			#Replaces every instance of the word "Player" with "PCPGuy". You can easily
			#tweak this to replace another word, or to replace it with a varia le i.e an inputted player name
			regex.compile("Player")
			dialogue[i] = regex.sub(dialogue[i], "PCPGuy", true)

			var splitLine = dialogue[i].split(":", true, 1) #Split current line into 2 strings
			splitLine[1] = splitLine[1].substr(1, (dialogue[i].length() - (splitLine[0].length() + 1))) #Start string after colon
			splitLine[0] = splitLine[0].substr(splitLine[0].find("(") + 1, splitLine[0].find(")") - 1) #"Crop" the info inside of the parentheses
			
			var info = splitLine[0].split(',') # Split the info inside the parentheses on commas.
			
			# Remove all spaces before and after the info.
			for i in range(0, info.size()):
				while info[i][0] == ' ':
					info[i] = info[i].right(1)
				while info[i][info[i].length() - 1] == ' ':
					info[i] = info[i].left(info[i].length() - 1)
			
			# Make all information lowercase except info[0].
			for i in range(1, info.size()):
				info[i] = info[i].to_lower()
			
			parse_info(info); # Parse the info so that is displays a character.
			
#			Function for custom fonts. This can be incorporated in the following
#			"match" section to use different fonts for differents speakers 
#			var mageFontData = DynamicFontData.new()
#			mageFontData.font_path = "res://fonts/Nametag/karmatic_arcade/ka1.ttf"
#			var mageFont = DynamicFont.new()
#			mageFont.font_data = mageFontData
#			mageFont.size = 68
#			$Nametag.add_font_override("normal_font", mageFont)

#			Change nametag color depending on current speaker
			match info[0]:
				"Tom":
					$Nametag.add_color_override("font_color", Color('#f00000'))
				"Mage":
					$Nametag.add_color_override("font_color", Color('551A8B'))
				"Ben":
					$Nametag.add_color_override("font_color", Color('8d8d8d'))
				"Digi":
					$Nametag.add_color_override("font_color", Color('b21069'))
				"Davoo":
					$Nametag.add_color_override("font_color", Color('408ff2'))
				"Jess":
					$Nametag.add_color_override("font_color", Color('fdf759'))
				"Munchy":
					$Nametag.add_color_override("font_color", Color('ff7ab9'))
				"Hippo":
					$Nametag.add_color_override("font_color", Color('78ffb5'))
				"Endless War":
					$Nametag.add_color_override("font_color", Color('ffff00'))
				
			say(splitLine[1], info[0])
			get_node("Dialogue").isCompartmentalized = false #Set so next line can be compartmentalized
			emit_signal('sentence_end', dialogue[i])
			i += 1
		
#		If line doesn't start with anything particular, register it as the player's thoughts
		else:
			$Nametag.add_color_override("font_color", Color(1,1,1))
			say(dialogue[i], "") #Nametag can freely be replaced with player's name
			emit_signal('sentence_end', dialogue[i])
			i += 1



# Generates function calls to the image system by parsing the script.
func parse_info(info):
	var notsame
	match info[0]:
		"Action Giraffe":
			notsame = remove_dupes('ag', info)
			if notsame: parse_outfit(info, 'actiongiraffe', 1)
		"Digibro":
			notsame = remove_dupes('digi', info)
			if notsame: parse_outfit(info, 'digibro', 1)
		"Endless War":
			notsame = remove_dupes('endlesswar', info)
			if notsame: parse_outfit(info, 'endlesswar', 1)
		"Hippo":
			notsame = remove_dupes('hippo', info)
			if notsame: parse_outfit(info, 'hippo', 1)
		"Mage":
			notsame = remove_dupes('mage', info)
			if notsame: parse_outfit(info, 'mage', 1)
		"Munchy":
			notsame = remove_dupes('munchy', info)
			if notsame: parse_outfit(info, 'munchy', 1)
		"Nate":
			notsame = remove_dupes('nate', info)
			if notsame: parse_outfit(info, 'nate', 1)
		"Thoth":
			remove_dupes('thoth', info)
			parse_position(info, 'systems.display.image("res://images/characters/Thoth/thoth.png", 1)', "'res://images/characters/Thoth/thoth.png'", 1)
		"Tom":
			notsame = remove_dupes('tom', info)
			if notsame: parse_outfit(info, 'tom', 1)

# Removes duplicate bodies of characters if they exist.
func remove_dupes(character, info):
	var size = info.size()
	for i in range(0, systems.display.layers.size() - 1):
		var layer = systems.display.layers[i]['name']
		if layer.findn(character) != -1:
			if size == 1:
				return false
			elif size == 2:
				parse_position(info, '', '"'+systems.display.layers[i]['path']+'"', 1)
				return false
			else:
				systems.display.remove(layer)
				return true
	return true

# Parses the characters outfit.
func parse_outfit(info, parsedInfo, i):
	var num
	match info[i]:
		"campus":
			num = str(search('return systems.chr.'+parsedInfo+'.campus.body', info[i+1]))
			parse_expression(info, parsedInfo+'.campus', 'systems.chr.'+parsedInfo+'.campus.body['+num+']', i+2, info[i+1])
		"casual":
			num = str(search('return systems.chr.'+parsedInfo+'.casual.body', info[i+1]))
			parse_expression(info, parsedInfo+'.casual', 'systems.chr.'+parsedInfo+'.casual.body['+num+']', i+2, info[i+1])
		_:
			num = str(search('return systems.chr.'+parsedInfo+'.body', info[i]))
			parse_expression(info, parsedInfo, 'systems.chr.'+parsedInfo+'.body['+num+']', i+1, info[i])

# Parses the characters expression.
func parse_expression(info, parsedInfo, body, i, bodyType):
	var blush = false
	var shades = false
	var knife = false
	var blushNum
	var num
	
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
	
	if "happy".is_subsequence_of(info[i]):
		num = parse_expnum(info[i], parsedInfo)
		parse_position(info, 'systems.display.image('+body+', 1)\n\tsystems.display.face(systems.chr.'+parsedInfo+'.happy['+num+'], '+body+')', body, i+1)
	elif "angry".is_subsequence_of(info[i]):
		num = parse_expnum(info[i], parsedInfo)
		parse_position(info, 'systems.display.image('+body+', 1)\n\tsystems.display.face(systems.chr.'+parsedInfo+'.angry['+num+'], '+body+')', body, i+1)
	elif "confused".is_subsequence_of(info[i]):
		num = parse_expnum(info[i], parsedInfo)
		parse_position(info, 'systems.display.image('+body+', 1)\n\tsystems.display.face(systems.chr.'+parsedInfo+'.confused['+num+'], '+body+')', body, i+1)
	elif "neutral".is_subsequence_of(info[i]):
		num = parse_expnum(info[i], parsedInfo)
		parse_position(info, 'systems.display.image('+body+', 1)\n\tsystems.display.face(systems.chr.'+parsedInfo+'.neutral['+num+'], '+body+')', body, i+1)
	elif "sad".is_subsequence_of(info[i]):
		num = parse_expnum(info[i], parsedInfo)
		parse_position(info, 'systems.display.image('+body+', 1)\n\tsystems.display.face(systems.chr.'+parsedInfo+'.sad['+num+'], '+body+')', body, i+1)
	elif "shock".is_subsequence_of(info[i]):
		num = parse_expnum(info[i], parsedInfo)
		parse_position(info, 'systems.display.image('+body+', 1)\n\tsystems.display.face(systems.chr.'+parsedInfo+'.shock['+num+'], '+body+')', body, i+1)
	elif "smitten".is_subsequence_of(info[i]):
		num = parse_expnum(info[i], parsedInfo)
		parse_position(info, 'systems.display.image('+body+', 1)\n\tsystems.display.face(systems.chr.'+parsedInfo+'.smitten['+num+'], '+body+')', body, i+1)
	
	if blush:
		if blushNum != null:
			execute('systems.display.face(systems.chr.'+parsedInfo+'.blush['+str(blushNum)+'], '+body+', 0, 0, "blush")')
		else:
			execute('systems.display.face(systems.chr.'+parsedInfo+'.blush, '+body+', 0, 0, "blush")')
	if shades:
		execute('systems.display.face(systems.chr.nate.afl[0], '+body+', 0, 0, "shades")')

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
		var num = execreturn('return systems.chr.'+parsedInfo+'.'+expression.rstrip('max')+'.size()')
		if num == 3:
			return '2'
		elif num == 2:
			return '1'
	else:
		return '0'

# Parses the position for a character.
func parse_position(info, parsedInfo, body, i):
	var extra = 0
	var num
	
	if i == info.size():
		execute(parsedInfo)
		return
	
	if info[i].findn('+') != -1:
		var tmp = info[i].split('+', true, 1)
		info[i] = tmp[0]
		extra = int(tmp[1])
	elif info[i].findn('-') != -1:
		var tmp = info[i].split('-', true, 1)
		info[i] = tmp[0]
		extra = int(tmp[1]) * -1
	
	if info[i].findn('|') != -1:
		var cords = info[i].split('|', false, 1)
		execute(parsedInfo+'\n\tsystems.display.position('+body+', '+cords[0]+', '+cords[1]+')')
	elif info[i] == 'right':
		num = 600 + extra
		execute(parsedInfo+'\n\tsystems.display.position('+body+', '+str(num)+', 0)')
	elif info[i] == 'left':
		num = -600 + extra
		execute(parsedInfo+'\n\tsystems.display.position('+body+', '+str(num)+', 0)')
	elif info[i] == 'center':
		execute(parsedInfo+'\n\tsystems.display.position('+body+', '+str(extra)+', 0)')

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