extends Node

const DialogueBox = preload('res://code/dialoguebox.gd')

# Node names.
var sound
var timer
var pause
var canvas
var camera
var display
var nametag
var dialogue
var pauseCanvas
var dialogueBox
var textBoxBackground
var blackScreen

# Load nodes for all game systems.
func _ready():
	
	# Set the global rootnode to the root of the current scene.
	global.rootnode = get_node('..')
	
	# Load the camera under the camera variable.
	camera = Camera2D.new() # Create a new node.
	camera.set_name('Camera') # Give it the name Camera.
	camera.set_script(load('res://code/camera.gd')) # Attatch the camera script.
	add_child(camera) # Add the node under the Systems node.
	
	
	# Load the image system under the display variable.
	display = Sprite.new() # Create a new Sprite node.
	display.set_name('Display') # Give it the name Display.
	display.set_script(load('res://code/display.gd')) # Attatch the display script.
	add_child(display) # Add the node under the Systems node.
	
	#characterImages.precache_videos(display)
	
	# Load the sound system under the sound variable.
	sound = Node.new() # Create a new Node node.
	sound.set_name('Sound') # Give it the name Sound.
	sound.set_script(load('res://code/sound.gd')) # Attatch the sound script.
	add_child(sound) # Add the node under the Systems node.
	
	
	
	# Load the pause screen system under the pause variable.
	pause = Control.new() # Make a new contol node.
	pause.name = 'Pause' # Name the node Pause.
	pause = load('res://scenes/UI/Pause_Screen.tscn').instance() # Attatch the Pause_Screen scene to pause.
	pause.visible = false # Make the scene invisible.
	
	# A canvas layer above all the rest for pausing.
	pauseCanvas = CanvasLayer.new()
	pauseCanvas.name = 'Pause Canvas'
	add_child(pauseCanvas)
	
	# A canvas layer node for keeping things on top such as the dialogue box.
	canvas = CanvasLayer.new()
	canvas.name = 'Dialogue Canvas'
	pauseCanvas.add_child(canvas)
	
	blackScreen = Sprite.new()
	blackScreen.name = 'Black Screen'
	blackScreen.centered = false
	blackScreen.texture = load("res://images/misc/black_screen.png")
	blackScreen.set_self_modulate(Color(1,1,1,0))
	canvas.add_child(blackScreen);
	
# Function to view the dialogue box on a scene and add the pause menu.
func dialogue(script, index=0, choicesArray=[], inChoiceBool=false, chosenChoicesArray=[], CG=null):
	
	# Load the DialogueBox under canvas.
	dialogueBox = DialogueBox.new()
	dialogueBox.name = 'Dialogue Box'
	dialogueBox.margin_top = 790
	dialogueBox.margin_bottom = 1080
	dialogueBox.margin_left = 0
	dialogueBox.margin_right = 1920
	#dialogueBox.texture = load('res://images/dialoguebox/dialogueBox.png')
	global.dialogueBox = dialogueBox
	
	#Textbox background
	textBoxBackground = load("res://scenes/UI/text_box.tscn").instance()
	dialogueBox.add_child(textBoxBackground)
	textBoxBackground.show_behind_parent = true
	
	# Load the dialogue RichTextLaabel under dialogueBox.
	dialogue = RichTextLabel.new();
	dialogue.name = 'Dialogue'
	dialogue.bbcode_enabled = true
	dialogue.margin_top = 50
	dialogue.margin_bottom = 345
	dialogue.margin_left = 455
	dialogue.margin_right = 1405
	dialogue.set_theme(global.textTheme)
	dialogue.set_script(load('res://code/dialogue.gd'))
	
	# Set the default font for dialogue.
	dialogue.add_font_override("normal_font", global.defaultFont)
	dialogue.add_font_override("bold_font", global.defaultFontBold)
	dialogue.add_font_override("italics_font", global.defaultFontItalic)
	dialogue.add_font_override("bold_italics_font", global.defaultFontBoldItalic)
	dialogueBox.add_child(dialogue);
	
	# Load the Namteag under dialogueBox.
	nametag = Label.new();
	nametag.name = 'Nametag'
	nametag.valign = 1
	nametag.margin_top = -165
	nametag.margin_bottom = 30
	nametag.margin_left = 470
	nametag.margin_right = 680
	
#	# Set the default font for nametags.
	var defaultFontNametagDATA = DynamicFontData.new()
	defaultFontNametagDATA.font_path = 'res://fonts/Nametag/RobotoSlab/RobotoSlab-SemiBold.ttf'
	var defaultFontNametag = DynamicFont.new()
	defaultFontNametag.font_data = defaultFontNametagDATA
	defaultFontNametag.size = 40
	nametag.add_font_override("font", defaultFontNametag)
	dialogueBox.add_child(nametag);
	
	# Load the character timer under dialogueBox.
	timer = Timer.new()
	timer.name = 'Timer'
	timer.process_mode = 1
	timer.wait_time = 0.02
	timer.one_shot = false
	timer.autostart = true
	timer.connect("timeout", dialogue, "_on_Timer_timeout")
	dialogueBox.add_child(timer)
	
	# Load dialogue with the necessary variables then add it to the screen.
	dialogueBox.CG = CG
	dialogueBox.dialogueScript = script
	dialogueBox.index = index
	dialogueBox.choices = choicesArray
	dialogueBox.inChoice = inChoiceBool
	dialogueBox.chosenChoices = chosenChoicesArray
	canvas.add_child(dialogueBox)
	pauseCanvas.add_child(pause)
