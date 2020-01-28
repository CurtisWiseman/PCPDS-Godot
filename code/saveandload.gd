extends Node

var SAVE_FOLDER = 'user://saves'
var SAVE_NAME_TEMPLATE = 'save%d.tres'
var SAVE_IMAGE_NAME_TEMPLATE = 'save%d.png'
var loadSaveFile = false
var blockInput = false
var safeToSave = false


# Function to save the game using a .tres file
func save(saveBoxName, saveBoxNum, sliders):
	
	blockInput = true # Block certain inputs while saving.
	
	# Create the SAVE_FOLDER directory if it doesn't exist.
	var directory = Directory.new()
	var file = File.new()
	
	if !directory.dir_exists(SAVE_FOLDER):
		directory.make_dir(SAVE_FOLDER)
	
	# Get relevant system nodes.
	var sound = global.rootnode.get_node('Systems/Sound')
	var camera = global.rootnode.get_node('Systems/Camera')
	var display = global.rootnode.get_node('Systems/Display')
	var dialogue = global.rootnode.get_node('Systems/Pause Canvas/Dialogue Canvas/Dialogue Box')
	
	
	
	# Take a screenshot to use on the load screen.
	var image = get_viewport().get_texture().get_data()
	image.flip_y()
	image.save_png(SAVE_FOLDER.plus_file(SAVE_IMAGE_NAME_TEMPLATE % saveBoxNum))
	
	
	
	# CURRENT VERSION AND CURRENT SCENE
	var gameVersion = ProjectSettings.get_setting('application/config/version')
	var sceneName = get_tree().get_current_scene().get_name()
	
	
	
	# CAMERA SYSTEM
	var zoom = str(camera.lastZoom.x)
	var offset = str(camera.lastOffset)
	offset = offset.substr(1, offset.length()-2)
	
	
	
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
		displayBackground = displayBackground + ',' + dialogue.lastBGType + ',' + str(dialogue.lastBGNode.get_modulate()).replace(',', '|')
		
	var displayChildren = []
	var displayFaces = []
	var displayMaskChildren = []
	if dialogue.lastLayers != []:
		for layer in dialogue.lastLayers:
			if sliders != []:
				for node in sliders:
					if node['path'] == layer['path'] and node['path'] != lastBody:
						layer['position'].x = node['dest']
			
			var modulate = ',' + str(layer['node'].get_self_modulate()).replace(',', '|')
			
			if layer.has('mask'):
				if layer['type'] == 'image':
					displayMaskChildren.append(layer['mask'] + ',' + layer['path'] + ',' + 'image' + ',' + str(layer['layer']) + ',' + str(layer['position'].x) + "|" + str(layer['position'].y) + modulate)
				elif layer['type'] == 'video':
					displayMaskChildren.append(layer['mask'] + ',' + layer['path'] + ',' + 'video' + ',' + str(layer['layer']) + ',' + str(layer['position'].x) + "|" + str(layer['position'].y) + modulate)
			else:
				if layer['type'] == 'image':
					displayChildren.append(layer['path'] + ',' + 'image' + ',' + str(layer['layer']) + ',' + str(layer['position'].x) + "|" + str(layer['position'].y) + modulate)
				elif layer['type'] == 'video':
					displayChildren.append(layer['path'] + ',' + 'video' + ',' + str(layer['layer']) + ',' + str(layer['position'].x) + "|" + str(layer['position'].y) + modulate)
				
			if layer.has('face'):
				modulate = ',' + str(layer['face'].get_self_modulate()).replace(',', '|')
				displayFaces.append(layer['face'].texture.resource_path + ',' + layer['path'] + ',' + str(layer['facepos'].x) + ',' + str(layer['facepos'].y) + modulate)
			
			if layer.has('AFL'):
				for AFL in layer['AFL']:
					modulate = ',' + str(AFL['node'].get_self_modulate()).replace(',', '|')
					displayFaces.append(AFL['path'] + ',' + layer['path'] + ',' + str(AFL['position'].x) + ',' + str(AFL['position'].y) + ',' + AFL['type'] + modulate)
	
	
	
	var blackScreen = global.rootnode.get_node('Systems').blackScreen
	
	
	
	#WRITE THE SAVE FILE.
	var savePath = SAVE_FOLDER.plus_file(SAVE_NAME_TEMPLATE % saveBoxNum)
	file.open_encrypted_with_pass(savePath, File.WRITE, 'G@Y&D3@D')
	file.store_line(gameVersion)
	file.store_line(saveBoxName)
	file.store_line(sceneName)
	file.store_line(zoom+','+offset)
	file.store_line(str(blackScreen.get_self_modulate().a))
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
	
	if displayChildren != []:
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
	var index = 0
	
	# Get the save file as an array of strings based on newlines.
	var savePath = SAVE_FOLDER.plus_file(save)
	var file = File.new()
	file.open_encrypted_with_pass(savePath, File.READ, 'G@Y&D3@D')
	var saveText = file.get_as_text().split('\n', false)
	file.close()
	
	
	
	# Check game version for incompatibility.
	var version = saveText[index].split('.', false)
	var currentVersion = ProjectSettings.get_setting('application/config/version').split('.', false, 4)
	if version != null: 
		if version.size() < currentVersion.size() or version.size() > currentVersion.size():
			version = null
		else:
			var ver = version
			version = []
			for num in ver: version.append(int(num))
	
	if version == null:
		print('Incompatible save version.')
		blockInput = false
		loadSaveFile = false
		get_tree().paused = false
		return
	elif version[1] < 4:
		print("Your save's version (" + saveText[0] + ") is incompatible with the current game version (" + ProjectSettings.get_setting('application/config/version') + ")." )
		blockInput = false
		loadSaveFile = false
		get_tree().paused = false
		return
	
	
	
	# Change to the saved scene.
	index += 2
	scene.change(saveText[index])
	yield(scene, 'scene_changed')
	var systems = global.rootnode.get_node('Systems')
	index += 1
	
	
	
	# LOAD CAMERA
	var camera = saveText[index].split(',', false)
	systems.camera.zoom = Vector2(float(camera[0]), float(camera[0]))
	systems.camera.offset = Vector2(int(camera[1]), int(camera[2]))
	index += 3
	
	# LOAD MUSIC
	if saveText[index] != 'NULL,NULL,NULL':
		var music = saveText[index].split(',', false)
		if music[1] == 'True': systems.sound.music(music[0], true, int(music[2]))
		else: systems.sound.music(music[0], false, int(music[2]))
	
	index += 1
	
	if saveText[index] != 'NULL':
		var elements = saveText[index].split('|', true)
		for element in elements:
			var music = element.split(',', false)
			if music[1] == 'True': systems.sound.queue(music[0], true, int(music[2]))
			else: systems.sound.queue(music[0], false, int(music[2]))
	
	index += 8
	
	# LOAD DISPLAY
	if saveText[index] != 'NULL':
		var background = saveText[index].split(',', false)
		systems.display.background(background[0], background[1])
		if background[2] != '1|1|1|1':
			var color = background[2].split('|', false)
			systems.display.bgnode.set_modulate(Color(color[0], color[1], color[2], color[3]))
	
	index += 1
	var i = index
	var more = true
	var size = saveText.size()
	
	if size > index:
		while saveText[i] != 'faces' and saveText[i] != 'masks' and more: # Load all display content.
			var item = saveText[i].split(',', false)
			
			if item[1] == 'image': systems.display.image(item[0], int(item[2]))
			else: systems.display.video(item[0], int(item[2]))
		
			if item[3] != '0|0':
				var pos = item[3].split('|', false)
				systems.display.position(item[0], int(pos[0]), int(pos[1]))
		
			if item[4] != '1|1|1|1':
				var color = item[4].split('|', false)
				systems.display.layers[systems.display.getindex(item[0])]['node'].set_self_modulate(Color(color[0], color[1], color[2], color[3]))
			
			if i+1 == size: more = false
			else: i += 1
		
		if more and saveText[i] == 'faces': # If more content and that content is faces then load them.
			i+=1
			while saveText[i] != 'masks' and more:
				var face = saveText[i].split(',', false)
				if face.size() == 5:
					systems.display.face(face[0], face[1], int(face[2]), int(face[3]))
				
					if face[4] != '1|1|1|1':
						var color = face[4].split('|', false)
						systems.display.layers[systems.display.getindex(face[1])]['face'].set_self_modulate(Color(color[0], color[1], color[2], color[3]))
			
				else:
					systems.display.face(face[0], face[1], int(face[2]), int(face[3]), face[4])
				
					if face[5] != '1|1|1|1':
						var color = face[5].split('|', false)
						var layer = systems.display.layers[systems.display.getindex(face[1])]
						for AFL in layer['AFL']:
							if AFL.texture.resource_path == face[0]:
								AFL.set_self_modulate(Color(color[0], color[1], color[2], color[3]))
				
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
				
				if mask[5] != '1|1|1|1':
					var color = mask[5].split('|', false)
					systems.display.layers[systems.display.getindex(mask[0])]['node'].set_self_modulate(Color(color[0], color[1], color[2], color[3]))
			
				if i+1 == size: more = false
				else: i += 1
	
	
	# LOAD DIALOGUE
	var inChoice = false
	var choiceArray = []
	var chosenChoiceArray = []
	index -= 5
	
	if saveText[index] == 'True': inChoice = true
	
	index += 1
	
	if saveText[index] != 'NULL':
		var stringArray = saveText[index].split(',', true)
		for string in stringArray: choiceArray.append(string)
	
	index += 1
	
	if saveText[index] != 'NULL':
		var stringArray = saveText[index].split(',', true)
		for string in stringArray: chosenChoiceArray.append(string)
	
	index -= 4
	
	systems.dialogue(saveText[index], int(saveText[index+1]), choiceArray, inChoice, chosenChoiceArray)
	
	index -= 5;
	print(saveText[index])
	systems.blackScreen.set_self_modulate(Color(0,0,0,float(saveText[index])))
	
	# Allow the player to interact with the new scene.
	blockInput = false
	loadSaveFile = false
	game.safeToSave = true
	get_tree().paused = false