extends Node

var dest # The destination of collider
var speed # The speed at which collider moves.
var timer # Timer for parent node to use.
var collider = null # The node doing the colliding.
signal position_finish # Emitted when collider has reached dest.
var parent # The Dispay function.
var nodepos
var index
var destination
var reference

var starting_x

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
	destination = x
	parent = get_parent()
	
	type = ty # The node type.
	node = n # The node.
	
	reference = weakref(node)
	
	if type == 'image': nodepos = node.position
	else: nodepos = node.rect_position
	starting_x = nodepos.x
	
	connect('position_finish', self, 'free_node') # Connects signal 'position_finish' to free_node().
	global.sliding = true; # Let the game know a node is sliding.

# Calculates the movement of images across the screen.
func _process(delta):
	if nodepos != null and speed != null:
		position(nodepos + speed*min(0.016,delta)/0.025) # Move collider at speed.x.
	
	# If dest is null then ignore ending movement.
	if dest != null:
		# Else check if the destination has been reached then emit the 'position_finish' signal.
		if starting_x > destination:
			if nodepos.x <= dest: finish()
		else:
			if nodepos.x >= dest: finish()



# Function so that other nodes can end position movement.
func finish():
	dest = null
	#So we do this twice, once before and once after the yield,
	#because if the node is null or not valid, I'm not sure if done_cleaning will happen,
	#but also, if we check before hand, it may become null AFTER we yield
	if node == null or not is_instance_valid(node):
		emit_signal('position_finish')
		return
	yield(self, 'done_cleaning')
	if node != null and is_instance_valid(node):
		var p = global.get_node_pos(node)
		p.x = destination
		global.set_node_pos(node, p)
		#More attempting to appease crashes that turbo-mode seems to incur
		var _index = index
		if parent.layers.size() <= index or not parent.layers[index].has("node") or parent.layers[index]["node"] != node:
			for l in parent.layers:
				if l.has("node") and l["node"] == node:
					_index = parent.layers.find(l)
					break
			if _index == index:
				#Well, guess it's really gone, it seems the results of this function are unneeded, so I'll just emit the signal and leave...
				emit_signal('position_finish')
				return null
		parent.layers[_index]['position'].x = destination
		emit_signal('position_finish')
		return {'path': parent.layers[_index]['path'], 'dest': destination}
	else:
		#I'm going to always emit this in order for the interpreter to always get this message, because it yields to it
		emit_signal('position_finish')


# Called after 'position_finish' is emitted.
func free_node():
	# If more than once slider then don't set sliding to false.
	var sliders = 0
	for child in parent.get_children():
		if child.name.match("*(*P*o*s*i*t*i*o*n*)*"):
			sliders += 1
	if sliders == 1:
		global.sliding = false
	
	print('freed')
	queue_free() # Deletes the node to free memory.



# Calculates position movement of node.
func position(shift):
	nodepos = shift
	if node == null or not is_instance_valid(node):
		emit_signal("done_cleaning")
	elif type == 'image' and dest != null:
		if reference.get_ref(): node.position = shift
	
	elif type == 'video' and dest != null:
		if reference.get_ref(): node.rect_position = shift
	
	else:
		emit_signal('done_cleaning')
