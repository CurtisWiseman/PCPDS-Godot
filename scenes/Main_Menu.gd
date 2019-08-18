extends Node

var systems # Define systems for use globally.

func _ready():
	systems = $Systems # Load systems with the Systems node.
	systems.window.screensetting() # Set the default screen setting.
	
	# Display the main_menu.png for the settings background.
	systems.display.background('res://mainmenu/DemoMenu_hq.ogv','video')
	
	get_node('CanvasLayer/Start').grab_focus() # Grab the focus of start.
	
	



func _physics_prcoess(delta):
	if $'CanvasLayer/Load'.is_hovered() == true:
		get_node('CanvasLayer/Load').grab_focus()
	if get_node('CanvasLayer/Settings').is_hovered() == true:
		get_node('CanvasLayer/Settings').grab_focus()
	if get_node('CanvasLayer/Quit').is_hovered() == true:
		get_node('CanvasLayer/Quit').grab_focus()



func _on_Start_pressed():
	get_tree().change_scene('res://scenes/Test.tscn')

func _on_Settings_pressed():
	get_tree().change_scene('res://scenes/Settings.tscn')

func _on_Quit_pressed():
	get_node('CanvasLayer/Quit/Quit_Confirmation').popup_centered()

func _on_Quit_Confirmation_confirmed():
	get_tree().quit()