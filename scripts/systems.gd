extends Node

# Node names.
var sound
var timer
var pause
var scene
var winBM
var canvas
var window
var display
var nametag
var dialogue
var dialogueBox
var dialboxLeft
var dialboxRight
var winBMvisible = false

# Load scripts.
var chr = load("res://scripts/char.gd").new() # Variable to reference character images.

# Load nodes for all game systems.
func _ready():
	
	# Set the global rootnode to the root of the current scene.
	global.rootnode = get_node('.').owner
	
	
	
	# Ready the character script.
	chr._ready()
	
	
	
	# Create a node for window settings.
	window = Node.new()
	window.set_name('Window Settings')
	window.set_script(load("res://scripts/windowsettings.gd"))
	add_child(window)
	
	
	
	# Create the scene node and add under systems node.
	scene = Node.new()
	scene.set_name('Scene')
	scene.set_script(load("res://scripts/scene.gd"))
	add_child(scene)
	
	
	
	# Load the image system under the display variable.
	display = Sprite.new() # Create a new Sprite node.
	display.set_name('Display') # Give it the name Display.
	display.set_script(load('res://scripts/display.gd')) # Attatch the display script.
	add_child(display) # Add the node under the Systems node.
	
	
	
	# Load the sound system under the sound variable.
	sound = Node.new() # Create a new Node node.
	sound.set_name('Sound') # Give it the name Sound.
	sound.set_script(load('res://scripts/sound.gd')) # Attatch the sound script.
	add_child(sound) # Add the node under the Systems node.
	
	
	
	# Load the pause screen system under the pause variable.
	pause = Control.new() # Make a new contol node.
	pause.name = 'Pause' # Name the node Pause.
	pause = load('res://scenes/Pause_Screen.tscn').instance() # Attatch the Pause_Screen scene to pause.
	pause.visible = false # Make the scene invisible.



# Function to view the dialogue box on a scene and add the pause menu.
func dialogue():
	
	# Make a canvaslayer node for keeping things on top such as the dialogue box.
	canvas = CanvasLayer.new()
	canvas.name = 'Dialogue Canvas'
	add_child(canvas)
	
	# Load the DialogueBox under canvas.
	dialogueBox = ColorRect.new()
	dialogueBox.name = 'Dialogue Box'
	dialogueBox.color = Color(0, 0, 0, 0.9)
	dialogueBox.modulate = Color(1, 1, 1, 0.95)
	dialogueBox.margin_bottom = 1080
	dialogueBox.margin_top = 790
	dialogueBox.margin_left = 405
	dialogueBox.margin_right = 1515
	dialogueBox.set_script(load('res://scripts/dialoguebox.gd'))
	
	
	# Shader code for dialogue box ends.
	var code = """shader_type canvas_item;
		render_mode unshaded;
		uniform float cutoff = 0.41;
		uniform float smooth_size = 0.7;
		uniform sampler2D mask;
		void fragment()
		{
		float value = texture(mask, UV).r;
		float alpha = smoothstep(cutoff, cutoff + smooth_size, value * (1.0 - smooth_size) + smooth_size);
		COLOR = vec4(COLOR.rgb, alpha);
		}"""
	
	# Create dialogue box ends.
	dialboxRight = ColorRect.new()
	dialboxRight.name = 'Dialogue Box Right'
	dialboxRight.color = Color(0, 0, 0, 1)
	dialboxRight.margin_bottom = 290
	dialboxRight.margin_top = 0
	dialboxRight.margin_left = -405
	dialboxRight.margin_right = 0
	dialboxRight.material = ShaderMaterial.new()
	dialboxRight.material.shader = Shader.new()
	dialboxRight.material.shader.code = code
	dialboxRight.material.shader.set_default_texture_param('mask', load('res://images/dialoguebox/left.png'))
	dialogueBox.add_child(dialboxRight)
	dialboxLeft = ColorRect.new()
	dialboxLeft.name = 'Dialogue Box Left'
	dialboxLeft.color = Color(0, 0, 0, 1)
	dialboxLeft.margin_bottom = 290
	dialboxLeft.margin_top = 0
	dialboxLeft.margin_left = 1110
	dialboxLeft.margin_right = 1515
	dialboxLeft.material = ShaderMaterial.new()
	dialboxLeft.material.shader = Shader.new()
	dialboxLeft.material.shader.code = code
	dialboxLeft.material.shader.set_default_texture_param('mask', load('res://images/dialoguebox/right.png'))
	dialogueBox.add_child(dialboxLeft)
	
	# Load the dialogue RichTextLaabel under dialogueBox.
	dialogue = RichTextLabel.new();
	dialogue.name = 'Dialogue'
	dialogue.bbcode_enabled = true
	dialogue.margin_bottom = 245
	dialogue.margin_top = 80
	dialogue.margin_left = 50
	dialogue.margin_right = 1000
	dialogue.set_script(load('res://scripts/dialogue.gd'))
	
	# Set the default font for dialogue.
	var defaultFontDialogueDATA = DynamicFontData.new()
	defaultFontDialogueDATA.font_path = 'res://fonts/Dialogue/linux_libertine/LinLibertine_R.ttf'
	var defaultFontDialogue = DynamicFont.new()
	defaultFontDialogue.font_data = defaultFontDialogueDATA
	defaultFontDialogue.size = 30
	dialogue.add_font_override("normal_font", defaultFontDialogue)
	var defaultFontDialogueDATAB = DynamicFontData.new()
	defaultFontDialogueDATAB.font_path = 'res://fonts/Dialogue/linux_libertine/LinLibertine_RB.ttf'
	var defaultFontDialogueB = DynamicFont.new()
	defaultFontDialogueB.font_data = defaultFontDialogueDATAB
	defaultFontDialogueB.size = 30
	dialogue.add_font_override("bold_font", defaultFontDialogueB)
	var defaultFontDialogueDATAI = DynamicFontData.new()
	defaultFontDialogueDATAI.font_path = 'res://fonts/Dialogue/linux_libertine/LinLibertine_RI.ttf'
	var defaultFontDialogueI = DynamicFont.new()
	defaultFontDialogueI.font_data = defaultFontDialogueDATAI
	defaultFontDialogueI.size = 30
	dialogue.add_font_override("italics_font", defaultFontDialogueI)
	dialogueBox.add_child(dialogue);
	
	# Load the Namteag under dialogueBox.
	nametag = Label.new();
	nametag.name = 'Nametag'
	nametag.text = 'Name'
	nametag.valign = 1
	nametag.margin_bottom = 70
	nametag.margin_top = 0
	nametag.margin_left = 30
	nametag.margin_right = 255
	
