extends Node

var systems # Define systems for use globally.

func _ready():
	systems = get_node('Systems') # Load systems with the Systems node.
	
	# Display the main_menu.png for the settings background.
	systems.display.background('res://mainmenu/main_menu.png','image', get_node('.'))