extends Node

# Node names.
var display

# Load scripts.
var window = load("res://scripts/windowsettings.gd").new() # Variable to use functions from windowsettings.

# Load nodes for all game systems.
func _ready():
	
	# Set the global rootnode to the root of the current scene.
	global.rootnode = get_node('.').owner
	
	# Load the image system under the display variable.
	display = Sprite.new() # Create a new sprite node.
	display.set_name('Display') # Give it the name Display.
	display.set_script(load('res://scripts/display.gd')) # Attatch the display script.
	add_child(display) # Add the node under the Systems node.