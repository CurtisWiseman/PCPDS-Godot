extends Node

var SAVE_FOLDER = 'user://saves'
var NUM_OF_SAVES = 'numOfSaves.tres'
var SAVE_NAME_TEMPLATE = 'save%03d.tres'
var SAVE_IMAGE_NAME_TEMPLATE = 'save%03d.png'
var blockInput = false
var safeToSave = false

# Function to save the game using a .tres file
func save():
	
	if safeToSave:
		# Block everything while saving.
		get_tree().paused = true
		global.pause_input = true
		blockInput = true
		
		# Create the SAVE_FOLDER directory if it doesn't exist.
		var directory = Directory.new()
		var file = File.new()
		
		if !directory.dir_exists(SAVE_FOLDER):
			directory.make_dir(SAVE_FOLDER)
		
		# Get relevant system nodes.
		var sound = global.rootnode.get_node('Systems/Sound')
		var display = global.rootnode.get_node('Systems/Display')
		var dialogue = global.rootnode.get_node('Systems/Pause Canvas/Dialogue Canvas/Dialogue Box')
		var pauseScreen = global.rootnode.get_node('Systems/Pause Canvas/pause_screen')
		
		
		
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
		var lastSpoken = str(dialogue.lastSpoken)
		var inChoice = str(dialogue.lastInChoice)
		var choices = dialogue.lastChoices
		var chosenChoices = dialogue.lastChosenChoices
		
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
		
		if global.sliding: # Stop any sliding characters.
			get_tree().paused = false
			for child in display.get_children():
				if child.name.match("*(*P*o*s*i*t*i*o*n*)*"):
					child.finish()
			global.sliding = false
			get_tree().paused = true
		
		var displayChildren = []
		var displayFaces = []
		var displayMaskChildren = []
		if dialogue.lastLayers == []:
			displayChildren = "NULL"
		else:
			for layer in dialogue.lastLayers:
				if layer.has('mask'):
					if layer['type'] == 'image':
						displayMaskChildren.append('res://' + layer['mask'] + ',res://' + layer['path'] + ',' + 'image' + ',' + str(layer['layer']) + ',' + str(layer['position'].x) + "|" + str(layer['position'].y))
					elif layer['type'] == 'video':
						displayMaskChildren.append('res://' + layer['mask'] + ',res://' + layer['path'] + ',' + 'video' + ',' + str(layer['layer']) + ',' + str(layer['position'].x) + "|" + str(layer['position'].y))
				else:
					if layer['type'] == 'image':
						displayChildren.append('res://' + layer['path'] + ',' + 'image' + ',' + str(layer['layer']) + ',' + str(layer['position'].x) + "|" + str(layer['position'].y))
					elif layer['type'] == 'video':
						displayChildren.append('res://' + layer['path'] + ',' + 'video' + ',' + str(layer['layer']) + ',' + str(layer['position'].x) + "|" + str(layer['position'].y))
				
				if layer.has('face'):
					displayFaces.append('res://' + layer['face'].texture.resource_path + ',res://' + layer['path'] + ',' + str(layer['facepos'].x) + ',' + str(layer['facepos'].y))
				
				if layer.has('AFL'):
					for i in range(0, layer['AFL'].size()):
						displayFaces.append('res://' + layer['AFL'][i].texture.resource_path + ',res://' + layer['path'] + ',' + str(layer['AFL'][i].x) + ',' + str(layer['AFL'][i].y) + ',other')
		
		
		
		#WRITE THE SAVE FILE.
		var i = 1
		var savePath = "user://saves".plus_file('save%03d.tres' % i)
		while true:
			if !file.file_exists(savePath):
				break
			i += 1;
			savePath = "user://saves".plus_file('save%03d.tres' % i)
		
		file.open(savePath, File.WRITE)
		file.store_line(gameVersion)
		file.store_line(sceneName)
		file.store_line('-music-')
		file.store_line(musicPlaying)
		file.store_line(musicQueue)
		file.store_line('-dialogue-')
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
		
		
		
		# Return to the game.
		if pauseScreen.visible: pauseScreen.visible = false;
		get_tree().paused = false
		if !dialogue.displayingChoices: global.pause_input = false
		blockInput = false





# Function to load a specified save file.
func load(save):
	pass