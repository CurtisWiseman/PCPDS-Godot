extends RichTextLabel

var charMAX = 180
var longTextParts = []
var currentSubstring = 0
var currentLine = 0
var isCompartmentalized = false
var speech
var once = 0
var waitTimer = Timer.new()

signal has_been_read
signal substring_has_been_read
signal compartmentalise_text
signal finished_document
signal speech_done

var turbo_timer = 0.1

var lock = false

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
		advance_text()
	elif Input.is_action_just_pressed("advance_text"):
		get_parent().emit_signal('mouse_click')
		
		
func finish_fades_and_slides():
	var display = get_node('../../../../Display')
	global.finish_fading()
	if display.faders.size() > 0:
		lock = false
		return
		
	if global.sliding:
		for child in display.get_children():
			if child.name.match("*(*P*o*s*i*t*i*o*n*)*"):
				child.finish()
		global.sliding = false
		
func advance_text():
	if lock:
		return
	lock = true
	finish_fades_and_slides()
	
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
		if speech != null:
			speech.queue_free()
			speech = null
		
		# In middle of longer sentence - progress through sentence
		if currentSubstring < longTextParts.size(): 
			emit_signal("substring_has_been_read")
#				# At end of document - signal to do stuff
		elif (currentLine == get_parent().dialogue.size() - 1):
			emit_signal("finished_document")
		# Sentence is finished - load next line
		else:
			get_parent()._on_Dialogue_has_been_read()
			currentLine += 1
#			Finish sentence if still in progress
	else:
		set_visible_characters(get_total_character_count())
	lock = false
	
func _process(delta):
	var turbo = false
	if global.turbo_mode:
		if turbo_timer < 0.0:
			turbo = true
			turbo_timer = 0.03
		turbo_timer -= delta
		
	if turbo:
		if global.pause_input:
			get_parent().emit_signal('mouse_click')
		else:
			advance_text()
		
	if visible_characters >= get_total_character_count():
		if not global.pause_input:
			get_node("../text_box/indicator").finished()
		else:
			get_node("../text_box/indicator").speaking()
		get_node("../text_box").voice_off()
	else:
		get_node("../text_box/indicator").speaking()
		var curchar = text.substr(get_visible_characters()-1, get_visible_characters())
		if curchar.strip_edges() != "":
			get_node("../text_box").voice_on()
		else:
			get_node("../text_box").voice_off()
			
	if Input.is_action_just_pressed("ui_debug"):
		debug()
	if Input.is_action_just_released("force_unpause"):
		print("Input pause forcibly broken out of!")
		global.pause_input = false
	global.turbo_mode = Input.is_key_pressed(KEY_S)
	#global.turbo_crash_mode = Input.is_key_pressed(KEY_P) #Dev testing purposes only 
		

func say(text, voice=null):
	text = text.strip_edges()
	set_visible_characters(0) # Remove current line
	
#	Compartmentalize long line into smaller strings
	if isCompartmentalized == false && text.length() >= charMAX:
		compartmentalise(text)
# 	Display new line if of appropriate length
	elif text != "" and voice != null:
		#speech = AudioStreamPlayer.new()
		#speech.stream = load("res://sounds/speech/pcp-voice_brunswick.ogg")
		#speech.bus = 'SFX'
		#speech.volume_db = 0
		#speech.play()
		#add_child(speech)
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
				var tempMAX = charMAX
				while currentSentence.ends_with(' ') == false:
					currentSentence = currentSentence.substr(0, tempMAX - 1)
					tempMAX -= 1
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
	elif speech != null and not (get_visible_characters() == 0 and get_total_character_count() == 0):
		speech.queue_free()
		speech = null

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
