extends Node

var dest # The destination of collider
var speed # The speed at which collider moves.
var timer # Timer for parent node to use.
var collider = null # The node doing the colliding.
signal position_finish # Emitted when collider has reached dest.
var parent # The Dispay function.

# Position function variables, to lessen calculation time.
var type # The type of node.
var node # The node itself.

# Called by display.gd with the dest, speed, and colliding node.
func move(s, c, t, x=null):
	speed = s
	collider = c
	timer = t
	dest = x
	parent = get_parent()
	
	type = parent.layers[find_index()]['type'] # The node type.
	node = parent.layers[find_index()]['node'] # The node.
	
	connect('position_finish', self, 'free_node') # Connects signal 'position_finish' to free_node().
	global.sliding = true; # Let the game know a node is sliding.



# Calculates the movement of images across the screen.
func _process(delta):
	
	position(parent.layers[find_index()]['position'] + speed) # Move collider at speed.x.
	
	# If dest is null then ignore ending movement.
	if dest != null:
		# Else check if the destination has been reached then emit the 'position_finish' signal.
		if speed.x < 0:
			if parent.layers[find_index()]['position'].x <= dest:
				emit_signal('position_finish')
		else:
			if parent.layers[find_index()]['position'].x >= dest:
				emit_signal('position_finish')



# Function so that other nodes can end position movement.
func finish():
	node.position.x = dest
	dest = null
	parent.layers[find_index()]['position'].x = node.position.x
	emit_signal('position_finish')



# Function to re-find the positioning index after character addition.
func find_index():
	
	for i in range(parent.layers.size()):
	
		if parent.layers[i]['node'] == collider:
			return i



# Called after 'position_finish' is emitted.
func free_node():
	# If more than once slider then don't set sliding to false.
	var sliders = 0
	for child in parent.get_children():
		if child.name.match("*(*P*o*s*i*t*i*o*n*)*"):
			sliders += 1
	if sliders == 1:
		global.sliding = false
	
	queue_free() # Deletes the node to free memory.



# Calculates position movement of node.
func position(shift):
	parent.layers[find_index()]['position'] = shift
	
	if type == 'image':
		node.position = shift
	
	elif type == 'video':
		node.rect_position = shift