extends Node

# Variables to be used across all files.
var size
var windows = false
var rootnode
var master_volume = 1
var music_volume = 1
var sfx_volume = 1
var pause_input = false

# Set dynamic variables + do startup functions.
func _ready():
	
	size  = OS.get_screen_size() # Get the size of the screen.
	
	# Check if the os is windows.
	if OS.get_name() == 'Windows':
		windows = true
	
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
	
	# If no default screen size is set then set it to windowed.
	if settings.find('screen:', 0) == -1:
		file.open("user://usersettings.tres", File.READ_WRITE)
		file.store_line(settings + 'screen:windowed')
		settings = file.get_as_text()
		file.close()
	
	# Create the Music bus.
	AudioServer.add_bus(1) 
	AudioServer.set_bus_name(1, 'Music')
	AudioServer.set_bus_volume_db(1, log(master_volume * music_volume) * 20)
	# Create the SFX bus.
	AudioServer.add_bus(2)
	AudioServer.set_bus_name(2, 'SFX')
	AudioServer.set_bus_volume_db(2, log(master_volume * sfx_volume) * 20)