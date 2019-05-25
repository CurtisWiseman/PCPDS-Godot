extends Slider

signal master_change # Signal emiited when master volume changed.
signal music_change # Signal emiited when music volume changed.
signal sfx_change # Signal emiited when sfx volume changed.

var lastvalue = global.master_volume # Last value of master volume.
var musiclv = global.master_volume # Last value of music volume.
var sfxlv = global.sfx_volume # Last value of sfx volume.

var music # The music slider node.
var sfx # The sfx slider node.

var file = File.new() # For changing the user's volume settings.

# Ready the script with nodes, values, and signals.
func _ready():
	music = get_node('../Music') # Get the music node.
	sfx = get_node('../SFX') # Get the sfx node.
	
	# Set the slider values to the global volume levels.
	value = global.master_volume
	music.value = global.music_volume
	sfx.value = global.sfx_volume
	
	# Connect signals to their respective functions.
	connect('master_change', self, 'master_volume')
	connect('music_change', self, 'music_volume')
	connect('sfx_change', self, 'sfx_volume')



# Change the volume of both the music and sfx bus.
func master_volume():
	AudioServer.set_bus_volume_db(1, log(value * music.value) * 20)
	AudioServer.set_bus_volume_db(2, log(value * sfx.value) * 20)
	usersettings('master')



# Change the volume of the music bus.
func music_volume():
	AudioServer.set_bus_volume_db(1, log(value * music.value) * 30)
	usersettings('music')



# Change the volume of the sfx bus.
func sfx_volume():
	AudioServer.set_bus_volume_db(2, log(value * sfx.value) * 30)
	usersettings('sfx')



# Save the slider values to the user's settings.
func usersettings(volume):
	file.open("user://usersettings.tres", File.READ_WRITE) # Open the user's settings file.
	var settings = file.get_as_text() # Store the contents in settings.
	var newsettings # The new settings to append the new volume with.
	var val # The volume value to append.
	
	# Depending on the volume type remove it from the settings.
	# Then get the string value of the volume with 3 decimal places.
	# Store the new volume as a line at the end of the user settings.
	# Change the global volume variable for that volume type.
	if volume == 'master':
		newsettings = settingshelper(settings, settings.find('master_volume:', 0), 20)
		val = lengthhelper(value)
		file.store_line(newsettings + 'master_volume:' + val)
		global.master_volume = value
	
	elif volume == 'music':
		newsettings = settingshelper(settings, settings.find('music_volume', 0), 19)
		val = lengthhelper(music.value)
		file.store_string(newsettings + 'music_volume:' + val)
		global.music_volume = music.value
	
	elif volume == 'sfx':
		newsettings = settingshelper(settings, settings.find('sfx_volume:', 0), 17)
		val = lengthhelper(sfx.value)
		file.store_string(newsettings + 'sfx_volume:' + val)
		global.sfx_volume = sfx.value
	
	file.close() # Close the file.



# Helper function to remove old volume from settings.
func settingshelper(settings, index, offset):
	var newsettings = ''
	
	# Get settings before start of the old volume.
	for i in range(0, index):
		newsettings += settings[i]
	
	# Get settings after the end of the old volume.
	for i in range(index + offset, settings.length()):
		newsettings += settings[i]
	
	return newsettings # Return the new settings.



# Adds proper decimal places to volume before storing in settings.
func lengthhelper(x):
	var length = str(x).length()
	
	if length == 1: return str(x) + '.000'
	elif length == 3: return str(x) + '00'
	elif length == 4: return str(x) + '0'
	return str(x)



# Check whether or not to emit volume signal each frame.
func _process(delta):
	
	# Depending on the volume slider emit that volume type's signal
	# when the current volume doesn't mach the previous volume.
	if value != lastvalue:
		emit_signal('master_change')
		lastvalue = value
	
	if music.value != musiclv:
		emit_signal('music_change')
		musiclv = music.value
	
	if sfx.value != sfxlv:
		emit_signal('sfx_change')
		sfxlv = sfx.value