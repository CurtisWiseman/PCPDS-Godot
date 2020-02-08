extends Node

var dest # The destination of collider
var speed # The speed at which collider moves.
var timer # Timer for parent node to use.
var collider = null # The node doing the colliding.
signal position_finish # Emitted when collider has reached dest.
var parent # The Dispay function.
var nodepos
var index
var once = 0

signal done_cleaning

# Position function variables, to lessen calculation time.
var type # The type of node.
var node # The node itself.

# Called by display.gd with the dest, speed, and colliding node.
func move(s, n, ty, i, t, x=null):
	speed = s
	index = i
	timer = t
	dest = x
	parent = get_parent()
	
	type = ty # The node type.
	node = n # The node.
	
	if type == 'image': nodepos = node.position
	else: nodepos = node.rect_position
	
	connect('position_finish', self, 'free_node') # Connects signal 'position_finish' to free_node().
	global.sliding = true; # Let the game know a node is sliding.



# Calculates the movement of images across the screen.
func _process(delta):
	
	position(nodepos + speed) # Move collider at speed.x.
	
	# If dest is null then ignore ending movement.
	if dest != null:
		# Else check if the destination has been reached then emit the 'position_finish' signal.
		if speed.x < 0:
			if nodepos.x <= dest:
				emit_signal('position_finish')
		else:
			if nodepos.x >= dest:
				emit_signal('position_finish')
	else:
		if once == 0:
			emit_signal('done_cleaning')
			once = 1



# Function so that other nodes can end position movement.
func finish():
	var destination = dest
	dest = null
	yield(self, 'done_cleaning')
	node.position.x = destination
	parent.layers[index]['position'].x = destination
	emit_signal('position_finish')
	return {'path': parent.layers[index]['path'], 'dest': destination}



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
	nodepos = shift
	
	if type == 'image' and dest != null:
		node.position = shift
	
	elif type == 'video' and dest != null:
		node.rect_position = shift