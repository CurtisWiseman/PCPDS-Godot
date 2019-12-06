extends Node

var SAVE_FOLDER = 'user://saves'
var SAVE_NAME_TEMPLATE = 'save%d.tres'
var SAVE_IMAGE_NAME_TEMPLATE = 'save%d.png'
var loadSaveFile = false
var blockInput = false
var safeToSave = false
# warning-ignore:unused_signal
signal continue_loading


# Function to save the game using a .tres file
func save(saveBoxName, saveBoxNum, sliders):
	
	if safeToSave:
		blockInput = true # Block certain inputs while saving.
		
		# Create the SAVE_FOLDER directory if it doesn't exist.
		var directory = Directory.new()
		var file = File.new()
		
		if !directory.dir_exists(SAVE_FOLDER):
			directory.make_dir(SAVE_FOLDER)
		
		# Get relevant system nodes.
		var sound = global.rootnode.get_node('Systems/Sound')
		var display = global.rootnode.get_node('Systems/Display')
		var dialogue = global.rootnode.get_node('Systems/Pause Canvas/Dialogue Canvas/Dialogue Box')
		
		
		
		# Take a screenshot to use on the load screen.
		var image = get_viewport().get_texture().get_data()
		image.flip_y()
		image.save_png(SAVE_FOLDER.plus_file(SAVE_IMAGE_NAME_TEMPLATE % saveBoxNum))
		
		
		
		# CURRENT VERSION AND CURRENT SCENE
		var gameVersion = ProjectSettings.get_setting('application/config/version')
		var sceneName = get_tree().get_current_scene().get_name()
		sceneName = sceneName.substr(0, sceneName.length()-6)
		
		# MUSIC SYSTEM
		var musicPlaying = sound.playing.path + "," + str(sound.playing.loop) + "," + str(sound.playing.volume)
		var musicQueue = sound.queue
		
		if musicQueue == []:
			musicQueue = "NULL"
		else:
			var musicArray = musicQueue
			musicQueue = ''
			var i = 1
			for music in musicArray:
				if i == musicArray.size():
					musicQueue += music.path + ',' + str(music.loop) + ',' + str(music.volume)
					break
				else:
					musicQueue += music.path + ',' + str(music.loop) + ',' + str(music.volume) + '|'
					i += 1
		
		# DIALOGUE SYSTEM
		var script = dialogue.script
		var lastSpoken = str(dialogue.lastSpoken)
		var inChoice = str(dialogue.lastInChoice)
		var choices = dialogue.lastChoices
		var chosenChoices = dialogue.lastChosenChoices
		var lastBody = dialogue.lastBody
		
		if choices == []:
			choices = "NULL"
		else:
			var choiceArray = choices
			choices = ''
			var i = 1
			for choice in choiceArray:
				if i == choiceArray.size():
					choices += choice
					break
				else:
					choices += choice + ','
					i += 1
		
		if chosenChoices == []:
			chosenChoices = "NULL"
		else:
			var choiceArray = chosenChoices
			chosenChoices = ''
			var i = 1
			for choice in choiceArray:
				if i == choiceArray.size():
					chosenChoices += choice
					break
				else:
					chosenChoices += choice + ','
					i += 1
		
		# DISPLAY SYSTEM
		var displayBackground
		if dialogue.lastBGNode == display:
			displayBackground = "NULL"
		else:
			displayBackground = dialogue.lastBGNode.texture.resource_path
			displayBackground = displayBackground + ',' + dialogue.lastBGType
		
		var displayChildren = []
		var displayFaces = []
		var displayMaskChildren = []
		if dialogue.lastLayers == []:
			displayChildren = "NULL"
		else:
			for layer in dialogue.lastLayers:
				if sliders != []:
					for node in sliders:
						if node['path'] == layer['path'] and node['path'] != lastBody:
							layer['position'].x = node['dest']
				
				var prefix = ''
				if layer['path'].substr(0,6) != 'res://': prefix = 'res://'
				
				if layer.has('mask'):
					var maskPrefix = ''
					if layer['mask'].substr(0,6) != 'res://': maskPrefix = 'res://'
					
					if layer['type'] == 'image':
						displayMaskChildren.append(maskPrefix + layer['mask'] + ',' + prefix + layer['path'] + ',' + 'image' + ',' + str(layer['layer']) + ',' + str(layer['position'].x) + "|" + str(layer['position'].y))
					elif layer['type'] == 'video':
						displayMaskChildren.append(maskPrefix + layer['mask'] + ',' + prefix + layer['path'] + ',' + 'video' + ',' + str(layer['layer']) + ',' + str(layer['position'].x) + "|" + str(layer['position'].y))
				else:
					if layer['type'] == 'image':
						displayChildren.append(prefix + layer['path'] + ',' + 'image' + ',' + str(layer['layer']) + ',' + str(layer['position'].x) + "|" + str(layer['position'].y))
					elif layer['type'] == 'video':
						displayChildren.append(prefix + layer['path'] + ',' + 'video' + ',' + str(layer['layer']) + ',' + str(layer['position'].x) + "|" + str(layer['position'].y))
				
				if layer.has('face'):
					displayFaces.append(layer['face'].texture.resource_path + ',' + prefix + layer['path'] + ',' + str(layer['facepos'].x) + ',' + str(layer['facepos'].y))
				
				if layer.has('AFL'):
					for i in range(0, layer['AFL'].size()):
						displayFaces.append(layer['AFL'][i].texture.resource_path + ',' + prefix + layer['path'] + ',' + str(layer['AFL'][i].x) + ',' + str(layer['AFL'][i].y) + ',other')
		
		
		
		#WRITE THE SAVE FILE.
		var savePath = SAVE_FOLDER.plus_file(SAVE_NAME_TEMPLATE % saveBoxNum)
		file.open_encrypted_with_pass(savePath, File.WRITE, 'G@Y&D3@D')
		file.store_line(gameVersion)
		file.store_line(saveBoxName)
		file.store_line(sceneName)
		file.store_line('-music-')
		file.store_line(musicPlaying)
		file.store_line(musicQueue)
		file.store_line('-dialogue-')
		file.store_line(script)
		file.store_line(lastSpoken)
		file.store_line(inChoice)
		file.store_line(choices)
		file.store_line(chosenChoices)
		file.store_line('-display-')
		file.store_line(displayBackground)
		
		for child in displayChildren:
			file.store_line(child)
		
		if displayFaces != []:
			file.store_line('faces')
			for child in displayFaces:
				file.store_line(child)
		
		if displayMaskChildren != []:
			file.store_line('masks')
			for child in displayMaskChildren:
				file.store_line(child)
		
		file.close()
		
		blockInput = false # Unblock all blocked systems.





