extends Node

#When we change major versions and saves become unsupported, change to like saves_v2 etc to ignore old ones
var SAVE_FOLDER = 'user://saves'
var SAVE_NAME_TEMPLATE = 'save%d.tres'
var SAVE_IMAGE_NAME_TEMPLATE = 'save%d.png'
var loadSaveFile = false
var blockInput = false
var safeToSave = false

var saveLock = false
	
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
		var par = global.dialogueBox.get_parent()
		if par != null: #????
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
	

	
