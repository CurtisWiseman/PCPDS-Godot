extends Node

var systems # Define systems for use globally.
var settings # Settings instance.
var loadscreen # Load screen instance.

func _ready():
	systems = $Systems # Load systems with the Systems node.
	game.safeToSave = false
	
	# Display the main menu background and play the main menu music.
	systems.display.background('res://mainmenu/DemoMenu_hq.ogv', 'video')
	systems.sound.music('res://sounds/music/PCPDating_Menu.ogg', true)
	
	$'CanvasLayer/Start'.grab_focus() # Grab the focus of start.
	
	# Make an instance of the settings scene.
	settings = Control.new()
	settings.name = 'Settings'
	settings = load('res://scenes/UI/Settings.tscn').instance()
	add_child(settings)
	settings.visible = false
	settings.get_node("ColorRect/CloseSettings").connect('pressed', self, '_on_X_pressed', ['settings'])
	
	# Make an instance of the load screen scene.
	loadscreen = Control.new()
	loadscreen.name = 'Load Screen'
	loadscreen = load('res://scenes/UI/Load_Screen.tscn').instance()
	add_child(loadscreen)
	loadscreen.visible = false
	loadscreen.get_node("CloseLoadScreen").connect('pressed', self, '_on_X_pressed', ['loadscreen'])


func _physics_prcoess(delta):
	if $'CanvasLayer/Load'.is_hovered() == true:
		$'CanvasLayer/Load'.grab_focus()
	if $'CanvasLayer/Settings'.is_hovered() == true:
		$'CanvasLayer/Settings'.grab_focus()
	if $'CanvasLayer/Quit'.is_hovered() == true:
		$'CanvasLayer/Quit'.grab_focus()



func _on_Start_pressed():
	scene.change('common')

func _on_Settings_pressed():
	for node in $'CanvasLayer'.get_children():
		node.visible = false
	settings.visible = true

func _on_Load_pressed():
	for node in $'CanvasLayer'.get_children():
		node.visible = false
	loadscreen.visible = true

func _on_Quit_pressed():
	get_tree().quit()

func _on_X_pressed(scene):
	
	if scene == 'settings': settings.visible = false
	elif scene == 'loadscreen': loadscreen.visible = false
	
	for N in $'CanvasLayer'.get_children():
			N.visible = true

#######################################################

func _on_Digibro_pressed():
	scene.change('Digi')


func _on_Ben_Saint_pressed():
	scene.change('Ben Saint')


func _on_Davoo_pressed():
	scene.change('Davoo')


func _on_Tom_pressed():
	scene.change('Tom')


func _on_Endless_War_Miniroute_pressed():
	scene.change('Endless War Miniroute')


func _on_Gibbon_pressed():
	scene.change('Gibbon')


func _on_Jesse_pressed():
	scene.change('Jesse')


func _on_Kopie_von_Digibro_pressed():
	scene.change('Kopie von Digibro')


func _on_Mage_pressed():
	scene.change('Mage')


func _on_Munchy_pressed():
	scene.change('Munchy')


func _on_Nate_pressed():
	scene.change('Nate')
