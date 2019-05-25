extends Node

# Node names.
var display
var sound

# Load scripts.
var window = load("res://scripts/windowsettings.gd").new() # Variable to use functions from windowsettings.

# Load nodes for all game systems.
func _ready():
	
	# Set the global rootnode to the root of the current scene.
	global.rootnode = get_node('.').owner
	
	# Load the image system under the display variable.
	display = Sprite.new() # Create a new Sprite node.
	display.set_name('Display') # Give it the name Display.
	display.set_script(load('res://scripts/display.gd')) # Attatch the display script.
	add_child(display) # Add the node under the Systems node.
	
	# Load the sound system under the sound variable.
	sound = Node.new() # Create a new Node node.
	sound.set_name('Sound') # Give it the name Sound.
	sound.set_script(load('res://scripts/sound.gd')) # Attatch the sound script.
	add_child(sound) # Add the node under the Systems node.