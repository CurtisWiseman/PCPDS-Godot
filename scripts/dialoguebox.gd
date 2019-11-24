#I use a ColorRect as the dialogue box, but replacing it with a TextureRect shouldn't be a problem
extends ColorRect

var dialogue = PoolStringArray() #All of the lines in the current text file. Not using a regular array for better performance
var index = 0 #Index of current line of dialogue
var script
var regex = RegEx.new()
var systems
var choices = []
var chosenChoices = []
var waitTimer = Timer.new()

signal empty_line
signal sentence_end
signal sliding_finished


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
	index = 0 #Reset index of dialogue
	emit_signal("empty_line") #Signals to display first line of dialogue
	
	# Define a wait timer.
	waitTimer.one_shot = true
	waitTimer.autostart = false
	add_child(waitTimer)


func say(words, character = ""):
	#Nametag is the label above the textbox, dialogue's say is what updates the textbox.
	$Nametag.text = character
	$Dialogue.say(words)


func _on_Dialogue_has_been_read():
	if index < dialogue.size(): #Checks to see if end of document has been reached
		#Skips empty lines e.g spacing
		while dialogue[index].length() == 0:
			index += 1
	
	#Reacts differently depending on the start of the current line.
		# Load while on first line.
		if index == 0:
			waitTimer.wait_time = 1
			waitTimer.start()
			yield(waitTimer, "timeout")
		
		# COMMENTS/COMMANDS
		if dialogue[index].begins_with("["):
			
			if '9/11'.is_subsequence_of(dialogue[index]):
				regex.compile('9/11')
				dialogue[index] = regex.sub(dialogue[index], "911", true)
			
			if dialogue[index].findn('REMOVE') != -1:
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
							parse_move(['slide', command[2]], '"'+systems.display.layers[i]['path']+'"', 0, false)
						elif command.size() == 4:
							parse_move(['slide', command[2], command[3]], '"'+systems.display.layers[i]['path']+'"', 0, false)
						break
			
			global.rootnode.scene(dialogue[index])
			index += 1
			emit_signal('empty_line')
		
		
		# CHOICES
		elif dialogue[index].begins_with("*"):
			var choice  = dialogue[index].lstrip('*')
			choice = choice.rstrip('*')
			
			var pastChoice = false
			var chosenChoice = false
			
			if 'UNDO' == choice.substr(0, 4):
				print(choice)
				return
			
			elif choices.size() != 0:
				for i in range(0, choices.size()):
					if choice == choices[i]:
						pastChoice = true
						break
			
			elif pastChoice:
				for i in range(0, chosenChoices.size()):
					if choice == chosenChoices[i]:
						chosenChoice = true
			else:
				choices.append(choice)
				# Display a choice visually
			
			index += 1
			emit_signal('empty_line')
		
		
		# DIALOGUE
		elif dialogue[index].begins_with("("):
			
			var info # Contains provided character information.
			var text # Contains the words the character says.
			var say = true # Whether or not say the character text.
			var lastChar = dialogue[index].length()-1 # The position of the last character.
			var wait = true # Whether or not to wait when no text to say.
			var slide = false # Checks if character is sliding.
			
			#Replaces every instance of the word "Player" with "PCPGuy". You can easily
			#tweak this to replace another word, or to replace it with a varia le index.e an inputted player name
			regex.compile("Player")
			dialogue[index] = regex.sub(dialogue[index], "PCPGuy", true)
			
			# If there is no text on the line then don't say anything.
			if dialogue[index][lastChar] == ')' or dialogue[index][lastChar] == '$':
				say = false
				global.pause_input = true
				if 'slide'.is_subsequence_ofi(dialogue[index]): 
					slide = true
					wait = false
				elif dialogue[index][lastChar] == '$': wait = false
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
				
				
				say(text, chrName)
				get_node("Dialogue").isCompartmentalized = false #Set so next line can be compartmentalized
				global.rootnode.scene(dialogue[index]) # Send the dialogue to the scene function in the root of the scene.
				emit_signal('sentence_end', dialogue[index])
				index += 1
			
			else: # Click if nothing was said after 0.5 seconds or not if !wait.
				if wait:
					waitTimer.wait_time = 1
					waitTimer.start()
					yield(waitTimer, 'timeout')
				
				if slide:
					yield(self, 'sliding_finished')
					waitTimer.wait_time = 1
					waitTimer.start()
					yield(waitTimer, 'timeout')
					
				index += 1
				emit_signal('empty_line')
				global.pause_input = false
		
#		If line doesn't start with anything particular, register it as the player's thoughts
		else:
			$Nametag.add_color_override("font_color", Color(1,1,1))
			say(dialogue[index], "") #Nametag can freely be replaced with player's name
			global.rootnode.scene(dialogue[index]) # Send the dialogue to the scene function in the root of the scene.
			emit_signal('sentence_end', dialogue[index])
			index += 1










