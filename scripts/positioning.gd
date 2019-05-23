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
var childtype # The child type.
var childnode # The child node.
var haschild = false # True if the node has a child.



# Called by display.gd with the dest, speed, and colliding node.
func move(s, c, t, x=null):
	speed = s
	collider = c
	timer = t
	dest = x
	parent = get_parent()
	
	# Find the index of the given node.
	for i in range(parent.layers.size()):

		if parent.layers[i]['name'] == collider.name:
			colindex = i
			break
	
	type = parent.layers[colindex]['type'] # The node type.
	node = parent.layers[colindex]['node'] # The node.
	
	# If the node has a child then get it's node, type, and set haschild to true.
	if colindex - 1 >= 0:
		childtype = parent.layers[colindex - 1]['type']
		childnode = parent.layers[colindex - 1]['node']
		haschild = true
	
	connect('position_finish', self, 'free_node') # Connects signal 'position_finish' to free_node().
	move = true # Begin moving the collider.



# Calculates the movement of images across the screen.
func _physics_process(delta):
	
	# If move is true then move the collider node to dest.
	if move:
		position(collider.name, int(parent.layers[colindex]['position'].x + speed.x)) # Move collider at speed.x.
		
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
func position(cname, x, y=0):
	
	# If x is of type integer then give the node it's new position using x and y.
	if typeof(x) == TYPE_INT:
		
		# If the node has been positioned once before then prepare it for repositioning.
		if parent.layers[colindex].get('posreset') != null:
			#Set the node position to the negative of it's parents position.
			if type == 'image':
				if colindex == parent.layers.size() - 1:
					node.position = Vector2(0,0)
				else:
					node.position = -parent.layers[colindex + 1]['position']
			
			#Set the node position to the negative of it's parents position.
			if type == 'video':
				if colindex == parent.layers.size() - 1:
					node.rect_position = Vector2(0,0)
				else:
					node.rect_position = -parent.layers[colindex + 1]['position']
			
			# If thier is a child set it's position to it's 'ideal' position.
			if haschild:
				if childtype == 'image':
					childnode.position = parent.layers[colindex - 1]['position']
				if childtype == 'video':
					childnode.rect_position = parent.layers[colindex - 1]['position']
					
		# If the first time being position then set 'posreset' to true.
		else:
			parent.layers[colindex]['posreset'] = true
		
		parent.layers[colindex]['position'] = Vector2(x, y) # The new 'ideal' position of node.
		
		if type== 'image':
			node.position = Vector2(node.position.x + x, node.position.y + y)
		
		elif type == 'video':
			node.rect_position = Vector2(node.rect_position.x + x, node.rect_position.y + y)
		
		# If the node has a child then determine the child's new position so it doesn't move.
		if haschild:
			
			if childtype == 'image':
				childnode.position = Vector2(childnode.position.x - x, childnode.position.y - y)
			
			elif childtype == 'video':
				childnode.rect_position = Vector2(childnode.rect_position.x - x, childnode.rect_position.y - y)