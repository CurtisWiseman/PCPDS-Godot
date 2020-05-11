extends Node

const MAJOR_VERSION = 1
const MINOR_VERSION = 2

# Variables to be used across all files.
var size
var rootnode
var dialogueBox
var master_volume = 1
var music_volume = 1
var sfx_volume = 1
var pause_input setget _pause_input_set
var turbo_mode = false
var turbo_crash_mode = false
var loadedOnce = false
var fading = false
var sliding = false
var cameraMoving = false
var screenshotsTaken = 1
var defaultChoiceFontItalic
var defaultChoiceFontBold
var defaultChoiceFontBoldItalic
var defaultChoiceFont
var defaultFontItalic
var defaultFontBold
var defaultFontBoldItalic
var defaultFont
var textTheme
var playerName = "PlayerName"
var pauseScreen = null
var voicesOn = true
var current_scene_name = ""
var devmode = false

# Signal to say a that a scene is done loading.
signal finished_loading
signal finished_fading


# Character Colors
var digibro = {'color': Color('b21069')}
var hippo = {'color': Color('78ffb5')}
var endlesswar = {'color': Color('ffff00')}
var mage = {'color': Color('551A8B')}
var munchy = {'color': Color('ff7ab9')}
var nate = {'color': Color('')}
var tom = {'color': Color('f00000')}

# location data
var locations = []
var locationNames = []

#hacked in very quick for loading custom scripts for mods
var destination_script = null

var mod_characters_textboxes = {}
var mod_characters_afl = {}
var mod_name = ""
var mod_characters_voices = {}

var mod_load_error = null

var character
func _pause_input_set(v):
	#slap a breakpoint on this if you want to debug pause-locking
	pause_input = v
	
