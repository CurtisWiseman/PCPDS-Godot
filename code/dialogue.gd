extends RichTextLabel

var charMAX = 180
var longTextParts = []
var currentSubstring = 0
var currentLine = 0
var isCompartmentalized = false
var musicnode = null
var musicstop = false
var waitTimer = Timer.new()

signal has_been_read
signal substring_has_been_read
signal compartmentalise_text
signal finished_document
signal done

#	COLORS
#	Mage - #551A8B
#	Tom - #d23735
#	Ben - #8d8d8d
#	Digi - #b21069
#	Davoo - #408ff2
#	Jess - #fdf759
#	Munchy - #ff7ab9
#	Hippo - #78ffb5
#	Endless War - N/A

func _ready():
	self.connect("substring_has_been_read", self, "read_substring")
	self.connect("compartmentalise_text", self, "compartmentalise")
	self.connect("finished_document", self, "on_finished_document")
	self.connect('has_been_read', get_parent(), '_on_Dialogue_has_been_read')
	waitTimer.wait_time = 1
	waitTimer.one_shot = true
	waitTimer.autostart = false
	add_child(waitTimer)

func _input(event):
	
#	advance_text is a mapped action (2nd tab of project settings). this is done with remapping in mind
	if Input.is_action_just_pressed("advance_text") and !global.pause_input:
		
			if global.sliding:
				for child in get_node('../../../../Display').get_children():
					if child.name.match("*(*P*o*s*i*t*i*o*n*)*"):
						child.finish()
				global.sliding = false
			
			# Stop camera movment if it is moving
			if global.cameraMoving:
				var camera = global.rootnode.get_node('Systems/Camera')
				global.pause_input = true
				get_tree().paused = false
				camera.finishCameraMovment()
				yield(camera, 'camera_movment_finished')
				camera.zoom = camera.lastZoom
				camera.offset = camera.lastOffset
				get_tree().paused = true
				global.pause_input = false
			
			elif get_visible_characters() == get_total_character_count():
				# In middle of longer sentence - progress through sentence
				if currentSubstring < longTextParts.size(): 
					emit_signal("substring_has_been_read")
#				# At end of document - signal to do stuff
				elif (currentLine == get_parent().dialogue.size() - 1):
					emit_signal("finished_document")
				# Sentence is finished - load next line
				else:
					emit_signal("has_been_read")
					currentLine += 1
#			Finish sentence if still in progress
			else:
				set_visible_characters(get_total_character_count())
	
	elif Input.is_action_just_pressed("advance_text"):
		
		get_parent().emit_signal('mouse_click')

func _process(delta):
	if Input.is_action_just_pressed("ui_debug"):
		debug()
	pass


func say(text):
	set_visible_characters(0) # Remove current line
	
#	Compartmentalize long line into smaller strings
	if isCompartmentalized == false && text.length() >= charMAX:
		compartmentalise(text)
# 	Display new line if of appropriate length
	elif text != "":
		var music = AudioStreamPlayer.new() # Create a new AudioSteamPlayer node.
		music.stream = load("res://sounds/speech/pcp-blips_gibbontake.ogg") # Set the steam to path.
		music.bus = 'Music' # Set the bus to Music.
		music.volume_db = 0 # Set the volume to volume.
#		music.connect('finished', self, 'loop', [music]) # Loop the music if asked too.
		music.play()
		add_child(music)
		musicnode = music
		set_bbcode(text)
	else:
		set_bbcode(text)
	return text

func compartmentalise(longText):
	var sentenceCharIndex = 0 
	var sentenceLength = longText.length()
	var currentSentence

	# Empty array of substrings if unempty
	if longTextParts.empty() == false: 
		for n in range(longTextParts.size()):
			longTextParts.pop_back()

#	Progress through line if unfinished
	while sentenceCharIndex != sentenceLength:

#		difference between whole string and substring > charMAX
		if sentenceLength - sentenceCharIndex >= charMAX:
			currentSentence = longText.substr(sentenceCharIndex, charMAX)
			sentenceCharIndex += charMAX
			
			if currentSentence.find(' ', 0) != -1:
				# To make sure that next substring doesn't begin with a blank space
				while currentSentence.ends_with(" ") == false:
					currentSentence = currentSentence.substr(0, sentenceCharIndex - 1)
					sentenceCharIndex -= 1

#			Add substring to array
			longTextParts.push_back(currentSentence)

#		difference between whole string and substring < charMAX
		elif sentenceLength - sentenceCharIndex < charMAX && sentenceLength - sentenceCharIndex > 0:
			var temp = sentenceLength - sentenceCharIndex
			currentSentence = longText.substr(sentenceCharIndex, temp)
			sentenceCharIndex += temp
			longTextParts.push_back(currentSentence)

	currentSubstring = 0
#	Signal to display first substring
	emit_signal("substring_has_been_read")


# Function to "scroll text" (can't come up with the correct phrasing)
func _on_Timer_timeout():
	if get_visible_characters() < get_total_character_count():
		set_visible_characters(get_visible_characters()+1) 
	elif musicnode != null:
		musicstop = true
		var music = musicnode
		while music.volume_db > -100:
			music.volume_db -= 20
			if music.volume_db > -100: emit_signal("done");
			yield(get_tree().create_timer(0.1), "timeout")
		yield(self,"done")
		music.queue_free()
		musicnode = null

func read_substring():
	# Keep current line as compartmentalized until all substrings have been read
	isCompartmentalized = true
	say(longTextParts[currentSubstring])
	currentSubstring += 1

	# If at end of whole line, reset for next compartmentalization
	if currentSubstring == longTextParts.size():
		isCompartmentalized = false
	

func on_finished_document():
	print("Document is finished")

#Unused debug function
func debug():
	print("Beep, boop, fixing shitty code")