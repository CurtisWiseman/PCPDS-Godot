extends Node

#When we change major versions and saves become unsupported, change to like saves_v2 etc to ignore old ones
var SAVE_FOLDER = 'user://saves'
var SAVE_NAME_TEMPLATE = 'save%d.tres'
var SAVE_IMAGE_NAME_TEMPLATE = 'save%d.png'
var loadSaveFile = false
var blockInput = false
var safeToSave = false

var saveLock = false

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
	var lastCG = dialogue.lastCG
	
	if lastCG == null:
		lastCG = "NULL"
	
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
						layer['node'].position.x = node['dest']
			
			var modulate = str(layer['node'].self_modulate)
			modulate = ',' + modulate.replace(',', '|')
			
			if layer.has('mask'):
				if layer['type'] == 'image':
					displayMaskChildren.append(layer['mask'] + ',' + layer['path'] + ',' + 'image' + ',' + str(layer['layer']) + ',' + str(layer['node'].position.x) + "|" + str(layer['node'].position.y) + modulate)
				elif layer['type'] == 'video':
					displayMaskChildren.append(layer['mask'] + ',' + layer['path'] + ',' + 'video' + ',' + str(layer['layer']) + ',' + str(layer['node'].position.x) + "|" + str(layer['node'].position.y) + modulate)
			else:
				if layer['type'] == 'image':
					displayChildren.append(layer['path'] + ',' + 'image' + ',' + str(layer['layer']) + ',' + str(layer['node'].position.x) + "|" + str(layer['node'].position.y) + modulate)
				elif layer['type'] == 'video':
					displayChildren.append(layer['path'] + ',' + 'video' + ',' + str(layer['layer']) + ',' + str(layer['node'].position.x) + "|" + str(layer['node'].position.y) + modulate)
				
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
	file.store_line(lastCG)
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
	index += 1
	
	# LOAD CG
	var CG = null
	if saveText[index] != 'NULL':
		CG = saveText[index]
	
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
	
	systems.dialogue(saveText[index], int(saveText[index+1]), choiceArray, inChoice, chosenChoiceArray, CG)
	
	index -= 5;
	print(saveText[index])
	systems.blackScreen.set_self_modulate(Color(0,0,0,float(saveText[index])))
	
	# Allow the player to interact with the new scene.
	blockInput = false
	loadSaveFile = false
	game.safeToSave = true
	get_tree().paused = false
	
