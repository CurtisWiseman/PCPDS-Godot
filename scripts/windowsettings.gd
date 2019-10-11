extends Node

var usersettings = File.new() # Define settings as a File type.
var settings # usersettings as a string.


# Makes the game windowed, centered, and of size global.size.
func windowed():
	OS.window_maximized = false # Unmaximize the window.
	OS.window_fullscreen = false # Make sure the window is not fullscreened.
	OS.window_borderless = false # Make sure the window is not borderless.
	OS.window_size = Vector2(global.size.x, global.size.y - 35) # Set window size to the globally defined size.
	OS.center_window()


# Makes the game borderless fullscreen.
func borderless():
	OS.window_fullscreen = false # Make sure the window is not fullscreened.
	OS.window_borderless = true # Make the window borderless
	
	if global.windows:
		# Check if a message needs to be shown.
		var file = File.new()
		file.open("user://usersettings.tres", File.READ_WRITE)
		var settings = file.get_as_text()
		if settings.find('winBM: seen', 0) == -1:
			file.store_line(settings + 'winBM: seen')
			get_parent().winBM()
		
		OS.window_size = Vector2(global.size.x, global.size.y - 1) # Make the window almost the size of the screen.
	else:
		OS.window_size = global.size # Make window the size of the screen.
		
	OS.center_window()


# Makes the game fullscreen.
func fullscreen():
	OS.window_maximized = false  # Unmaximize the window.
	OS.window_borderless = false # Make sure the window is not borderless.
	OS.window_fullscreen = true # Make the window fullscreen.


# Change the fullscreen setting to the default user setting.
func screensetting():
	usersettings.open("user://usersettings.tres", File.READ_WRITE) # Open the usersettings file for reading and writing.
	settings = usersettings.get_as_text() # Store the file as a string in settings variable.
	usersettings.close() # Close user settings.
	
	var screen = settings[settings.find('screen:', 0) + 7] # Set screen to the letter after 'screen:' in usersettings.

	# Call the corresponding function to whatever the user's default screen setting is.
	if screen == 'w':
		windowed()
		return
	elif screen == 'b':
		borderless()
		return
	elif screen == 'f':
		fullscreen()
		return