# Function to load a specified save file.
func load(save):
	# Disallow saving and block certain inputs.
	blockInput = true
	loadSaveFile = true
	game.safeToSave = false
	
	# Get the save file as an array of strings based on newlines.
	var savePath = SAVE_FOLDER.plus_file(save)
	var file = File.new()
	file.open_encrypted_with_pass(savePath, File.READ, 'G@Y&D3@D')
	var saveText = file.get_as_text().split('\n', false)
	file.close()
	
	# Change to the saved scene.
	var systems = global.rootnode.get_node('Systems')
	systems.scene.change(saveText[2])
	yield(self, 'continue_loading')
	systems = global.rootnode.get_node('Systems')
	
	
	
	# LOAD MUSIC
	if saveText[4] != 'NULL,NULL,NULL':
		var music = saveText[4].split(',', false)
		systems.sound.music(music[0], bool(music[1]), int(music[2]))
	
	if saveText[5] != 'NULL':
		var elements = saveText[5].split('|', true)
		for element in elements:
			var music = element.split(',', false)
			systems.sound.queue(music[0], bool(music[1]), int(music[2]))
	
	
	# LOAD DISPLAY
	if saveText[13] != 'NULL':
		var background = saveText[13].split(',', false)
		systems.display.background(background[0], background[1])
	
	var i = 14
	var more = true
	var size = saveText.size()
	
	while saveText[i] != 'faces' and saveText[i] != 'masks' and more: # Load all display content.
		var item = saveText[i].split(',', false)
		
		if item[1] == 'image': systems.display.image(item[0], int(item[2]))
		else: systems.display.video(item[0], int(item[2]))
			
		if item[3] != '0|0':
			var pos = item[3].split('|', false)
			systems.display.position(item[0], int(pos[0]), int(pos[1]))
		
		if i+1 == size: more = false
		else: i += 1
	
	if more and saveText[i] == 'faces': # If more content and that content is faces then load them.
		i+=1
		while saveText[i] != 'masks' and more:
			var face = saveText[i].split(',', false)
			if face.size() == 4: systems.display.face(face[0], face[1], int(face[2]), int(face[3]))
			else: systems.display.face(face[0], face[1], int(face[2]), int(face[3]), face[4])
			if i+1 == size: more = false
			else: i += 1
	
	if more: # If any content is left then it is masked content. Load it.
		i+=1
		while more:
			var mask = saveText[i].split(',', false)
		
			if mask[2] == 'image': systems.display.mask(mask[0], mask[1], mask[2], int(mask[3]))
			else: systems.display.mask(mask[0], mask[1], mask[2], int(mask[3]))
			
			if mask[4] != '0|0':
				var pos = mask[4].split('|', false)
				systems.display.position(mask[1], int(pos[0]), int(pos[1]))
		
			if i+1 == size: more = false
			else: i += 1
	
	
	# LOAD DIALOGUE
	var inChoice = false
	var choiceArray = []
	var chosenChoiceArray = []
	
	if saveText[9] == 'True':inChoice = true
	
	if saveText[10] != 'NULL':
		var stringArray = saveText[10].split(',', true)
		for string in stringArray: choiceArray.append(string)
	if saveText[11] != 'NULL':
		var stringArray = saveText[11].split(',', true)
		for string in stringArray: chosenChoiceArray.append(string)
	
	systems.dialogue(saveText[7], int(saveText[8]), choiceArray, inChoice, chosenChoiceArray)
	
	
	
	# Allow the player to interact with the new scene.
	blockInput = false
	loadSaveFile = false
	game.safeToSave = true
	get_tree().paused = false