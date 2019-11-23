extends Node

var dest # The destination of collider
var speed # The speed at which collider moves.
var timer # Timer for parent node to use.
var collider = null # The node doing the colliding.
signal position_finish # Emitted when collider has reached dest.
var colindex # The index of the colliding node.
var move = false # Begin moving node when true.
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
	
	# Find the index of the given node.
	for i in range(parent.layers.size()):

		if parent.layers[i]['node'] == collider:
			colindex = i
			break
	
	type = parent.layers[colindex]['type'] # The node type.
	node = parent.layers[colindex]['node'] # The node.
	
	connect('position_finish', self, 'free_node') # Connects signal 'position_finish' to free_node().
	move = true # Begin moving the collider.



# Calculates the movement of images across the screen.
func _physics_process(delta):
	
	# If move is true then move the collider node to dest.
	if move:
		position(collider.name, parent.layers[colindex]['position'] + speed) # Move collider at speed.x.
		
		# If dest is null then ignore ending movement.
		if dest != null:
			# Else check if the destination has been reached then emit the 'position_finish' signal.
			if speed.x < 0:
				if parent.layers[colindex]['position'].x <= dest:
					emit_signal('position_finish')
			else:
				if parent.layers[colindex]['position'].x >= dest:
					emit_signal('position_finish')



# Function so that other nodes can end position movement.
func finish():
	emit_signal('position_finish')



# Called after 'position_finish' is emitted.
# Deletes the node to free memory.
func free_node():
	queue_free()



# Calculates position in node to prevent race condition from occuring.
func position(cname, shift):
	
	parent.layers[colindex]['position'] = shift
	
	if type == 'image':
		node.position = shift
	
	elif type == 'video':
		node.rect_position = shift