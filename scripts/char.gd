extends Node

# Define the characters for global use.
var actiongiraffe
var digibro
var hippo
var endlesswar
var mage
var munchy
var nate
var thoth
var tom

func _ready():
	
	# Initialize the characters with dictionaries. (Except thoth, just load his body.)
	actiongiraffe = {'afl': [], 'happy': [], 'angry': [], 'confused': [], 'neutral': [], 'sad': [], 'shock': [], 'blush': null, 'body': []}
	digibro = {'afl': [], 'campus': {'happy': [], 'angry': [], 'confused': [], 'neutral': [], 'sad': [], 'shock': [], 'smitten': [], 'blush': null, 'body': []}, 'casual': {'happy': [], 'angry': [], 'confused': [], 'neutral': [], 'sad': [], 'shock': [], 'smitten': [], 'blush': null, 'body': []}}
	endlesswar = {'afl': [], 'happy': [], 'angry': [], 'confused': [], 'neutral': [], 'sad': [], 'shock': [], 'smitten': [], 'blush': [], 'body': [], 'knife': {'happy': [], 'angry': [], 'confused': [], 'neutral': [], 'sad': [], 'shock': [], 'smitten': [], 'blush': [], 'body': []}}	
	hippo = {'afl': [], 'campus': {'happy': [], 'angry': [], 'confused': [], 'neutral': [], 'sad': [], 'shock': [], 'smitten': [], 'blush': null, 'body': []}, 'casual': {'happy': [], 'angry': [], 'confused': [], 'neutral': [], 'sad': [], 'shock': [], 'smitten': [], 'blush': null, 'body': []}}
	mage = {'afl': [], 'campus': {'happy': [], 'angry': [], 'confused': [], 'neutral': [], 'sad': [], 'shock': [], 'smitten': [], 'blush': null, 'body': []}, 'casual': {'happy': [], 'angry': [], 'confused': [], 'neutral': [], 'sad': [], 'shock': [], 'smitten': [], 'blush': null, 'body': []}}
	munchy = {'afl': [], 'stand': {'happy': [], 'angry': [], 'confused': [], 'neutral': [], 'sad': [], 'shock': [], 'smitten': [], 'blush': null, 'body': []}, 'squat': {'happy': [], 'angry': [], 'confused': [], 'neutral': [], 'sad': [], 'shock': [], 'smitten': [], 'blush': null, 'body': []}}
	nate = {'afl': [], 'campus': {'happy': [], 'angry': [], 'confused': [], 'neutral': [], 'sad': [], 'shock': [], 'smitten': [], 'blush': null, 'body': []}, 'casual': {'happy': [], 'angry': [], 'confused': [], 'neutral': [], 'sad': [], 'shock': [], 'smitten': [], 'blush': null, 'body': []}}
	thoth = 'res://images/characters/Thoth/thoth.png'
	tom = {'afl': [], 'happy': [], 'angry': [], 'confused': [], 'neutral': [], 'sad': [], 'shock': [], 'blush': null, 'body': []}
	
	# Make an array of the characters who need their images loaded. (Make the same as their folder name.)
	var chararray = ['Action Giraffe', 'Digibro', 'Endless War', 'Hippo', 'Mage', 'Munchy', 'Nate', 'Tom']
	loadchars(chararray)



# Function to load character dictionaries with the appropriate images.
func loadchars(chararray):
	
	for character in chararray:
		
		var bodies = returndir(character)
		for body in bodies:
			insert(character, body, 'body')
		
		var faces = returnfaces(character)
		for face in faces:
			insert(character, face, 'face')
		
		var afls = returndir(character + '/AFL')
		for afl in afls:
			insert(character, afl, 'afl')



