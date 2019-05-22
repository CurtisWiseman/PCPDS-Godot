extends Node

var dest # The destination of collider
var speed # The speed at which collider moves.
var collider = null # The node doing the colliding.
signal position_finish # Emitted when collider has reached dest.

# Called by display.gd with the dest, speed, and colliding node.
func move(x, s, c):
	dest = x
	speed = s
	collider = c
	connect('position_finish', self, 'free_node') # Connects signal 'position_finish' to free_node().

# Calculates the movement of images across the screen.
func _physics_process(delta):
	
	# If collider is not null then move the collider node to dest.
	if collider != null:
		
		get_parent().position(collider.name, int(speed.x + speed.x * delta)) # Move collider at speed.x.
		
		# Check if the destination has been reached then emit the 'position_finish' signal.
		if speed.x < 0:
			if collider.position.x <= dest - collider.get_parent().position.x:
				emit_signal('position_finish')
		else:
			if collider.position.x >= dest - collider.get_parent().position.x:
				emit_signal('position_finish')

# Called after 'position_finish' is emitted.
# Deletes the node to free memory.
func free_node():
	queue_free()