extends Node

# Variables to be used across all files.
var size = Vector2(1024,600)

# Set dynamic variables + do startup functions.
func _ready():
	
	# If the usersettings file does not exist then create it.
	var file = File.new()
	var filepath = OS.get_user_data_dir() + '/usersettings.tres'
	if file.file_exists(filepath) == false:
		file.open("user://usersettings.tres", File.WRITE)