# Function that inserts an image to the correct character dictionary.
func insert(character, file, type):
	
	match character:
		
		'Action Giraffe':
			if type == 'body':
					actiongiraffe.body.append(file)
			
			elif type == 'face':
				match emotedecipher(file):
					1: actiongiraffe.angry.append(file)
					2: actiongiraffe.confused.append(file)
					3: actiongiraffe.happy.append(file)
					4: actiongiraffe.neutral.append(file)
					5: actiongiraffe.sad.append(file)
					6: actiongiraffe.shock.append(file)
					7: actiongiraffe.smitten.append(file)
			
			elif type == 'afl':
				if file.findn('blush') != -1:
					actiongiraffe.blush = file
				else:
					actiongiraffe.afl.append(file)
		
		'Digibro':
			if type == 'body':
				if file.findn('campus') != -1:
					digibro.campus.body.append(file)
				elif file.findn('casual') != -1:
					digibro.casual.body.append(file)
					
			elif type == 'face':
				if file.findn('campus') != -1:
					match emotedecipher(file):
						1: digibro.campus.angry.append(file)
						2: digibro.campus.confused.append(file)
						3: digibro.campus.happy.append(file)
						4: digibro.campus.neutral.append(file)
						5: digibro.campus.sad.append(file)
						6: digibro.campus.shock.append(file)
						7: digibro.campus.smitten.append(file)
				elif file.findn('casual') != -1:
					match emotedecipher(file):
						1: digibro.casual.angry.append(file)
						2: digibro.casual.confused.append(file)
						3: digibro.casual.happy.append(file)
						4: digibro.casual.neutral.append(file)
						5: digibro.casual.sad.append(file)
						6: digibro.casual.shock.append(file)
						7: digibro.casual.smitten.append(file)
			
			elif type == 'afl':
				if file.findn('blush') != -1:
					if file.findn('campus') != -1:
						digibro.campus.blush = file
					elif file.findn('casual') != -1:
						digibro.casual.blush = file
					else:
						digibro.campus.blush = file
						digibro.casual.blush = file
				else:
					digibro.afl.append(file)
					
		
		'Endless War':
			if type == 'body':
				endlesswar.body.append(file)
				endlesswar.knife.body.append(file)
			
			elif type == 'face':
				if file.findn('knife') != -1:
					match emotedecipher(file):
						1: endlesswar.knife.angry.append(file)
						2: endlesswar.knife.confused.append(file)
						3: endlesswar.knife.happy.append(file)
						4: endlesswar.knife.neutral.append(file)
						5: endlesswar.knife.sad.append(file)
						6: endlesswar.knife.shock.append(file)
						7: endlesswar.knife.smitten.append(file)
				else:
					match emotedecipher(file):
						1: endlesswar.angry.append(file)
						2: endlesswar.confused.append(file)
						3: endlesswar.happy.append(file)
						4: endlesswar.neutral.append(file)
						5: endlesswar.sad.append(file)
						6: endlesswar.shock.append(file)
						7: endlesswar.smitten.append(file)
			
			elif type == 'afl':
				if file.findn('blush') != -1:
					if file.findn('knife') != -1:
						endlesswar.knife.blush.append(file)
					else:
						endlesswar.blush.append(file)
				else:
					endlesswar.afl.append(file)
		
		'Hippo':
			if type == 'body':
				if file.findn('campus') != -1:
					hippo.campus.body.append(file)
				elif file.findn('casual') != -1:
					hippo.casual.body.append(file)
					
			elif type == 'face':
				match emotedecipher(file):
					1: 
						hippo.campus.angry.append(file)
						hippo.casual.angry.append(file)
					2: 
						hippo.campus.confused.append(file)
						hippo.casual.confused.append(file)
					3: 
						hippo.campus.happy.append(file)
						hippo.casual.happy.append(file)
					4: 
						hippo.campus.neutral.append(file)
						hippo.casual.neutral.append(file)
					5: 
						hippo.campus.sad.append(file)
						hippo.casual.sad.append(file)
					6: 
						hippo.campus.shock.append(file)
						hippo.casual.shock.append(file)
					7: 
						hippo.campus.smitten.append(file)
						hippo.casual.smitten.append(file)
			
			elif type == 'afl':
				if file.findn('blush') != -1:
					if file.findn('campus') != -1:
						hippo.campus.blush = file
					elif file.findn('casual') != -1:
						hippo.casual.blush = file
					else:
						hippo.campus.blush = file
						hippo.casual.blush = file
				else:
					hippo.afl.append(file)
		
		'Mage':
			if type == 'body':
				if file.findn('campus') != -1:
					mage.campus.body.append(file)
				elif file.findn('casual') != -1:
					mage.casual.body.append(file)
					
			elif type == 'face':
				if file.findn('campus') != -1:
					match emotedecipher(file):
						1: mage.campus.angry.append(file)
						2: mage.campus.confused.append(file)
						3: mage.campus.happy.append(file)
						4: mage.campus.neutral.append(file)
						5: mage.campus.sad.append(file)
						6: mage.campus.shock.append(file)
						7: mage.campus.smitten.append(file)
				elif file.findn('casual') != -1:
					match emotedecipher(file):
						1: mage.casual.angry.append(file)
						2: mage.casual.confused.append(file)
						3: mage.casual.happy.append(file)
						4: mage.casual.neutral.append(file)
						5: mage.casual.sad.append(file)
						6: mage.casual.shock.append(file)
						7: mage.casual.smitten.append(file)
			
			elif type == 'afl':
				if file.findn('blush') != -1:
					if file.findn('campus') != -1:
						mage.campus.blush = file
					elif file.findn('casual') != -1:
						mage.casual.blush = file
					else:
						mage.campus.blush = file
						mage.casual.blush = file
				else:
					mage.afl.append(file)
		
		'Munchy':
			if type == 'body':
				if file.findn('squatting') != -1:
					munchy.squat.body.append(file)
				else:
					munchy.stand.body.append(file)
					
			elif type == 'face':
				if file.findn('squatting') != -1:
					match emotedecipher(file):
						1: munchy.squat.angry.append(file)
						2: munchy.squat.confused.append(file)
						3: munchy.squat.happy.append(file)
						4: munchy.squat.neutral.append(file)
						5: munchy.squat.sad.append(file)
						6: munchy.squat.shock.append(file)
						7: munchy.squat.smitten.append(file)
				else:
					match emotedecipher(file):
						1: munchy.stand.angry.append(file)
						2: munchy.stand.confused.append(file)
						3: munchy.stand.happy.append(file)
						4: munchy.stand.neutral.append(file)
						5: munchy.stand.sad.append(file)
						6: munchy.stand.shock.append(file)
						7: munchy.stand.smitten.append(file)
			
			elif type == 'afl':
				if file.findn('blush') != -1:
					if file.findn('squatting') != -1:
						munchy.squat.blush = file
					else:
						munchy.stand.blush = file
				else:
					munchy.afl.append(file)
		
		'Nate': 
			if type == 'body':
				if file.findn('campus') != -1:
					nate.campus.body.append(file)
				elif file.findn('casual') != -1:
					nate.casual.body.append(file)
			
			elif type == 'face':
				match emotedecipher(file):
					1: 
						nate.campus.angry.append(file)
						nate.casual.angry.append(file)
					2: 
						nate.campus.confused.append(file)
						nate.casual.confused.append(file)
					3: 
						nate.campus.happy.append(file)
						nate.casual.happy.append(file)
					4: 
						nate.campus.neutral.append(file)
						nate.casual.neutral.append(file)
					5: 
						nate.campus.sad.append(file)
						nate.casual.sad.append(file)
					6: 
						nate.campus.shock.append(file)
						nate.casual.shock.append(file)
					7: 
						nate.campus.smitten.append(file)
						nate.casual.smitten.append(file)
			
			elif type == 'afl':
				if file.findn('blush') != -1:
					if file.findn('campus') != -1:
						nate.campus.blush = file
					elif file.findn('casual') != -1:
						nate.casual.blush = file
					else:
						nate.campus.blush = file
						nate.casual.blush = file
				else:
					nate.afl.append(file)
		
		'Tom':
			if type == 'body':
					tom.body.append(file)
			
			elif type == 'face':
				match emotedecipher(file):
					1: tom.angry.append(file)
					2: tom.confused.append(file)
					3: tom.happy.append(file)
					4: tom.neutral.append(file)
					5: tom.sad.append(file)
					6: tom.shock.append(file)
					7: tom.smitten.append(file)
			
			elif type == 'afl':
				if file.findn('blush') != -1:
					tom.blush = file
				else:
					tom.afl.append(file)



