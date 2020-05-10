extends Node

signal scene_changed
var directory = 'res://scenes/'
var mod_scenes_dir = 'mod/scripts/'
var current
var last
var cur_scene = null

signal transition_finish

# Get the Main_Menu scene path on start.
func _ready():
	last = directory + get_tree().get_current_scene().get_name() + '.tscn'
	current = last



# Function to change the scene.
func change(scenechange, transition=null, speed=10, time=0.5):
	global.pause_input = true;
	game.safeToSave = false;
	cur_scene = scenechange
	# Variables for directory manipulation.
	#These folders don't exist in exported projects!
	var scenes = ["Ben Saint", "Mage", "Gibbon", "Jesse", "Tom", "Digi", "Munchy", "Davoo", "Endless War Miniroute", "Nate", "Common", "Main_Menu"]
	var is_mod_scene = {}
#	var scene
#
#	# Open the directory as dir.
	var dir = Directory.new()
	dir.open(mod_scenes_dir)
	dir.list_dir_begin()
#
#	# Until the end of the directory is reached append to scenes.
	while true:
		# Get the next scene in the directory.
		var scene = dir.get_next()

		# If scene exists then append it to scenes, else break.
		if scene != "" :
			if !dir.dir_exists(scene) and scene.findn('.tres') != -1:
				scene = scene.left(len(scene) - 5)
				scenes.append(scene)
				is_mod_scene[scene] = true
		else:
			break
#	
#	dir.list_dir_end() # End the directory.
	var found = false # Directory has not yet been found.
	var display
	
	# Compare the scenechange vs all scenes to find a match.
	for i in range(0, len(scenes)):
		
		if scenechange.replace(" ", "").to_lower() == scenes[i].replace(" ", "").to_lower():
			found = true
			last = current
			
			var target_tscn
			
			if is_mod_scene.get(scenes[i], false):
				global.destination_script = mod_scenes_dir + scenes[i] + ".tres"
				target_tscn = directory + "Generic.tscn"
			else:
				target_tscn = directory + scenes[i] + '.tscn'
			
			
			if transition != null:
				display = global.rootnode.get_node('Systems')
				display = display.blackScreen
				if display.get_self_modulate().a != 1:
					_transition(display, transition, 'out', speed, time)
					yield(self, 'transition_finish')
				
				get_tree().change_scene(target_tscn)
				current = target_tscn
				yield(global, 'finished_loading')
				
				display = global.rootnode.get_node('Systems')
				display = display.blackScreen
				_transition(display, transition, 'in', speed, time)
				yield(self, 'transition_finish')
				
			else:
				get_tree().change_scene(target_tscn)
				current = target_tscn
				yield(global, 'finished_loading')
			
			break
	
	global.pause_input = false;
	game.safeToSave = true;
	
	# Print error if scene was not found.
	if !found:
		print("Error: '" + scenechange + "' is not a scene!!!")
	emit_signal('scene_changed')



# Helper function to transition scenes.
func _transition(node, transition, fade, speed, time):
	fadeblackalpha(node, fade, speed, time)



func fadeblackalpha(node, fade, spd, time=0.5):
	global.fading = true # Let the game know fading is occuring.
	var percent # Used to calculate modulation.
	var ftimer = Timer.new() # A timer node.
	var p # A var for percentage calculation.
	ftimer.name = "fade-scene-timer" # Set the timer name.
	global.rootnode.get_node('Systems').add_child(ftimer) # Add the timer as a child.
	ftimer.one_shot = true # Make the timer one shot.
	
	# If fade is out then fade out.
	if fade == 'in':
		percent = 100
		# While percent isn't 0 fade to black.
		while percent != 0 and global.fading:
			percent -= spd # Subtract spd from percent.
			if percent < 0: percent = 0 # Make percent 0 if it falls below.
			p = float(percent)/100 # Make p percent/100
			node.set_self_modulate(Color(1,1,1,p)) # Modulate the node by p.
			ftimer.start(time) # Start the timer at 0.5 seconds.
			yield(ftimer, 'timeout') # Wait for the timer to finish before continuing.
	
	# If fade is in then fade in.
	elif fade == 'out':
		percent = 0
		# While percent isn't 0 fade from black.
		while percent != 100 and global.fading:
			percent += spd # Add spd to percent.
			if percent > 100: percent = 100 # Make percent 100 if it goes above.
			p = float(percent)/100 # Make p percent/100
			node.set_self_modulate(Color(1,1,1,p)) # Modulate the node by p.
			ftimer.start(time) # Start the timer at 0.5 seconds.
			yield(ftimer, 'timeout') # Wait for the timer to finish before continuing.
	
	# Else print an error if fade is not in or out.
	else:
		print("Error: The 2nd parameter on fadeblack can only be 'in' or 'out'!")
	
	ftimer.queue_free()
	global.finish_fading()
	emit_signal('transition_finish')
