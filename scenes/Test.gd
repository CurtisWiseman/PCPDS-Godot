extends Node

var systems # Define systems for use globally.

func _ready():
	systems = $Systems # Load systems with the Systems node.
	systems.window.screensetting() # Set the default screen setting.
	systems.dialogue(); # Put dialogue box on screen and activate pause menu.
	
	# Set the scene.
	systems.display.background('res://images/backgrounds/WayToSchool - colors without J.PNG', 'image')

#func scene(text):
#	for i in range(0, systems.display.layers.size()):
#			print(systems.display.layers[i]['name'])
#	print('-----------------------------')