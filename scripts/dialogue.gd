extends RichTextLabel

var charMAX = 285
var longTextParts = []
var currentSubstring = 0
var currentLine = 0
var isCompartmentalized = false

signal has_been_read
signal substring_has_been_read
signal compartmentalise_text
signal finished_document

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

func _input(event):
	
#	advance_text is a mapped action (2nd tab of project settings). this is done with remapping in mind
	if Input.is_action_just_pressed("advance_text"):
			if get_visible_characters() == get_total_character_count():
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

			# To make sure that next substring doesn't begin with a blank space
			while currentSentence.ends_with(" ") == false:
				currentSentence = currentSentence.insert(sentenceCharIndex, longText.substr(sentenceCharIndex, 1))
				sentenceCharIndex += 1

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