# Set dynamic variables + do startup functions.
func _ready():
	
	#Load mod content
	
	#Most mod content just works seemlessly in various loading contexts.
	#Here's some exceptions: 
	#load all characterImages, 
	#load textbox information for those characters
	#load AFL information
	#load the mod name
	
	var mod_json_file = File.new()
	if mod_json_file.file_exists("res://mod/mod.json"):
		mod_json_file.open("res://mod/mod.json", File.READ)
		var mod_json = mod_json_file.get_as_text()
		var mod_info = parse_json(mod_json)
		mod_name = mod_info["name"].left(100).strip_edges()
		
		var version_chunks = mod_info["version_req"].split(".")
		
		var version_fine = false
		
		if version_chunks.size() > 1:
			var major = version_chunks[0].to_int()
			var minor = version_chunks[1].to_int()
			
			if major > MAJOR_VERSION or (major == MAJOR_VERSION and minor >= MINOR_VERSION):
				version_fine = true
				
		if not version_fine:
			mod_load_error = "Failed to load mod: Bad PCPDS Version"
			
		if mod_name != "" and version_fine:
			game.SAVE_FOLDER += "/" + mod_name
		
			var dir = Directory.new()
			dir.open("mod/chars/")
			dir.list_dir_begin()
		
			while true:
				var def = dir.get_next()
				
				if def != "" :
					if !dir.dir_exists(def) and def.findn('.json') != -1:
						var def_file = "mod/chars/" + def
						var file = File.new()
						file.open(def_file, File.READ)
						var content = file.get_as_text()
						var char_def = parse_json(content)
						var char_id = char_def["char_id"].to_lower()
						
						
						var bad = false
						if detect_forbidden_mod_contents(char_id):
							prints("ERROR: CHARACTER " + char_id + " USED FORBIDDEN TEXT IN IT'S NAME'")
							bad = true
							
						for cur in char_def["imgs"]["body"]:
							var last_chunk = cur.substr(cur.find_last("/")+1)
							if not last_chunk.begins_with(char_id):
								prints("ERROR: CHARACTER " + char_id  +" HAD A BODY THAT DID NOT START WITH THE LOWER CASE CHARID!", last_chunk)
								bad = true
						
						var search_space = [char_def["imgs"]]
						while search_space.size() > 0:
							var cur = search_space.pop_front()
							var cur_type = typeof(cur)
							
							if cur_type == TYPE_ARRAY:
								for v in cur:
									search_space.append(v)
							elif cur_type == TYPE_DICTIONARY:
								for v in cur.values():
									search_space.append(v)
							elif cur_type == TYPE_STRING:
								if detect_forbidden_mod_contents(cur):
									prints("ERROR: FORBIDDEN TEXT IN IMAGE PATH:", cur)
									bad = true
									
						if not bad:
							characterImages.imgs[char_id] = char_def["imgs"]
							mod_characters_textboxes[char_id] = char_def["text_box"]
							mod_characters_afl[char_id] = char_def["imgs"].get("afl", {})
							mod_characters_voices[char_id] = char_def.get("voice", null)
				else:
					break
			
	OS.window_fullscreen = true # Force fullscreen resolution.
	
	size = OS.get_screen_size() # Get the size of the screen.
	
	# If the directory for screenshots doesn't exists create it.
	var directory = Directory.new()
	if !directory.dir_exists('user://screenshots'):
		directory.make_dir('user://screenshots')
	
	# If the directory for scenes doesn't exists create it.
	if !directory.dir_exists('user://scenes'):
		directory.make_dir('user://scenes')
	
	# Create the default fonts.
	var defaultFontDATA = DynamicFontData.new()
	defaultFontDATA.font_path = 'res://fonts/Dialogue/Roboto/Roboto-Regular.ttf'
	defaultFont= DynamicFont.new()
	defaultFont.font_data = defaultFontDATA
	defaultFont.size = 35
	
	#Added for Kanji
	var defaultFallbackFontDATA = DynamicFontData.new()
	defaultFallbackFontDATA.font_path = 'res://fonts/Dialogue/NotoSans/NotoSansJP-Regular.otf'
	defaultFont.add_fallback(defaultFallbackFontDATA)
	
	var defaultFontDATABold = DynamicFontData.new()
	defaultFontDATABold.font_path = 'res://fonts/Dialogue/Roboto/Roboto-Bold.ttf'
	defaultFontBold = DynamicFont.new()
	defaultFontBold.font_data = defaultFontDATABold
	defaultFontBold.size = 35
	
	#Added for Kanji
	var defaultFallbackBoldFontDATA = DynamicFontData.new()
	defaultFallbackBoldFontDATA.font_path = 'res://fonts/Dialogue/NotoSans/NotoSansJP-Bold.otf'
	defaultFontBold.add_fallback(defaultFallbackBoldFontDATA)
	
	var defaultFontDATAItalic = DynamicFontData.new()
	defaultFontDATAItalic.font_path = 'res://fonts/Dialogue/Roboto/Roboto-Italic.ttf'
	defaultFontItalic = DynamicFont.new()
	defaultFontItalic.font_data = defaultFontDATAItalic
	defaultFontItalic.size = 35
	var defaultFontDATABoldItalic = DynamicFontData.new()
	defaultFontDATABoldItalic.font_path = 'res://fonts/Dialogue/Roboto/Roboto-BoldItalic.ttf'
	defaultFontBoldItalic = DynamicFont.new()
	defaultFontBoldItalic.font_data = defaultFontDATABoldItalic
	defaultFontBoldItalic.size = 35
	
	var defaultChoiceFontDATA = DynamicFontData.new()
	defaultChoiceFontDATA.font_path = 'res://fonts/Dialogue/Roboto/Roboto-Regular.ttf'
	defaultChoiceFont= DynamicFont.new()
	defaultChoiceFont.font_data = defaultChoiceFontDATA
	defaultChoiceFont.size = 25
	
	var defaultChoiceFontDATABold = DynamicFontData.new()
	defaultChoiceFontDATABold.font_path = 'res://fonts/Dialogue/Roboto/Roboto-Bold.ttf'
	defaultChoiceFontBold = DynamicFont.new()
	defaultChoiceFontBold.font_data = defaultChoiceFontDATABold
	defaultChoiceFontBold.size = 25
	var defaultChoiceFontDATAItalic = DynamicFontData.new()
	defaultChoiceFontDATAItalic.font_path = 'res://fonts/Dialogue/Roboto/Roboto-Italic.ttf'
	defaultChoiceFontItalic = DynamicFont.new()
	defaultChoiceFontItalic.font_data = defaultChoiceFontDATAItalic
	defaultChoiceFontItalic.size = 25
	var defaultChoiceFontDATABoldItalic = DynamicFontData.new()
	defaultChoiceFontDATABoldItalic.font_path = 'res://fonts/Dialogue/Roboto/Roboto-BoldItalic.ttf'
	defaultChoiceFontBoldItalic = DynamicFont.new()
	defaultChoiceFontBoldItalic.font_data = defaultChoiceFontDATABoldItalic
	defaultChoiceFontBoldItalic.size = 25
	
	textTheme = Theme.new()
	textTheme.set_color('font_color_shadow', 'RichTextLabel', Color(0.4, 0.4, 0.4, 1))
	
	
	# Create the Music bus.
	AudioServer.add_bus(1) 
	AudioServer.set_bus_name(1, 'Music')
	#AudioServer.set_bus_volume_db(1, log(master_volume * music_volume) * 20)
	# Create the SFX bus.
	AudioServer.add_bus(2)
	AudioServer.set_bus_name(2, 'SFX')
	#AudioServer.set_bus_volume_db(2, log(master_volume * sfx_volume) * 20)
	
	# Load the location images.
	locations = returnlocations()
	var locname = ''
	for location in locations:
		location = location.left(location.find_last('.')) # Remove the file extension.
		locname = location.right(location.find_last('/')+1) # Remove the leading folders.
		locationNames.append(locname)





