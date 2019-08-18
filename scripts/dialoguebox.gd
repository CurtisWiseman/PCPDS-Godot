#I use a ColorRect as the dialogue box, but replacing it with a TextureRect shouldn't be a problem
extends ColorRect

var dialogue = PoolStringArray() #All of the lines in the current text file. Not using a regular array for better performance
var i = 0 #Index of current line of dialogue
var regex = RegEx.new()

signal empty_line

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
	i = 0 #Reset index of dialogue
	emit_signal("empty_line") #Signals to display first line of dialogue
	



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
			print("Command - " + dialogue[i])
			i += 1
		
		elif dialogue[i].begins_with("*"):
			print("Choice - " + dialogue[i])
			i += 1
		
		elif dialogue[i].begins_with("("):
			
			#Dialogue template:
			#(Speaker): Dialogue text here
			
			#Replaces every instance of the word "Player" with "PCPGuy". You can easily
			#tweak this to replace another word, or to replace it with a variable i.e an inputted player name
			regex.compile("Player")
			dialogue[i] = regex.sub(dialogue[i], "PCPGuy", true)

			var splitLine = dialogue[i].split(":", true, 1) #Split current line into 2 strings
			splitLine[1] = splitLine[1].substr(1, (dialogue[i].length() - (splitLine[0].length() + 1))) #Start string after colon
			splitLine[0] = splitLine[0].substr(splitLine[0].find("(") + 1, splitLine[0].find(")") - 1) #"Crop" name inside of parentheses

#			Function for custom fonts. This can be incorporated in the following
#			"match" section to use different fonts for differents speakers 
#			var mageFontData = DynamicFontData.new()
#			mageFontData.font_path = "res://fonts/Nametag/karmatic_arcade/ka1.ttf"
#			var mageFont = DynamicFont.new()
#			mageFont.font_data = mageFontData
#			mageFont.size = 68
#			$Nametag.add_font_override("normal_font", mageFont)

#			Change nametag color depending on current speaker
			match splitLine[0]:
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
			say(splitLine[1], splitLine[0])
			get_node("Dialogue").isCompartmentalized = false #Set so next line can be compartmentalized
			i += 1

#		If line doesn't start with anything particular, register it as the player's thoughts
		else:
			$Nametag.add_color_override("font_color", Color(1,1,1))
			say(dialogue[i], "PCPGuy") #Nametag can freely be replaced with player's name
			i += 1