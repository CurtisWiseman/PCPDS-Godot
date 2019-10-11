extends Node

var systems # Define systems for use globally.
var settings # Settings instance.

func _ready():
	systems = $Systems # Load systems with the Systems node.
	systems.window.screensetting() # Set the default screen setting.
	
	# Display the main menu background and play the main menu music.
	systems.display.background('res://mainmenu/DemoMenu_hq.ogv', 'video')
	systems.sound.music('res://sounds/music/PCPDemo_Menu.wav', true)
	
	$'CanvasLayer/Start'.grab_focus() # Grab the focus of start.
	
#	# Make an instance of the settings scene.
	settings = Control.new()
	settings.name = 'Settings'
	settings = load('res://scenes/Settings.tscn').instance()
	settings.visible = false
	add_child(settings)
	settings.get_node("ColorRect/CloseSettings").connect('pressed', self, '_on_X_pressed')


func _physics_prcoess(delta):
	if $'CanvasLayer/Load'.is_hovered() == true:
		$'CanvasLayer/Load'.grab_focus()
	if $'CanvasLayer/Settings'.is_hovered() == true:
		$'CanvasLayer/Settings'.grab_focus()
	if $'CanvasLayer/Quit'.is_hovered() == true:
		$'CanvasLayer/Quit'.grab_focus()



func _on_Start_pressed():
#	get_tree().change_scene('res://scenes/Test.tscn')
	systems.scene.change('test')

func _on_Settings_pressed():
	for node in $'CanvasLayer'.get_children():
		node.visible = false
	settings.visible = true

func _on_Quit_pressed():
	get_tree().quit()

func _on_X_pressed():
	settings.visible = false
	for N in $'CanvasLayer'.get_children():
		N.visible = true