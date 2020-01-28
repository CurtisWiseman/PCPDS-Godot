extends Node

var systems # Define systems for use globally.
var settings # Settings instance.
var loadscreen # Load screen instance.

var startHoverLast = load('res://images/mainmenu buttons/Start button/Button 1 hover/Button 1 hover_00041.png')
var invisMenuButtons = load('res://images/mainmenu buttons/invisMenuButtons.png')
var animationPlaying = false
var current = null

signal animationFinished

func _ready():
	systems = $Systems # Load systems with the Systems node.
	game.safeToSave = false
	
	# Display the main menu background and play the main menu music.
	systems.display.background('res://mainmenu/DemoMenu_hq.ogv', 'video')
	systems.sound.music('res://sounds/music/PCPDemo_Menu.wav', true)
	
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
	scene.change('test')

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

func start(node, button):
	if animationPlaying: yield(self, 'animationFinished')
	animationPlaying = true
	button.texture_normal = invisMenuButtons
	current = node
	node.visible = true
	node.play()

func _endAnimation(node, button):
	button.texture_normal = startHoverLast
	node.visible = false
	node.stop()
	animationPlaying = false
	emit_signal('animationFinished')

func _on_Start_mouse_entered():
	$'Animations/Start/Hover'.connect("animation_finished", self, '_endAnimation', [$'Animations/Start/Hover', $'CanvasLayer/Start/'])
	start($'Animations/Start/Hover', $'CanvasLayer/Start')

func _on_Start_mouse_exited():
	$'Animations/Start/Unhover'.connect("animation_finished", self, '_endAnimation', [$'Animations/Start/Unhover', $'CanvasLayer/Start/'])
	start($'Animations/Start/Unhover', $'CanvasLayer/Start')
