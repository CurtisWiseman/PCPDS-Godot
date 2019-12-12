extends Node

signal scene_changed
var directory = 'res://scenes/'
var current
var last


# Get the Main_Menu scene path on start.
func _ready():
	last = directory + get_tree().get_current_scene().get_name() + '.tscn'
	current = last



# Function to change the scene.
func change(scenechange, transition=null, speed=10, time=0.5):
	
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
	var display
	
	# Compare the scenechange vs all scenes to find a match.
	for i in range(0, len(scenes)):
		
		if scenechange.to_lower() == scenes[i].to_lower():
			found = true
			last = current
			
			if transition != null:
				display = global.rootnode.get_node('Systems/Display')
				_transition(display, transition, 'out', speed, time)
				yield(display, 'transition_finish')
			
			get_tree().change_scene(directory + scenes[i] + '.tscn')
			current = directory + scenes[i] + '.tscn'
			yield(global, 'finished_loading')
			
			if transition != null:
				display = global.rootnode.get_node('Systems/Display')
				_transition(display, transition, "in", speed, time)
				yield(display, 'transition_finish')
			
			break
	
	# Print error if scene was not found.
	if !found:
		print("Error: '" + scenechange + "' is not a scene!!!")
	else:
		emit_signal('scene_changed')



# Helper function to transition scenes.
func _transition(display, transition, fade, speed, time):
	
	if transition == "fadeblack": display.fadeblack(display.bgnode, fade, speed, "children", time)
	elif transition == "fadealpha": display.fadealpha(display.bgnode, fade, speed, "children", time)
	else: print("Error: '" + transition + "' is not a valid scene transition option!!!")