# Generates function calls to the image system by parsing the script.
func parse_info(info):
	var notsame
	match info[0]:
		"9/11":
			notsame = remove_dupes('911', info)
			if notsame: parse_911(info, 'nine11', 1)
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
			if notsame: parse_expression(info, 'tom', 'global.chr.tom.body[0]', 1, 'null')

# Removes duplicate bodies of characters if they exist.
func remove_dupes(character, info):
	var size = info.size()
	for i in range(0, systems.display.layers.size()):
		var layer = systems.display.layers[i]['name']
		if layer.findn(character) != -1:
			if size == 1:
				return false
			elif size >= 2:
				if info[1] == 'right' or info[1] == 'left' or info[1] == 'center' or info[1] == 'offleft' or info[1] == 'offright' or info[1] == 'slide' or info[1] == 'off':
					parse_position(info, '', '"'+systems.display.layers[i]['path']+'"', 1)
					return false
				else:
					systems.display.remove(systems.display.layers[i]['path'])
					return true
	return true

# Parses the characters outfit.
func parse_outfit(info, parsedInfo, i):
	var num
	match info[i]:
		"campus":
			num = str(search('return global.chr.'+parsedInfo+'.campus.body', info[i+1]))
			parse_expression(info, parsedInfo+'.campus', 'global.chr.'+parsedInfo+'.campus.body['+num+']', i+2, info[i+1])
		"casual":
			num = str(search('return global.chr.'+parsedInfo+'.casual.body', info[i+1]))
			parse_expression(info, parsedInfo+'.casual', 'global.chr.'+parsedInfo+'.casual.body['+num+']', i+2, info[i+1])
		_:
			num = str(search('return global.chr.'+parsedInfo+'.body', info[i]))
			parse_expression(info, parsedInfo, 'global.chr.'+parsedInfo+'.body['+num+']', i+1, info[i])

# Parses the characters expression.
func parse_expression(info, parsedInfo, body, i, bodyType):
	var blush = false
	var shades = false
	var knife = false
	var blushNum
	var num
	
	if i == info.size(): # Don't use an epxression if none is given.
		parse_position(info, 'systems.display.image('+body+', 1)', body, i)
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
	
	if "happy".is_subsequence_of(info[i]):
		num = parse_expnum(info[i], parsedInfo)
		parse_position(info, 'systems.display.image('+body+', 1)\n\tsystems.display.face(global.chr.'+parsedInfo+'.happy['+num+'], '+body+')', body, i+1)
	elif "angry".is_subsequence_of(info[i]):
		num = parse_expnum(info[i], parsedInfo)
		parse_position(info, 'systems.display.image('+body+', 1)\n\tsystems.display.face(global.chr.'+parsedInfo+'.angry['+num+'], '+body+')', body, i+1)
	elif "confused".is_subsequence_of(info[i]):
		num = parse_expnum(info[i], parsedInfo)
		parse_position(info, 'systems.display.image('+body+', 1)\n\tsystems.display.face(global.chr.'+parsedInfo+'.confused['+num+'], '+body+')', body, i+1)
	elif "neutral".is_subsequence_of(info[i]):
		num = parse_expnum(info[i], parsedInfo)
		parse_position(info, 'systems.display.image('+body+', 1)\n\tsystems.display.face(global.chr.'+parsedInfo+'.neutral['+num+'], '+body+')', body, i+1)
	elif "sad".is_subsequence_of(info[i]):
		num = parse_expnum(info[i], parsedInfo)
		parse_position(info, 'systems.display.image('+body+', 1)\n\tsystems.display.face(global.chr.'+parsedInfo+'.sad['+num+'], '+body+')', body, i+1)
	elif "shock".is_subsequence_of(info[i]):
		num = parse_expnum(info[i], parsedInfo)
		parse_position(info, 'systems.display.image('+body+', 1)\n\tsystems.display.face(global.chr.'+parsedInfo+'.shock['+num+'], '+body+')', body, i+1)
	elif "smitten".is_subsequence_of(info[i]):
		num = parse_expnum(info[i], parsedInfo)
		parse_position(info, 'systems.display.image('+body+', 1)\n\tsystems.display.face(global.chr.'+parsedInfo+'.smitten['+num+'], '+body+')', body, i+1)
	else:
		parse_position(info, 'systems.display.image('+body+', 1)', body, i)
	
	if blush:
		if blushNum != null:
			execute('systems.display.face(global.chr.'+parsedInfo+'.blush['+str(blushNum)+'], '+body+', 0, 0, "blush")')
		else:
			execute('systems.display.face(global.chr.'+parsedInfo+'.blush, '+body+', 0, 0, "blush")')
	if shades:
		execute('systems.display.face(global.chr.nate.afl[0], '+body+', 0, 0, "shades")')

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
func parse_911(info, parsedInfo, i):
	
	if 'pew'.is_subsequence_ofi(info[i]):
		parse_position(info, 'systems.display.mask(global.chr.'+parsedInfo+'.body[2], global.chr.'+parsedInfo+'.video[2], "video", 1)', 'global.chr.'+parsedInfo+'.body[2]', 2)
	elif 'boi' == info[i]:
		parse_position(info, 'systems.display.mask(global.chr.'+parsedInfo+'.body[0], global.chr.'+parsedInfo+'.video[0], "video", 1)', 'global.chr.'+parsedInfo+'.body[0]', 2)
	elif 'standin'.is_subsequence_ofi(info[i]):
		parse_position(info, 'systems.display.mask(global.chr.'+parsedInfo+'.body[3], global.chr.'+parsedInfo+'.video[3], "video", 1)', 'global.chr.'+parsedInfo+'.body[3]', 2)
	elif 'concern' == info[i]:
		parse_position(info, 'systems.display.mask(global.chr.'+parsedInfo+'.body[1], global.chr.'+parsedInfo+'.video[1], "video", 1)', 'global.chr.'+parsedInfo+'.body[1]', 2)

