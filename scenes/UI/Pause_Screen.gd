extends Control

# Scenes
var saveScene
var loadScene
var settingsScene

var reloadLoad = false # Whether or not to reload the load scene.
var transitioning = false

var current_screen = null

func _ready():
	settingsScene = load('res://scenes/UI/Settings.tscn').instance()
	settingsScene.visible = false
	#settingsScene.rect_position.x = -80
	add_child(settingsScene)
	move_child(settingsScene, 1)
	settingsScene.get_node("close_button").connect("pressed", self, "_on_close_pressed")

	saveScene = Control.new()
	saveScene.name = 'Pause_Save_Screen'
	saveScene = load('res://scenes/UI/Pause_Save_Screen.tscn').instance()
	saveScene.PauseScreen = self
	saveScene.visible = false
	#saveScene.rect_position.x = -80
	add_child(saveScene)
	move_child(saveScene, 1)
	current_screen = saveScene
	saveScene.get_node("close_button").connect("pressed", self, "_on_close_pressed")
	
	loadScene = Control.new()
	loadScene.name = 'Pause_Load_Screen'
	loadScene = load('res://scenes/UI/Pause_Load_Screen.tscn').instance()
	loadScene.visible = false
	#loadScene.rect_position.x = -80
	add_child(loadScene)
	move_child(loadScene, 1)
	loadScene.get_node("close_button").connect("pressed", self, "_on_close_pressed")
	

	
	global.pauseScreen = self
	
func _physics_prcoess(delta):
	if $buttons/Save.is_hovered(): $buttons/Save.grab_focus()
	if $buttons/Load.is_hovered(): $buttons/Load.grab_focus()
	if $buttons/History.is_hovered(): $buttons/History.grab_focus()
	if $buttons/MainMenu.is_hovered(): $buttons/MainMenu.grab_focus()
	if $buttons/Quit.is_hovered(): $buttons/Quit.grab_focus()

func _input(event):
	var hist = global.rootnode.get_node('Systems').history
	if hist.visible:
		return
		
	if event.is_action_pressed("pause") and !game.blockInput and not transitioning: #Originally, this was using ui_cancel. I created my own input_map type in Project Settings -> Input Map
		$buttons/Save.grab_focus() #It is linked to the Escape key and the Start button on controllers
		var display = global.rootnode.get_node('Systems').display
		if display.animation != null:
			display.animation.paused = not visible
		if visible:
			menu_out()
		else:
			menu_in()
		
func _on_close_pressed():
	if not transitioning:
		menu_out()
		
func menu_in():
	$scene_name.text = "Scene: " + global.current_scene_name
	transitioning = true
	$background.menu_in()
	$buttons.visible = false
	visible = true
	yield($background, "intro_finished")
	$buttons.visible = true
	transitioning = false
	global.toggle_pause()
	current_screen.menu_in()
	
func menu_out():
	$pop_ups.hide()
	$pop_ups/desktop.hide()
	$pop_ups/menu.hide()
	global.save_settings()
	transitioning = true
	current_screen.menu_out()
	yield(current_screen, "outro_finished")
	$background.menu_out()
	yield($background, "frame_changed")
	$buttons.visible = false
	yield($background, "outro_finished")
	visible = false
	transitioning = false
	global.toggle_pause()
	
func _on_Save_pressed():
	if current_screen != saveScene:
		current_screen.menu_out()
		#current_screen.visible = false
		yield(current_screen, "outro_finished")
		current_screen = saveScene
		current_screen.menu_in()
		#current_screen.visible = true
	global.save_settings()
	
func _on_Load_pressed():
	global.save_settings()
	if reloadLoad:
		loadScene.loadSaveGames()
		reloadLoad = false
	if current_screen != loadScene:
		current_screen.menu_out()
		#current_screen.visible = false
		yield(current_screen, "outro_finished")
		current_screen = loadScene
		current_screen.menu_in()
		#current_screen.visible = true
		
func _on_History_pressed():
	saveScene.visible = false
	loadScene.visible = false
	# text history not implemented yet.

func _on_MainMenu_pressed():
	$pop_ups.show()
	$pop_ups/menu.show()
	global.save_settings()
	
func _on_MainMenu_Confirmation_confirmed():
	visible = false
	get_tree().paused = false
	get_tree().change_scene("res://scenes/Main_Menu.tscn")

func _on_mainmenu_closed():
	$pop_ups.hide()
	$pop_ups/menu.hide()
		
func _on_Quit_pressed():
	$pop_ups.show()
	$pop_ups/desktop.show()
	global.save_settings()
	
func _on_Quit_Confirmation_confirmed():
	get_tree().quit()

func _on_quit_closed():
	$pop_ups.hide()
	$pop_ups/desktop.hide()

func _on_Settings_pressed():
	if current_screen != settingsScene:
		current_screen.menu_out()
		#current_screen.visible = false
		yield(current_screen, "outro_finished")
		current_screen = settingsScene
		current_screen.menu_in()
		#current_screen.visible = true
	global.save_settings()