# Function decipher emotions and return a number corresponding to that emotion
func emotedecipher(face):
	
	if face.findn('angry') != -1:
		return 1
	elif face.findn('confused') != -1:
		return 2
	elif face.findn('happy') != -1:
		return 3
	elif face.findn('neutral') != -1:
		return 4
	elif face.findn('sad') != -1:
		return 5
	elif face.findn('shock') != -1:
		return 6
	elif face.findn('smitten') != -1 or face.findn('blush') != -1:
		return 7



# Function to retrieve all files in a given character directory
func returndir(character):
		# Make the directory path of a characters folder.
		var directory = 'res://images/characters/' + character
		
		# A list to retrun and a variable to manage the while loop.
		var files = []
		var file
		
		# Open the directory as dir
		var dir = Directory.new()
		dir.open(directory)
		dir.list_dir_begin()
		
		# Until the end of the directory is reached appends to files.
		while true:
			# Get the next file in the directory.
			file = dir.get_next()
			
			# If file exists then append it to files, else break.
			if file != "" :
				if !dir.dir_exists(file) and file.findn('import') == -1:
					files.append(directory + '/' + file)
			else:
				break
		
		# Sort files, close the directory, and return files.
		files.sort()
		dir.list_dir_end()
		return files



# Function to return all images of a character's face folder(s).
func returnfaces(character):
	# Open the characters directory:
	var directory = 'res://images/characters/' + character
	var dir = Directory.new()
	dir.open(directory)
	dir.list_dir_begin()
	
	# Variables for manipulating file gathering.
	var tmpfiles
	var files = []
	var direc
	
	# Grab all files of face subdirectories.
	while true:
		direc = dir.get_next()
		if dir.dir_exists(direc) and direc.findn('face') != -1: #and direc.findn('face') != -1:
			tmpfiles = returndir(character + '/' + direc)
			for file in tmpfiles:
				files.append(file)
				
		if direc == "":
			break
	
	# Sort files, close the directory, and return files.
	files.sort()
	dir.list_dir_end()
	return files