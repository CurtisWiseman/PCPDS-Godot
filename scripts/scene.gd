extends Node

var directory = 'res://scenes/'
signal transition_finish
var current
var last

# Get the Main_Menu scene path on start.
func _ready():
	last = directory + get_tree().get_current_scene().get_name() + '.tscn'
	current = last



# Function to change the scene.
func change(scenechange, transition=null, speed=5, time=0.5):
	# Variables for directory manipulation.
	var scenes = []
	var scene
	
	# Open the directory as dir.
	var dir = Directory.new()
	dir.open(directory)
	dir.list_dir_begin()
	
	# Until the end of the directory is reached append to scenes.
	while true:
		# Get the next scene in the directory.
		scene = dir.get_next()
		
		# If scene exists then append it to scenes, else break.
		if scene != "" :
			if !dir.dir_exists(scene) and scene.findn('.gd') == -1:
				scenes.append(scene.left(len(scene) - 5))
		else:
			break
	
	dir.list_dir_end() # End the directory.
	var found = false # Directory has not yet been found.
	
	# Compare the scenechange vs all scenes to find a match.
	for i in range(0, len(scenes)):
		
		if scenechange.to_lower() == scenes[i].to_lower():
			found = true
			last = current
			
			if transition != null:
				_transition(transition, 'out', speed, time)
				yield(self, 'transition_finish')
			
			get_tree().change_scene(directory + scenes[i] + '.tscn')
			current = directory + scenes[i] + '.tscn'
			
			if transition != null:
				_transition(transition, "in", speed, time)
				yield(self, 'transition_finish')
			
			break
	
	# Print error if scene was not found.
	if !found:
		print("Error: '" + scenechange + "' is not a scene!!!")



# Function to move, zoom, and 'shake' the camera.
func camera():
	pass



# Helper function to transition scenes.
func _transition(transition, fade, speed, time):
	
	var rootnode = current.replace(directory, '')
	rootnode = rootnode.replace('.tscn', '')
	var systems = global.rootnode.get_node('Systems')
	
	if transition == "fadeblack": systems.display.fadeblack(rootnode, fade, speed, "children", time, self)
	elif transition == "fadealpha": systems.display.fadealpha(rootnode, fade, speed, "children", time, self)
	else: print("Error: '" + transition + "' is not a valid scene transition option!!!")



# Function to emit signal that transition concluded.
func _transition_finish():
	emit_signal('transition_finish')