# Parses the position for a character.
func parse_position(info, parsedInfo, body, i):
	var extra = 0
	var move = false
	var num
	
	if i == info.size():
		execute(parsedInfo)
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
	elif info[i] == 'slide':
		parse_move(info, body, i)
		return
	
	if info[i].findn('|') != -1:
		var cords = info[i].split('|', false, 1)
		execute(parsedInfo+'\n\tsystems.display.position('+body+', '+cords[0]+', '+cords[1]+')')
		if move: parse_move(info, body, i+1)
	elif info[i] == 'right':
		num = 600 + extra
		execute(parsedInfo+'\n\tsystems.display.position('+body+', '+str(num)+', 0)')
		if move: parse_move(info, body, i+1)
	elif info[i] == 'left':
		num = -600 + extra
		execute(parsedInfo+'\n\tsystems.display.position('+body+', '+str(num)+', 0)')
		if move: parse_move(info, body, i+1)
	elif info[i] == 'center':
		execute(parsedInfo+'\n\tsystems.display.position('+body+', '+str(extra)+', 0)')
		if move: parse_move(info, body, i+1)
	elif info[i] == 'offleft':
		execute(parsedInfo+'\n\tsystems.display.position('+body+', -1650, 0)')
		if move: parse_move(info, body, i+1)
	elif info[i] == 'offright':
		execute(parsedInfo+'\n\tsystems.display.position('+body+', 1650, 0)')
		if move: parse_move(info, body, i+1)
	elif info[i] == 'off':
		pass # Do nothing if the character is speaking off screen.
	else:
		print('Invalid movement on line ' + String(index+1) + ' of the script!')
		return

# Function to parse position movement.
func parse_move(info, body, i, stop=true):
	var speed = '15'
	var extra = 0
	var num
	
	if info.size()-1 > i+1:
		speed = info[i+2]
	
	if info[i] == 'slide':
		
		if info[i+1].findn('|') != -1:
			var cords = info[i+1].split('|', false, 1)
			execute('systems.display.position('+body+', '+cords[0]+', "slide", '+speed+')')
			if stop: wait(body)
		elif info[i+1] == 'right':
			num = 600 + extra
			execute('systems.display.position('+body+', '+str(num)+', "slide", '+speed+')')
			if stop: wait(body)
		elif info[i+1] == 'left':
			num = -600 + extra
			execute('systems.display.position('+body+', '+str(num)+', "slide", '+speed+')')
			if stop: wait(body)
		elif info[i+1] == 'center':
			execute('systems.display.position('+body+', '+str(extra)+', "slide", '+speed+')')
			if stop: wait(body)
		elif info[i+1] == 'offleft':
			execute('systems.display.position('+body+', -1650, "slide", '+speed+')')
			if stop: wait(body)
		elif info[i+1] == 'offright':
			execute('systems.display.position('+body+', 1650, "slide", '+speed+')')
			if stop: wait(body)
		else:
			print('Invalid movement on line ' + String(index+1) + ' of the script!')
			return

# Function to wait until moving finishes.
func wait(body):
	global.pause_input = true
	
#	var bname = systems.display.nodupelayername(execreturn('return '+body))
#	var k = 0
#	for i in range(1, bname.length()):
#			bname = bname.substr(0,i+k) + '*' + bname.substr(i+k, bname.length()-i)
#			k+=1
#	bname = '*' + bname
#	bname = bname + '*'
#	var node
#	var children = systems.display.get_children()
#	for child in children:
#		if child.name.matchn('*(*P*o*s*i*t*i*o*n*)*'):
#			if child.name.matchn(bname):
#				node = child
	
	yield(global.rootnode.get_node('Systems/Display/'+systems.display.getname(execreturn('return '+body))+'(Position)'), 'position_finish')
	global.pause_input = false
	emit_signal('sliding_finished')

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