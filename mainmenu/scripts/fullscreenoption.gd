extends OptionButton

var lastselected # Variable to know what fullscreen option was last selected.
var usersettings = File.new() # Define usersettings as a File type.
var settings # usersettings as a string.
var systems # Define systems for use globally.

# Intialization.
func _ready():
	# Adds the fullscreen options
	add_item('Windowed', 0)
	add_item('Borderless', 1)
	add_item('Fullscreen', 2)
	
	systems = get_node('../../Systems') # Load systems with the Systems node.
	systems.window.screensetting() # Uses the user's default window size.
	
	usersettings.open("user://usersettings.tres", File.READ_WRITE) # Open the usersettings file for reading and writing.
	settings = usersettings.get_as_text() # Store the file as a string in settings variable.
	var screen = settings[settings.find('screen:', 0) + 7] # Find user's default screen setting.
	
	# Set their default to the current item.
	if screen == 'w':
		select(0)
		lastselected = 0
	elif screen == 'b':
		select(1)
		lastselected = 1
	elif screen == 'f':
		select(2)
		lastselected = 2
		
	usersettings.close() # Close user settings.
	

# Replaces the screen setting with the new screen setting.
func rewrite(scrset):
	usersettings.open("user://usersettings.tres", File.READ_WRITE) # Open the usersettings file for reading and writing.
	settings = usersettings.get_as_text() # Store the file as a string in settings variable.
	var start = settings.find('screen:', 0) # Get the starting point of 'screen:'
	var screen = settings[settings.find('screen:', 0) + 7] # Find user's default screen setting.
	usersettings.close() # Close user settings.
	
	# Remove usersettings.
	var dir = Directory.new()
	dir.remove("user://usersettings.tres")
	
	var newsettings = '' # New settings file.
	
	# Get settings before start of screen.
	for i in range(0, start):
		newsettings += settings[i]
	
	# Remove the current screen setting by skipping over it in newsettings.
	if screen == 'w':
		for i in range(start + 16, settings.length()):
			newsettings += settings[i]
	else:
		for i in range(start + 18, settings.length()):
			newsettings += settings[i]

	# Append the newsettings to usersettings.
	usersettings.open("user://usersettings.tres", File.WRITE) # Create the new settings file.
	usersettings.store_string(newsettings) # Store the settings with old screen option removed.
	usersettings.store_line('screen:' + scrset) # Store new screen option at the end of the file.
	usersettings.close() # Close user settings to finish.
	

# Runs each frame on the settings scene to detect when an option has been seletected.
func _process(delta):
	
	# If 0 is selected and was not selected last time then window the game.
	if selected == 0:
		if lastselected != 0:
			systems.window.windowed() # Make window windowed.
			rewrite('windowed') # Replace the default screen setting.
			lastselected = 0 # Set 0 as lastselected so it is not run again while selected is 0.
	
	# If 1 is selected and was not selected last time then borderless and maximize the game.
	elif selected == 1:
		if lastselected != 1:
			systems.window.borderless() # Make window borderless.
			rewrite('borderless') # Replace the default screen setting.
			lastselected = 1 # Set 1 as lastselected so it is not run again while selected is 1.
	
	# If 2 is selected and was not selected last time then fullscreen the game.
	elif selected == 2:
		if lastselected != 2:
			systems.window.fullscreen() # Make window fullscreen.
			rewrite('fullscreen') # Replace the default screen setting.
			lastselected = 2 # Set 2 as lastselected so it is not run again while selected is 2.