# Function to retrieve all backgrounds into a locations array.
func returnlocations():
	#
	# THIS METHOD IS POINTLESS BECAUSE THESE FILES DON'T EXIST DURING AN EXPORTED PROJECT
	#
	# Make the directory path of a characters folder.
	var directory = 'images/backgrounds/'
	
	# A list to retrun and a variable to manage the while loop.
	var files = []
	var file
	
	# Open the directory as dir
	var dir = Directory.new()
	dir.open(directory)
	dir.list_dir_begin(true)
	
	# Until the end of the directory is reached appends to files.
	while true:
		# Get the next file in the directory.
		file = dir.get_next()
		
		# If file exists then append it to files, else break.
		if file != "" :
			if !dir.dir_exists(file) and file.findn('import') == -1:
				files.append('res://' + directory + '/' + file)
		else:
			break
		
	# Sort files, close the directory, and return files.
	files.sort()
	dir.list_dir_end()
	return files


# Handle screenshot event.
func _input(event):
	
	if event.is_action_pressed("screenshot") and !game.blockInput:
		
		# Pause the game then take and save a screenshot.
		get_tree().paused = not get_tree().paused
		var image = get_viewport().get_texture().get_data()
		image.flip_y()
		
		var file = File.new() # Find an unused file name.
		var imagePath = "user://screenshots".plus_file('screenshot_%d.png' % screenshotsTaken)
		while true:
			if !file.file_exists(imagePath):
				break
			screenshotsTaken += 1
			imagePath = "user://screenshots".plus_file('screenshot_%d.png' % screenshotsTaken)
		
		image.save_png(imagePath)
		get_tree().paused = not get_tree().paused



# Function to let game know fading is finished.
func finish_fading():
	fading = false
	emit_signal('finished_fading')
	
#Sometimes the node is a videopalyer which use rect_position?
func get_node_pos(given_node):
	var pos
	if given_node is VideoPlayer:
		pos = given_node.rect_position
	else:
		pos = given_node.position
	return pos
	
func set_node_pos(given_node, pos):
	if given_node is VideoPlayer:
		given_node.rect_position = pos
	else:
		given_node.position = pos

func toggle_pause():
	get_tree().paused = not get_tree().paused
	#I don't know why this was ever a thing?
	#var a = 0 if get_tree().paused else 1
	#if global.dialogueBox != null:
	#	global.dialogueBox.set_self_modulate(Color(1,1,1,a))
	#	global.dialogueBox.get_node('Nametag').set_self_modulate(Color(1,1,1,a))
	#	global.dialogueBox.get_node('Dialogue').set_self_modulate(Color(1,1,1,a))
	
func save_settings():
	var config = ConfigFile.new()
	config.set_value("audio", "sfx", AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))
	config.set_value("audio", "master", AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
	config.set_value("audio", "music", AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	config.set_value("audio", "voice", global.voicesOn)
	config.set_value("misc", "dev", global.devmode)
	config.save("user://settings.cfg")

#quick hack for mod support
func get_content_path(path) -> String:
	var trimmed = path
	if trimmed.begins_with("res://"):
		trimmed = trimmed.substr(6)
	if trimmed.begins_with("mod/"):
		return trimmed
	var file = File.new()
	if file.file_exists("mod/" + trimmed):
		return "mod/" + trimmed
	return "res://" + trimmed


func detect_forbidden_mod_contents(string) -> bool:
	var forbidden = ['\n', '(', ')', '[', ']', ':', '"', '\'', ',', ';']
	for f in forbidden:
		if string.find(f) > -1:
			return true
	return false

#This exists to get around issues with loading mod contents
#basically, load() only loads imported resources, anything else we gotta go through the LONG way
#In order to avoid redundant loads (I have no idea how good this thing is at caching non-resources)
#any mod stuff loaded goes into this map:
var mod_content_cache = {}

func load_content(path: String):
	if path.begins_with("mod/"):
		var res = null
		
		if mod_content_cache.has(path):
			var cached = mod_content_cache[path]
			res = cached.get_ref()
			
		if res == null:
			if path.ends_with(".png"):
				var img = Image.new()
				var err = img.load(path)
				if err == OK:
					res = ImageTexture.new()
					res.create_from_image(img)
			elif path.ends_with(".ogv"):
				res = VideoStreamTheora.new()
				res.set_file(path)
				return res
			elif path.ends_with(".ogg"):
				var ogg_file = File.new()
				ogg_file.open(path, File.READ)
				var bytes = ogg_file.get_buffer(ogg_file.get_len())
				res = AudioStreamOGGVorbis.new()
				res.data = bytes
			
		mod_content_cache[path] = weakref(res)
			
		return res
	else:
		return load(path)