func newSave(save_num):
	if saveLock:
		return
	saveLock = true
	# Create the SAVE_FOLDER directory if it doesn't exist.
	var directory = Directory.new()
	var file = File.new()
	
	if !directory.dir_exists(SAVE_FOLDER):
		directory.make_dir(SAVE_FOLDER)
		
	# Get relevant system nodes.
	var systems = global.rootnode.get_node('Systems')
	var sound = global.rootnode.get_node('Systems/Sound')
	var camera = global.rootnode.get_node('Systems/Camera')
	var display = global.rootnode.get_node('Systems/Display')
	var dialogue_box = global.rootnode.get_node('Systems/Pause Canvas/Dialogue Canvas/Dialogue Box')
	var dialogue = dialogue_box.get_node("Dialogue")
	
	var sliders_lookup = {}
	for child in display.get_children():
		if child.name.match("*(*P*o*s*i*t*i*o*n*)*"):
			sliders_lookup[child.node] = child.destination
	
	var data_payload = {}
	data_payload["scene"] = scene.cur_scene
	# Take a screenshot to use on the load screen.
	var image = get_viewport().get_texture().get_data()
	image.flip_y()
	image.save_png(SAVE_FOLDER.plus_file(SAVE_IMAGE_NAME_TEMPLATE % save_num))
	
	data_payload["playername"] = global.playerName
	#Use this in the future if you need to handle supporting older save formats
	data_payload["save_minor_version"] = 1
	
	data_payload["current_scene_name"] = global.current_scene_name
	
	data_payload["is_black"] = dialogue_box.last_black_fade_dir == 0
	
	#Display
	var layer_details = []
	for l in display.layers:
		#Don't save one's that are just being deleted
		if l.get("removing", false):
			continue
		var AFL = []
		if l.has("face"):
			var p = [l["facepos"].x, l["facepos"].y]
			AFL.append({"path": l["face"].texture.resource_path, "type": "face", "position": p})
		for afl in l.get("AFL", []):
			var p = [afl["position"].x, afl["position"].y]
			AFL.append({"path": afl["path"], "type": afl["type"], "position": p})	
			
		var modulate = display.fader_targets.get(l["node"], l["node"].self_modulate)
		var p = global.get_node_pos(l["node"])
		p.x = sliders_lookup.get(l["node"], p.x)
		var v = {"type": l["type"], "AFL": AFL, "modulate": modulate.to_html(), "position": [p.x, p.y], "z": l["layer"]}
		match l["type"]:
			"video":
				v["path"] = l["node"].stream.resource_path
				v["stream_pos"] = l["node"].stream_position
			"image":
				v["path"] = l["node"].texture.resource_path
		
		if l.has("mask"):
			v["mask"] = l["mask"]
		if l.has("still"):
			v["still"] = l["still"]
		layer_details.append(v)
		
	data_payload["layers"] = layer_details
	if display.bgtype != null and display.bgnode is Node2D:
		data_payload["bg"] = {"type": "image", "path": display.bgnode.get_node("gfx").texture.resource_path}
	elif display.bgtype != null and display.bgnode is VideoPlayer:
		data_payload["bg"] = {"type": "video", "path": display.bgnode.stream.resource_path, "stream_pos": display.bgnode.stream_position}
	
	#Camera
	data_payload["zoom"] = [camera.zoom.x, camera.zoom.y]
	data_payload["offset"] = [camera.offset.x, camera.offset.y]
	
	#Dialogue box
	data_payload["seen_choices"] = dialogue_box.choices
	data_payload["current_choices"] = dialogue_box.displayChoices
	data_payload["chosen_choices"] = dialogue_box.chosenChoices
	data_payload["text"] = dialogue.text
	data_payload["dialogue_index"] = dialogue_box.index
	data_payload["dialogue_script"] = dialogue_box.dialogueScript
	data_payload["cg"] = dialogue_box.CG
	data_payload["in_choice"] = dialogue_box.inChoice
	data_payload["overlays"] = dialogue_box.overlays
	#The name of this is very weird, it relates to character positions I think?
	var notsame = dialogue_box.notsame
	if notsame != null:
		notsame = notsame.duplicate()
		if notsame[1] != null and notsame[1] is Vector2:
			notsame[1] = [notsame[1].x, notsame[1].y]
		else:
			notsame[1] = null
	data_payload["notsame"] = notsame
	
	data_payload["current_name_tag"] = dialogue_box.get_node("Nametag").text
	data_payload["current_text_character"] = systems.textBoxBackground.current_char
	data_payload["current_voice_character"] = systems.textBoxBackground.current_voice
	
	#Sound
	data_payload["sfx"] = []
	data_payload["music"] = []
	for sfx in sound.playingSFX:
		var new_val = sfx.duplicate()
		var sfx_node = new_val["node"]
		new_val.erase("node")
		if sfx_node != null and sfx_node is AudioStreamPlayer:
			new_val["position"] = sfx_node.get_playback_position()
		data_payload["sfx"].append(new_val)
	for music in sound.playing:
		var new_val = music.duplicate()
		var music_node = new_val["node"]
		new_val.erase("node")
		if music_node != null and music_node is AudioStreamPlayer:
			new_val["position"]= music_node.get_playback_position()
		data_payload["music"].append(new_val)
		
	var save_path = SAVE_FOLDER.plus_file(SAVE_NAME_TEMPLATE % save_num)
	file.open(save_path, File.WRITE)#, 'G@Y&D3@D')
	file.store_line(to_json(data_payload))
	file.close()
	
	saveLock = false
	