#	# Set the default font for nametags.
	var defaultFontNametagDATA = DynamicFontData.new()
	defaultFontNametagDATA.font_path = 'res://fonts/Nametag/coolvetica/coolvetica rg.ttf'
	var defaultFontNametag = DynamicFont.new()
	defaultFontNametag.font_data = defaultFontNametagDATA
	defaultFontNametag.size = 45
	nametag.add_font_override("font", defaultFontNametag)
	dialogueBox.add_child(nametag);
	
	# Load the character timer under dialogueBox.
	timer = Timer.new()
	timer.name = 'Timer'
	timer.process_mode = 1
	timer.wait_time = 0.04
	timer.one_shot = false
	timer.autostart = true
	timer.connect("timeout", dialogue, "_on_Timer_timeout")
	dialogueBox.add_child(timer)
	
	canvas.add_child(dialogueBox)
	canvas.add_child(pause)



# Function to display warning message for borderless on windows.
func winBM():
	winBM = ColorRect.new()
	winBM.name = 'Windows Borderless Message'
	winBM.color = Color(0, 0, 0, 0.95)
	winBM.margin_top = 0
	winBM.margin_left = 0
	winBM.margin_right = 1920
	winBM.margin_bottom = 1080
	add_child(winBM)
	
	var message = Label.new()
	message.name = 'Warning'
	message.text = 'Borderless does not work properly on Windows. If you want to play the game Borderless please set your taskbar to \'hide automatically\' so that it\'s barely visible during gameplay. This message will not appear again.                 Click/Spacebar to continue!'
	message.valign = 1
	message.align = 1
	message.autowrap = true
	message.margin_top = 0
	message.margin_left = 30
	message.margin_right = 1890
	message.margin_bottom = 1080
	
	var messageFontDATA = DynamicFontData.new()
	messageFontDATA.font_path = 'res://fonts/Nametag/coolvetica/coolvetica rg.ttf'
	var messageFont = DynamicFont.new()
	messageFont.font_data = messageFontDATA
	messageFont.size = 60
	message.add_font_override("font", messageFont)
	winBM.add_child(message)
	winBMvisible = true