extends Node

var systems # Define systems for use globally.
var chr = load('res://scripts/char.gd').new()

func _ready():
	systems = get_node('Systems') # Load systems with the Systems node.
	
	# Display the main_menu.png for the settings background.
	systems.display.background('res://mainmenu/main_menu.png','image')