func newLoad(save_file):
	if game.loadSaveFile:
		return
	game.loadSaveFile = true
	if global.dialogueBox != null and is_instance_valid(global.dialogueBox):
		global.dialogueBox.get_parent().remove_child(global.dialogueBox)
		global.dialogueBox.queue_free()
	
	var save_path = SAVE_FOLDER.plus_file(save_file)
	var file = File.new()
	file.open(save_path, File.READ)#, 'G@Y&D3@D')
	var save_text = file.get_as_text().strip_edges()
	file.close()
	
	var data_payload = parse_json(save_text)
	
	var systems = global.rootnode.get_node('Systems')
	var sound = systems.get_node('Sound')
	var camera = systems.get_node('Camera')
	var display = systems.get_node('Display')
	
	for c in sound.get_children():
		c.queue_free()
		
	systems.remove_child(display)
	if display.animation != null:
		display.animation.queue_free()
	display.queue_free()
	scene.change(data_payload["scene"])
	yield(scene, "scene_changed")
	systems = global.rootnode.get_node('Systems')
	sound = systems.get_node('Sound')
	camera = systems.get_node('Camera')
	
	display = systems.get_node('Display')
	
	global.playerName = data_payload["playername"]
	global.current_scene_name = data_payload["current_scene_name"]
	
	#Display
	var layers_by_z = {}
	
	for l in data_payload["layers"]:
		var group = layers_by_z.get(l["z"], [])
		#Due to the order targetting, layers added later end up earlier, so to recreate
		#the order, I use push_front
		group.push_front(l)
		layers_by_z[l["z"]] = group
		
	var layers_ordered = []
	var all_zs = layers_by_z.keys()
	all_zs.sort()
	for z in all_zs:
		for l in layers_by_z[z]:
			layers_ordered.append(l)
	
	for l in layers_ordered:
		#if data_payload.has("z"):
		#	cur_z = data_payload
		var z = int(l["z"])
		if l.has("mask"):
			display.mask(l["mask"], l["path"], l["still"], l["type"], z)
		elif l["type"] == "video":
			display.video(l["path"], z)
		else:
			display.image(l["path"], z)
		if l.has("stream_pos"):
			for other_l in display.layers:
				if other_l["name"] == display.getname(l["path"]) and l["node"] is VideoPlayer:
					l["node"].stream_position = l["stream_pos"]
					break
		for afl in l["AFL"]:
			display.face(afl["path"], l["path"], afl["position"][0], afl["position"][1], afl["type"])
			
		display.fade(l["path"], Color(l["modulate"]), Color(l["modulate"]), 0.0)
		display.position(l["path"], int(l["position"][0]), int(l["position"][1]))
		z += 1
	if data_payload.has("bg"):
		display.background(data_payload["bg"]["path"], data_payload["bg"]["type"])
		
	#Camera
	camera.zoom = Vector2(data_payload["zoom"][0], data_payload["zoom"][1])
	camera.offset = Vector2(data_payload["offset"][0], data_payload["offset"][1])
	
	#Dialogue box
	systems.dialogue(data_payload["dialogue_script"], data_payload["dialogue_index"], data_payload["seen_choices"], data_payload["in_choice"], data_payload["chosen_choices"], data_payload["cg"])
	
	var dialogue_box = global.rootnode.get_node('Systems/Pause Canvas/Dialogue Canvas/Dialogue Box')
	dialogue_box.notsame = data_payload.get("notsame", null)
	if dialogue_box.notsame != null and dialogue_box.notsame[1] != null:
		dialogue_box.notsame[1] = Vector2(dialogue_box.notsame[1][0], dialogue_box.notsame[1][1])
		
	dialogue_box.get_node("Dialogue").text = data_payload["text"]
	dialogue_box.get_node("Dialogue").visible_characters = data_payload["text"].length()
	dialogue_box.numOfChoices = data_payload["current_choices"].size()
	if data_payload["current_choices"].size() > 0:
		dialogue_box.displayChoices = data_payload["current_choices"]
		dialogue_box.display_cur_choices()
		dialogue_box.displayingChoices = dialogue_box.displayChoices.size() > 0
	
	dialogue_box.overlays = data_payload["overlays"]
	dialogue_box.get_node("Nametag").text = data_payload["current_name_tag"]
	systems.textBoxBackground.swap_character(data_payload["current_text_character"], data_payload["current_voice_character"])
	systems.textBoxBackground.make_visible()
	
	#Sounds
	if data_payload.has("sfx"):
		for sfx in data_payload["sfx"]:
			var n = sound.sfx(sfx["path"], sfx["volume"])
			n.seek(sfx["position"])
	if data_payload.has("music"):
		for music in data_payload["music"]:
			var n = sound.music(music["path"], music["loop"], music["volume"])
			n.seek(music["position"])
			
	if data_payload.get("is_black", false):
		systems.blackScreen.set_self_modulate(Color(1,1,1,1))
	global.pause_input = false
	global.fading = false
	global.sliding = false
	game.loadSaveFile = false
	

	
