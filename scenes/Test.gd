extends Node

var systems # Define systems for use globally.

func _ready():
	systems = $Systems # Load systems with the Systems node.
	systems.window.screensetting() # Set the default screen setting.
	
	systems.display.background('res://images/backgrounds/dining_hall_base.png', 'image')
	
#	systems.display.face("res://images/characters/Digibro/Faces_Campus/digi_face_campus_blush2.png", "res://images/characters/Digibro/digi_body_campus1.png", 430, 400, 'face')
	
#	systems.display.mask('Digibro', 'res://images/backgrounds/characters/Digibro/digi_body_campus1.png', 'image', 2)

	
#	systems.display.face('res://images/characters/Digibro/Faces_Campus/digi_face_campus_angry1.png','Digibro' ,0, 0,'face')
	
#	systems.dialogue()  Put the dialogue box on the scene.

func _process(delta):
	if Input.is_action_just_pressed("advance_text"):
		pass
	pass