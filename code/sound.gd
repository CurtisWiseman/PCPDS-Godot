extends Node

var queue = [] # Queue of music to play.
var playing = {'path': "NULL", 'loop': "NULL", 'volume': "NULL"} # The current song.
var playingSFX = {'path': "NULL", 'volume': "NULL"} # The current sfx.

# Function to play music.
func music(path, loop=false, volume=0):
	
	var music = AudioStreamPlayer.new() # Create a new AudioSteamPlayer node.
	music.stream = load(path) # Set the steam to path.
	music.bus = 'Music' # Set the bus to Music.
	music.name = audioname(path) # Make the node name the audio name.
	music.volume_db = volume # Set the volume to volume.
	
	if loop: music.connect('finished', self, 'loop', [music]) # Loop the music if asked too.
	else: music.connect('finished', self, 'queuenext', [music]) # Else play next song in the queue.
	
	music.play() # Play the music.
	add_child(music) # Add as a child of sound.
	
	# Save the values of the currently playing music.
	playing.path = path
	playing.loop = loop
	playing.volume = volume



# Function to play sound effect.
func sfx(path, volume=0):
	
	var sfx = AudioStreamPlayer.new() # Create a new AudioSteamPlayer node.
	sfx.stream = load(path) # Set the steam to path.
	sfx.bus = 'SFX' # Set the bus to SFX.
	sfx.name = audioname(path) # Make the node name the audio name.
	sfx.volume_db = volume # Set the volume to volume.
	sfx.connect('finished', self, 'stop_SFX', [sfx]) # Delete the node when finished.
	sfx.play() # Play the sound effect.
	add_child(sfx) # Add as a child of sound.
	
	# Save the values of the currently playing sfx.
	playingSFX.path = path
	playingSFX.volume = volume



# Add music to the queue.
func queue(path, loop=false, volume=0):
	queue.append({'path': path, 'loop': loop, 'volume': volume}) # Append the dictionary to queue.



# Function to pause audio.
func pause(audio):
	if get_node(audio): get_node(audio).set_stream_paused(true)
	else: print('Error: No audio node named ' + audio + ' to pause.')



# Function to unpause audio.
func unpause(audio):
	if get_node(audio): get_node(audio).set_stream_paused(false)
	else: print('Error: No audio node named ' + audio + ' to unpause.')



# Function to remove the audio entirely.
func stop(audio):
	if get_node(audio):
		get_node(audio).queue_free()
		playing.path = "NULL"
		playing.loop = "NULL"
		playing.volume = "NULL"
	else:
		print('Error: No audio node named ' + audio + ' to stop.')



# Function to remove playing SFX.
func stop_SFX(audio):
	if get_node(audio):
		get_node(audio).queue_free()
		playingSFX.path = "NULL"
		playingSFX.volume = "NULL"
	else:
		print('Error: No audio node named ' + audio + ' to stop.')

# Get the name of the audio using path.
func audioname(path):
	var audioname = '' # Appended to to create a name.
	path = path.left(path.find_last('.')) # Remove the file extension.
	audioname = path.right(path.find_last('/')+1) # Use the fact that '/' cannot be in file names to find the name after the last slash.
	return audioname # Return the name.



# Play the next song in the queue.
func queuenext(audio=null):
	# Release the audio node.
	if audio != null:
		audio.queue_free()
		playing.path = "NULL"
		playing.loop = "NULL"
		playing.volume = "NULL"
	
	# If song is in the queue then play it.
	if queue.size() != 0:
		music(queue[0]['path'], queue[0]['loop'], queue[0]['volume'])
		queue.remove(0)



# Free's the audio node.
func end(audio):
	audio.queue_free()



# Audio loop function.
func loop(audio):
	audio.play()