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
	munchy = {'afl': [], 'campus': {'happy': [], 'angry': [], 'confused': [], 'neutral': [], 'sad': [], 'shock': [], 'smitten': [], 'blush': null, 'body': [], 'squatting': {'happy': [], 'angry': [], 'confused': [], 'neutral': [], 'sad': [], 'shock': [], 'smitten': [], 'blush': null}}, 'casual': {'happy': [], 'angry': [], 'confused': [], 'neutral': [], 'sad': [], 'shock': [], 'smitten': [], 'blush': null, 'body': [], 'squatting': {'happy': [], 'angry': [], 'confused': [], 'neutral': [], 'sad': [], 'shock': [], 'smitten': [], 'blush': null}}}
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
				emotedecipher(file, 'actiongiraffe', '')
			
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
					emotedecipher(file, 'digibro', '.campus')
				elif file.findn('casual') != -1:
					emotedecipher(file, 'digibro', '.casual')
			
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
					emotedecipher(file, 'endlesswar', '.knife')
				else:
					emotedecipher(file, 'endlesswar', '')
			
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
				emotedecipher(file, 'hippo', '.casual')
				emotedecipher(file, 'hippo', '.campus')
			
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
					emotedecipher(file, 'mage', '.campus')
				elif file.findn('casual') != -1:
					emotedecipher(file, 'mage', '.casual')
			
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
				if file.findn('campus') != -1:
					munchy.campus.body.append(file)
				elif file.findn('casual') != -1:
					munchy.casual.body.append(file)
			
			elif type == 'face':
				if file.findn('squatting') != -1:
					emotedecipher(file, 'munchy', '.campus.squatting')
					emotedecipher(file, 'munchy', '.casual.squatting')
				else:
					emotedecipher(file, 'munchy', '.campus')
					emotedecipher(file, 'munchy', '.casual')
			
			elif type == 'afl':
				if file.findn('blush') != -1:
					if file.findn('squatting') != -1:
						munchy.campus.squatting.blush = file
						munchy.casual.squatting.blush = file
					else:
						munchy.campus.blush = file
						munchy.casual.blush = file
				else:
					munchy.afl.append(file)

		'Nate': 
			if type == 'body':
				if file.findn('campus') != -1:
					nate.campus.body.append(file)
				elif file.findn('casual') != -1:
					nate.casual.body.append(file)
			
			elif type == 'face':
				emotedecipher(file, 'nate', '.campus')
				emotedecipher(file, 'nate', '.casual')
			
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
				emotedecipher(file, 'tom', '')
			
			elif type == 'afl':
				if file.findn('blush') != -1:
					tom.blush = file
				else:
					tom.afl.append(file)



# Function decipher emotions and return a number corresponding to that emotion
func emotedecipher(face, character, outfit):
	
	if face.findn('angry') != -1:
		execute('systems.chr.'+character+outfit+'.angry.append("'+face+'")')
	elif face.findn('confused') != -1:
		execute('systems.chr.'+character+outfit+'.confused.append("'+face+'")')
	elif face.findn('happy') != -1:
		execute('systems.chr.'+character+outfit+'.happy.append("'+face+'")')
	elif face.findn('neutral') != -1:
		execute('systems.chr.'+character+outfit+'.neutral.append("'+face+'")')
	elif face.findn('sad') != -1:
		execute('systems.chr.'+character+outfit+'.sad.append("'+face+'")')
	elif face.findn('shock') != -1:
		execute('systems.chr.'+character+outfit+'.shock.append("'+face+'")')
	elif face.findn('smitten') != -1 or face.findn('blush') != -1:
		execute('systems.chr.'+character+outfit+'.smitten.append("'+face+'")')



# Function to retrieve all files in a given character directory
func returndir(character):
		# Make the directory path of a characters folder.
		var directory = 'images/characters/' + character
		
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



# Function to execute the code generated through parsing.
func execute(parsedInfo):
	var source = GDScript.new()
	source.set_source_code('func eval():\n\tvar systems = global.rootnode.get_node("Systems")\n\t' + parsedInfo)
	source.reload()
	var script = Reference.new()
	script.set_script(source)
	script.eval()