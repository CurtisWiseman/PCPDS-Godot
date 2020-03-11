extends Control

# Scenes
var saveScene
var loadScene

var reloadLoad = false # Whether or not to reload the load scene.
var transitioning = false

func _ready():
	saveScene = Control.new()
	saveScene.name = 'Pause_Save_Screen'
	saveScene = load('res://scenes/UI/Pause_Save_Screen.tscn').instance()
	saveScene.PauseScreen = self
	saveScene.visible = true
	add_child(saveScene)
	
	loadScene = Control.new()
	loadScene.name = 'Pause_Load_Screen'
	loadScene = load('res://scenes/UI/Pause_Load_Screen.tscn').instance()
	loadScene.visible = false
	add_child(loadScene)
	
	global.pauseScreen = self
	
func _physics_prcoess(delta):
	if $VBoxContainer/Save.is_hovered(): $VBoxContainer/Save.grab_focus()
	if $VBoxContainer/Load.is_hovered(): $VBoxContainer/Load.grab_focus()
	if $VBoxContainer/History.is_hovered(): $VBoxContainer/History.grab_focus()
	if $VBoxContainer/MainMenu.is_hovered(): $VBoxContainer/MainMenu.grab_focus()
	if $VBoxContainer/Quit.is_hovered(): $VBoxContainer/Quit.grab_focus()

func _input(event):
	if event.is_action_pressed("pause") and !game.blockInput and not transitioning: #Originally, this was using ui_cancel. I created my own input_map type in Project Settings -> Input Map
		$VBoxContainer/Save.grab_focus() #It is linked to the Escape key and the Start button on controllers
		if visible:
			menu_out()
		else:
			menu_in()
		
func menu_in():
	transitioning = true
	$background.menu_in()
	
	visible = true
	yield($background, "intro_finished")
	transitioning = false
	global.toggle_pause()
	
func menu_out():
	transitioning = true
	$background.menu_out()
	yield($background, "outro_finished")
	visible = false
	transitioning = false
	global.toggle_pause()
	
func _on_Save_pressed():
	loadScene.visible = false
	saveScene.visible = true

func _on_Load_pressed():
	if reloadLoad:
		loadScene.loadSaveGames()
		reloadLoad = false
	saveScene.visible = false
	loadScene.visible = true

func _on_History_pressed():
	saveScene.visible = false
	loadScene.visible = false
	# text history not implemented yet.

func _on_MainMenu_pressed():
	$VBoxContainer/MainMenu/MainMenu_Confirmation.popup_centered()

func _on_MainMenu_Confirmation_confirmed():
	visible = false
	get_tree().paused = false
	get_tree().change_scene("res://scenes/Main_Menu.tscn")

func _on_Quit_pressed():
	$VBoxContainer/Quit/Quit_Confirmation.popup_centered()

func _on_Quit_Confirmation_confirmed():
	get_tree().quit()
