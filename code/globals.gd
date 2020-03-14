extends Node

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

func _pause_input_set(v):
	#slap a breakpoint on this if you want to debug pause-locking
	pause_input = v
	
# Set dynamic variables + do startup functions.
func _ready():
	
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
	var defaultFontDATABold = DynamicFontData.new()
	defaultFontDATABold.font_path = 'res://fonts/Dialogue/Roboto/Roboto-Bold.ttf'
	defaultFontBold = DynamicFont.new()
	defaultFontBold.font_data = defaultFontDATABold
	defaultFontBold.size = 35
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
	AudioServer.set_bus_volume_db(1, log(master_volume * music_volume) * 20)
	# Create the SFX bus.
	AudioServer.add_bus(2)
	AudioServer.set_bus_name(2, 'SFX')
	AudioServer.set_bus_volume_db(2, log(master_volume * sfx_volume) * 20)
	
	# Load the location images.
	locations = returnlocations()
	var locname = ''
	for location in locations:
		location = location.left(location.find_last('.')) # Remove the file extension.
		locname = location.right(location.find_last('/')+1) # Remove the leading folders.
		locationNames.append(locname)





# Function to retrieve all backgrounds into a locations array.
func returnlocations():
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
	var a = 0 if get_tree().paused else 1
	global.dialogueBox.set_self_modulate(Color(1,1,1,a))
	global.dialogueBox.get_node('Nametag').set_self_modulate(Color(1,1,1,a))
	global.dialogueBox.get_node('Dialogue').set_self_modulate(Color(1,1,1,a))
	
func save_settings():
	var config = ConfigFile.new()
	config.set_value("audio", "sfx", AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Sfx")))
	config.set_value("audio", "master", AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
	config.set_value("audio", "music", AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	config.set_value("audio", "voice", global.voicesOn)
	prints(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Sfx")), AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
	config.save("user://settings.cfg")
