extends Sprite

var bgnode # The background image node.

# Make the given image 'bg' a background.
func background(bg, node):
	
	bg = load(bg) # Load the provided image path.
	
	# If a background is already set then remove it.
	#if is_a_parent_of(get_node('BG')):
	#	remove_child(bgnode)
	#	pass
	
	bgnode = Sprite.new() # Create a new sprite node.
	bgnode.set_name('BG') # Give it the name BG.
	add_child_below_node(node, bgnode) # Add BG below the given node.
	
	bgnode.texture = bg # Give bgnode the 'bg' image.s
	bgnode.centered = false # Uncenter the background.
	bgnode.z_index = 0 # Send the background to the 	back layer.
	bgnode.scale = Vector2(global.size.x/1920, global.size.y/1080) # Scale the backgrund to the global size.