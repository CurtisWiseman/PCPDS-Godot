extends Node

# Node names.
var sound
var timer
var pause
var canvas
var display
var nametag
var dialogue
var dialogueBox

# Load scripts.
var window = load("res://scripts/windowsettings.gd").new() # Variable to use functions from windowsettings.
var chr = load("res://scripts/char.gd").new() # Variable to reference character images.

# Load nodes for all game systems.
func _ready():
	
	# Set the global rootnode to the root of the current scene.
	global.rootnode = get_node('.').owner
	
	
	
	# Ready the character script.
	chr._ready()
	
	
	
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
	dialogueBox.color = Color(0, 0, 0, 0.85);
	dialogueBox.margin_bottom = 1050;
	dialogueBox.margin_top = 760;
	dialogueBox.margin_left = 360;
	dialogueBox.margin_right = 1560;
	dialogueBox.set_script(load('res://scripts/dialoguebox.gd'))
	
	# Load the dialogue RichTextLaabel under dialogueBox.
	dialogue = RichTextLabel.new();
	dialogue.name = 'Dialogue';
	dialogue.bbcode_enabled = true;
	dialogue.margin_bottom = 245;
	dialogue.margin_top = 110;
	dialogue.margin_left = 50;
	dialogue.margin_right = 990;
	dialogue.set_script(load('res://scripts/dialogue.gd'))
	
	# Set the default font for dialogue.
	var defaultFontDialogueDATA = DynamicFontData.new()
	defaultFontDialogueDATA.font_path = 'res://fonts/Dialogue/linux_libertine/LinLibertine_R.ttf'
	var defaultFontDialogue = DynamicFont.new()
	defaultFontDialogue.font_data = defaultFontDialogueDATA
	defaultFontDialogue.size = 32
	dialogue.add_font_override("normal_font", defaultFontDialogue)
	var defaultFontDialogueDATAB = DynamicFontData.new()
	defaultFontDialogueDATAB.font_path = 'res://fonts/Dialogue/linux_libertine/LinLibertine_RB.ttf'
	var defaultFontDialogueB = DynamicFont.new()
	defaultFontDialogueB.font_data = defaultFontDialogueDATAB
	defaultFontDialogueB.size = 32
	dialogue.add_font_override("bold_font", defaultFontDialogueB)
	var defaultFontDialogueDATAI = DynamicFontData.new()
	defaultFontDialogueDATAI.font_path = 'res://fonts/Dialogue/linux_libertine/LinLibertine_RI.ttf'
	var defaultFontDialogueI = DynamicFont.new()
	defaultFontDialogueI.font_data = defaultFontDialogueDATAI
	defaultFontDialogueI.size = 32
	dialogue.add_font_override("italics_font", defaultFontDialogueI)
	dialogueBox.add_child(dialogue);
	
	# Load the Namteag under dialogueBox.
	nametag = Label.new();
	nametag.name = 'Nametag';
	nametag.text = 'Name';
	nametag.valign = 1;
	nametag.margin_bottom = 101;
	nametag.margin_top = 1;
	nametag.margin_left = 58;
	nametag.margin_right = 255;
	
#	# Set the default font for nametags.
	var defaultFontNametagDATA = DynamicFontData.new()
	defaultFontNametagDATA.font_path = 'res://fonts/Nametag/coolvetica/coolvetica rg.ttf'
	var defaultFontNametag = DynamicFont.new()
	defaultFontNametag.font_data = defaultFontNametagDATA
	defaultFontNametag.size = 60
	nametag.add_font_override("font", defaultFontNametag)
	dialogueBox.add_child(nametag);
	
	# Load the character timer under dialogueBox.
	timer = Timer.new();
	timer.name = 'Timer';
	timer.process_mode = 1;
	timer.wait_time = 0.07;
	timer.one_shot = false;
	timer.autostart = true;
	timer.connect("timeout", dialogue, "_on_Timer_timeout");
	dialogueBox.add_child(timer);
	
	canvas.add_child(dialogueBox);
	canvas.add_child(pause)