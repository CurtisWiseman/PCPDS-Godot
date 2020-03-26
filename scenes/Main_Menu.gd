extends Node

var systems # Define systems for use globally.
var settings # Settings instance.
var loadscreen # Load screen instance.

var input_locked = false
func _ready():
	systems = $Systems # Load systems with the Systems node.
	
	for b in $RouteButtons.get_children():
		b.visible = global.devmode
	
	game.safeToSave = false
	
	# Display the main menu background and play the main menu music.
	#systems.display.background('res://mainmenu/DemoMenu_hq.ogv', 'video')
	systems.sound.music('res://sounds/music/PCPDating_Menu.ogg', true)
	$menu_gfx.connect("intro_finished", self, "title_in_finished")
	
	# Make an instance of the settings scene.
	settings = Control.new()
	settings.name = 'Settings'
	settings = load('res://scenes/UI/Settings.tscn').instance()
	add_child(settings)
	settings.visible = false
	settings.get_node("close_button").connect('pressed', self, '_on_X_pressed', ['settings'])
	
	# Make an instance of the load screen scene.
	loadscreen = load('res://scenes/UI/Pause_Load_Screen.tscn').instance()
	loadscreen.name = 'Pause_Load_Screen'
	loadscreen.visible = false
	add_child(loadscreen)
	loadscreen.get_node("close_button").connect('pressed', self, '_on_X_pressed', ['loadscreen'])
	



func title_in_finished():
	for c in $NewButtons.get_children():
		c.show()

func _on_Start_pressed():
	if input_locked:
		return
	input_locked = true
	$menu_gfx.menu_out()
	yield($menu_gfx, "frame_changed")
	for node in $NewButtons.get_children():
		node.visible = false
	yield($menu_gfx, "outro_finished")
	scene.change('common')
	input_locked = false
	
func _on_Settings_pressed():
	if input_locked:
		return
	input_locked = true
	for node in $NewButtons.get_children():
		node.visible = false
	#settings.menu_in()
	settings.visible = true
	input_locked = false
	
func _on_Load_pressed():
	if input_locked:
		return
	input_locked = true
	for node in $NewButtons.get_children():
		node.visible = false
	loadscreen.visible = true
	input_locked = false
	
func _on_Quit_pressed():
	if input_locked:
		return
	input_locked = true
	$menu_gfx.menu_out()
	yield($menu_gfx, "frame_changed")
	for node in $NewButtons.get_children():
		node.visible = false
	yield($menu_gfx, "outro_finished")
	get_tree().quit()
	
func _on_X_pressed(scene):
	if scene == 'settings': 
		#settings.menu_out()
		#yield(settings, "closed")
		settings.visible = false
		
	elif scene == 'loadscreen': 
		loadscreen.visible = false
	
	for N in $NewButtons.get_children():
		N.visible = true
		
	global.save_settings()

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

