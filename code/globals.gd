extends Node

# Variables to be used across all files.
var size
var rootnode
var dialogueBox
var master_volume = 1
var music_volume = 1
var sfx_volume = 1
var pause_input = false
var loadedOnce = false
var sliding = false
var screenshotsTaken = 1
var defaultChoiceFontItalic
var defaultChoiceFontBold
var defaultChoiceFont
var defaultFontItalic
var defaultFontBold
var defaultFont
var textTheme

# Character Colors
var digibro = {'color': Color('b21069')}
var hippo = {'color': Color('78ffb5')}
var endlesswar = {'color': Color('ffff00')}
var mage = {'color': Color('551A8B')}
var munchy = {'color': Color('ff7ab9')}
var nate = {'color': Color('')}
var tom = {'color': Color('f00000')}

# Variable to reference character images.
var chr = load("res://code/char.gd").new()


# Set dynamic variables + do startup functions.
func _ready():
	
	OS.window_fullscreen = true # Force fullscreen resolution.
	
	
	size = OS.get_screen_size() # Get the size of the screen.
	
	
	chr._ready() #Load the character images.
	
	
	# If the usersettings file does not exist then create it.
	var file = File.new()
	var filepath = OS.get_user_data_dir() + '/usersettings.tres'
	if file.file_exists(filepath) == false:
		file.open("user://usersettings.tres", File.WRITE)
		file.close()
	
	# Get user settings and create those that don't exist.
	file.open("user://usersettings.tres", File.READ_WRITE)
	var settings = file.get_as_text()
	
	
	# Get the master volume or create it.
	if settings.find('master_volume:', 0) == -1:
		file.open("user://usersettings.tres", File.READ_WRITE)
		file.store_line(settings + 'master_volume:1.000')
		settings = file.get_as_text()
		file.close()
	else:
		master_volume = float(settings.substr(settings.find('master_volume:', 0) + 14, 5))
	
	# Get the music volume or create it.
	if settings.find('music_volume:', 0) == -1:
		file.open("user://usersettings.tres", File.READ_WRITE)
		file.store_line(settings + 'music_volume:1.000')
		settings = file.get_as_text()
		file.close()
	else:
		music_volume = float(settings.substr(settings.find('music_volume:', 0) + 13, 5))
	
	# Get the sfx volume or create it.
	if settings.find('sfx_volume:', 0) == -1:
		file.open("user://usersettings.tres", File.READ_WRITE)
		file.store_line(settings + 'sfx_volume:1.000')
		settings = file.get_as_text()
		file.close()
	else:
		sfx_volume = float(settings.substr(settings.find('sfx_volume:', 0) + 11, 5))
	
	
	# If the directory for screenshots doesn't exists create it.
	var directory = Directory.new()
	if !directory.dir_exists('user://screenshots'):
		directory.make_dir('user://screenshots')
	
	
	# Create the default fonts.
	var defaultFontDATA = DynamicFontData.new()
	defaultFontDATA.font_path = 'res://fonts/Dialogue/Lato-Regular.ttf'
	defaultFont= DynamicFont.new()
	defaultFont.font_data = defaultFontDATA
	defaultFont.size = 35
	var defaultFontDATABold = DynamicFontData.new()
	defaultFontDATABold.font_path = 'res://fonts/Dialogue/Lato-Bold.ttf'
	defaultFontBold = DynamicFont.new()
	defaultFontBold.font_data = defaultFontDATABold
	defaultFontBold.size = 35
	var defaultFontDATAItalic = DynamicFontData.new()
	defaultFontDATAItalic.font_path = 'res://fonts/Dialogue/Lato-Italic.ttf'
	defaultFontItalic = DynamicFont.new()
	defaultFontItalic.font_data = defaultFontDATAItalic
	defaultFontItalic.size = 35
	
	var defaultChoiceFontDATA = DynamicFontData.new()
	defaultChoiceFontDATA.font_path = 'res://fonts/Dialogue/Lato-Regular.ttf'
	defaultChoiceFont= DynamicFont.new()
	defaultChoiceFont.font_data = defaultChoiceFontDATA
	defaultChoiceFont.size = 25
	var defaultChoiceFontDATABold = DynamicFontData.new()
	defaultChoiceFontDATABold.font_path = 'res://fonts/Dialogue/Lato-Bold.ttf'
	defaultChoiceFontBold = DynamicFont.new()
	defaultChoiceFontBold.font_data = defaultChoiceFontDATABold
	defaultChoiceFontBold.size = 25
	var defaultChoiceFontDATAItalic = DynamicFontData.new()
	defaultChoiceFontDATAItalic.font_path = 'res://fonts/Dialogue/Lato-Italic.ttf'
	defaultChoiceFontItalic = DynamicFont.new()
	defaultChoiceFontItalic.font_data = defaultChoiceFontDATAItalic
	defaultChoiceFontItalic.size = 25
	
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