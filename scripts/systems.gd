extends Node

# Node names.
var display
var dialogue
var sound
var canvas
var pause

# Load scripts.
var window = load("res://scripts/windowsettings.gd").new() # Variable to use functions from windowsettings.
var chr = load("res://scripts/char.gd").new() # Variable to reference character images.

# Load nodes for all game systems.
func _ready():
	
	# Set the global rootnode to the root of the current scene.
	global.rootnode = get_node('.').owner
	
	
	
	# Ready the character script.
	chr._ready()
	
	
	
	# Make a canvaslayer node for keeping things on top such as the dialogue box.
	canvas = CanvasLayer.new()
	canvas.name = 'Canvas'
	add_child(canvas)
	
	
	
	# Load the image system under the display variable.
	display = Sprite.new() # Create a new Sprite node.
	display.set_name('Display') # Give it the name Display.
	display.set_script(load('res://scripts/display.gd')) # Attatch the display script.
	add_child(display) # Add the node under the Systems node.
	
	
	
	# Load the dialogue system under the dialogue variable.
	dialogue = Polygon2D.new() # Create a new polygon2D.
	dialogue.name = 'Dialogue Box' # Give the name Dialogue Box.
	
	var saydialogue = RichTextLabel.new() # Create a new richtextlabel.
	saydialogue.name = "Dialogue" # Make the node name Dialogue.
	saydialogue.rect_size = Vector2(1860,160) # Set the rectangle size.
	saydialogue.rect_position = Vector2(60, 840) # Set the position of the dialogue.
	saydialogue.text = 'This is some test dialogue to show what it looks like when it is read out.' # R E M O V E   R E M O V E   R E M O V E   R E M O V E   R E M O V E   R E M O V E
	saydialogue.set_script(load('res://scripts/dialogue.gd')) # Set the node's script to dialogue.gd.
	saydialogue.connect('has_been_read', dialogue, '_on_Dialogue_has_been_read')
	dialogue.add_child(saydialogue) # Add ass a child of dialogue box.
	
	
	var nametag = Label.new() # Create a new label.
	nametag.name = "Nametag" # Make the node name nametag.
	nametag.rect_size = Vector2(300, 100) # Set the label's size.
	nametag.rect_position = Vector2(170, 785) # Set the label's position.
	nametag.text = 'Test' # R E M O V E   R E M O V E   R E M O V E   R E M O V E   R E M O V E   R E M O V E
	#nametag.font # Need to get a suitable size font for the label.
	dialogue.add_child(nametag) # Add as a child of the dialouge box.
	
	var timer = Timer.new() # Create a new timer.
	timer.process_mode = 1 # Set process mode to idle.
	timer.one_shot = false # Make the timer recurring.
	timer.autostart = true # Start the timer as soon as it is on screen.
	timer.wait_time = 0.07 # Set the text speed using the wait_time.
	timer.name = "Timer" # Give the timer the name Timer.
	timer.connect('timeout', saydialogue, '_on_Timer_timeout') # Connect the timer to saydialogue.
	dialogue.add_child(timer) # Add under the dialouge box.
	
	dialogue.polygon = [Vector2(0, 800), Vector2(1920, 800), Vector2(1920, 1080), Vector2(0, 1080)] # Define the endpoints of the polygon.
	dialogue.color = Color(0, 0, 0, 0.6) # Set the color of the polygon2D.
	dialogue.set_script(load('res://scripts/dialoguebox.gd')) # Set the node's script to dialoguebox.gd.
	
	
	
	# Load the sound system under the sound variable.
	sound = Node.new() # Create a new Node node.
	sound.set_name('Sound') # Give it the name Sound.
	sound.set_script(load('res://scripts/sound.gd')) # Attatch the sound script.
	add_child(sound) # Add the node under the Systems node.
	
	
	
	# Load the pause screen system under the pause variable.
	pause = Control.new() # Make a new contol node.
	pause.name = 'Pause' # Name the node Pause.
	pause = load('res://scenes/Pause_Screen.tscn').instance() # Attatch the Pause_Screen scene to pause.
	pause.visible = false # Make the scene inisible.


# Function to view the dialogue box on a scene.
func dialogue():
	canvas.add_child(dialogue)
	canvas.add_child(pause)