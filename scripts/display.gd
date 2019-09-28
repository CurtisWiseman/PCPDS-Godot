extends Node

var bgnode # The background image node.
var layers = [] # Array for storing images and videos via dictionaries containing their z-layer.
var model = File.new() # Use to check if model files exist.	
var speed # The speed and direction to move.
var timer # How long it takes a character to stop.
var collider = null # The node told to move.
var collidee = null # The node that get's collided.

# Make the given image 'bg' a background.
func background(bg, type):
	
	# If a background is already set then remove it.
	if layers.size() > 0:
		if layers[layers.size() - 1]['name'] == 'BG':
			remove('BG')
	
	var info = layersetup(bg, 0) # Get info from the layersetup() function.
	
	# If of type image make the background a sprite.
	if type == 'image':
		bgnode = Sprite.new() # Create a new sprite node.
		bgnode.set_name('BG') # Give the node the name BG.
		layers[info[1]]['node'] = bgnode # Set node to bgnode.
		layers[info[1]]['type'] = 'image' # The node's type.
		
		bgnode.texture = info[2] # Give bgnode the 'bg' image.
		bgnode.centered = false # Uncenter the background.
		bgnode.scale = Vector2(global.size.x/1920, global.size.y/1080) # Scale the backgrund to the global size.
		
		nodelayers(info[1]) # Add BG below all layers.
	
	# If of type video make the background a videoplayer.
	elif type == 'video':
		bgnode = VideoPlayer.new() # Create a new videoplayer node.
		bgnode.set_name('BG') # Give it the name BG.
		layers[info[1]]['node'] = bgnode # Set node to bgnode.
		layers[info[1]]['type'] = 'video' # The node's type.
		
		bgnode.stream = info[2] # Make the background the video.
		bgnode.rect_size = global.size # Set the size to the global size.
		bgnode.connect("finished", self, "loopvideo", [bgnode]) # Use the finished signal to run the loopvideo() function when the video finishes playing.
		
		nodelayers(info[1]) # Add BG below all layers.
		bgnode.play() # Begin playing the video.
	
	# Otherwise print an error that an incorrect type was given.
	else:
		print('ERROR: In display.background(). ' + type + ' is not a valid type.')



# Display the given image on the scene on the given layer.
func image(imgpath, z):
	
	# If z is 0 print error then exit function.
	if z == 0:
		print('Error: Images cannot have a layer index of 0. Attempted to give "' + imgpath + '" the index layer 0.')
		return
	
	var info = layersetup(imgpath, z) # Get info from the layersetup() function.
	var copy = '' # Used if their if their is a copy node.
	
	# If a copy of an existing node then temporarily remove the [#] on the end to check if model exists.
	if info[0].find_last(']') == info[0].length() - 1:
		copy = info[0].right(info[0].find_last('['))
		info[0] = info[0].left(info[0].find_last('[')) # Remove the file extension.
	
	# If a mesh model exists for the image then make a MeshInstance2D.
	if model.file_exists('res://models/' + info[0] + '.tres'):

		var meshnode = MeshInstance2D.new() # Create a new MeshInstance2D.
		meshnode.name = info[0] + copy # Name the node info[0].
		layers[info[1]]['node'] = meshnode # Add the node under the node key.
		layers[info[1]]['type'] = 'image' # The node's type.
		meshnode.texture = info[2] # Set the node's texture to the image.
		meshnode.mesh = load('res://models/' + info[0] + '.tres') # Load the mesh model.
		
		var areanode = Area2D.new() # Create a new Area2D.
		var shapenode = CollisionPolygon2D.new() # Create a new Collision
		areanode.connect('area_entered', self, '_character_entered', [areanode]) # Connect the Area2D to a signal for when other areas enter it.
		areanode.connect('area_exited', self, '_character_exited', [areanode]) # Connect the Area2D to a signal for when other areas exit it.
		areanode.add_child(shapenode) # Add the CP2D as a child of Area2D.
		AddMeshShape(areanode, meshnode) # Create a Shape for CP2D to use out of the mesh.
		meshnode.add_child(areanode) # Add the Area2D as a child of meshnode.
		layers[info[1]]['area'] = areanode # Add the Area2D as a key for meshnode to access.

		nodelayers(info[1]) # Put the meshnode into the appropriate spot based on z.

	# Else if no model exists for the image then make a Sprite.
	else:

		var imgnode = Sprite.new() # Create a new sprite node.
		imgnode.set_name(info[0]) # Give the sprite node the image name for a node name.
		layers[info[1]]['node'] = imgnode # Add the node under the node key.
		layers[info[1]]['type'] = 'image' # The node's type.
		imgnode.centered = false # Uncenter the node.
		imgnode.texture = info[2] # Set the node's texture to the image.
		nodelayers(info[1]) # Put the node into the appropriate spot based on z.



# Display the given video on the scene on the given layer.
func video(vidpath, z):
	
	# If z is 0 print error then exit function.
	if z == 0:
		print('Error: Videos cannot have a layer index of 0. Attempted to give "' + vidpath + '" the index layer 0.')
		return
	
	var info = layersetup(vidpath, z) # Get info from the layersetup() function.
	
	var vidnode = VideoPlayer.new() # Create a new videoplayer node.
	vidnode.set_name(info[0]) # Give the node vidname as its node name.
	layers[info[1]]['node'] = vidnode # Add the node under the node key.
	layers[info[1]]['type'] = 'video' # The node's type.
	vidnode.stream = info[2] # Set the node's video steam to video.
	vidnode.rect_size = global.size # Set the size to the global size.
	vidnode.connect("finished", self, "loopvideo", [vidnode]) # Use the finished signal to run the loopvideo() function when the video finishes playing.
	nodelayers(info[1]) # Put the node into the appropriate spot based on z.
	vidnode.play() # Play the video.



# Create a mask
func mask(mask, path, type, z):
	
	# If z is 0 print error then exit function.
	if z == 0:
		print('Error: Masked ' + type  + 's cannot have a layer of 0. Attempted to give "' + mask + '" the index layer 0.')
		return
	
	var info # Results of layersetup().
	var maskname = layernames(mask) # The name of the node.
	
	# The code to mask using a shader.
	var code = """shader_type canvas_item;
		uniform sampler2D mask_texture;
		void fragment() {
		vec4 color = texture(TEXTURE, UV);
		color.a *= texture(mask_texture, UV).a;
		color.rgb *= texture(mask_texture, UV).rgb;
		COLOR = color;
		}"""
	
	# If of type image the create mask over the image.
	if type == 'image':
		info = layersetup(path, z) # Get info from the layersetup() function.
		
		var imgnode = Sprite.new() # Create a new sprite node.
		imgnode.set_name(maskname) # Give the node the mask's name.
		layers[info[1]]['name'] = maskname # Change the name in layers.
		layers[info[1]]['node'] = imgnode # Add the node under the node key.
		layers[info[1]]['type'] = 'image' # The node's type.
		layers[info[1]]['mask'] = true # State the it is indeed a mask.
		imgnode.centered = false # Uncenter the node.
		imgnode.texture = info[2] # Set the node's texture to the image.
		
		imgnode.material = ShaderMaterial.new() # Create a new ShaderMaterial.
		imgnode.material.shader = Shader.new() # Give a new Shader to ShaderMaterial.
		imgnode.material.shader.code = code # Set the shader's code to code.
		imgnode.material.shader.set_default_texture_param('mask_texture', load(mask)) # Give the shader 'mask' as the image to mask with.
		
		# Check for a mesh.
		if model.file_exists('res://models/' + maskname + '.tres'):
			maskmesh(info, imgnode, maskname)
		
		nodelayers(info[1]) # Put the node into the appropriate spot based on z.
	
	# If of type video the create mask over the video.
	elif type == 'video':
		info = layersetup(path, z) # Get info from the layersetup() function.
		
		var vidnode = VideoPlayer.new() # Create a new videoplayer node.
		vidnode.set_name(maskname) # Give the node the mask's name.
		layers[info[1]]['name'] = maskname # Change the name in layers.
		layers[info[1]]['node'] = vidnode # Add the node under the node key.
		layers[info[1]]['type'] = 'video' # The node's type.
		layers[info[1]]['mask'] = true # State the it is indeed a mask.
		vidnode.stream = info[2] # Set the node's video steam to video.
		vidnode.rect_size = global.size # Set the size to the global size.
		vidnode.connect("finished", self, "loopvideo", [vidnode]) # Use the finished signal to run the loopvideo() function when the video finishes playing.
		
		vidnode.material = ShaderMaterial.new() # Create a new ShaderMaterial.
		vidnode.material.shader = Shader.new() # Give a new Shader to ShaderMaterial.
		vidnode.material.shader.code = code # Set the shader's code to code.
		vidnode.material.shader.set_default_texture_param('mask_texture', load(mask)) # Give the shader 'mask' as the image to mask with.
		
		# Check for a mesh.
		if model.file_exists('res://models/' + maskname + '.tres'):
			maskmesh(info, vidnode, maskname)
		
		nodelayers(info[1]) # Put the node into the appropriate spot based on z.
		vidnode.play() # Play the video.



# Add a face to an alreadyt existing body.
func face(facepath, body, x=0, y=0, type='face'):
	
	var index # Used to find the layers index of the body.
	
	# Get the node name of the path.
	body = getname(body)
	
	# Find the index of the body.
	for i in range(layers.size()):
		
		if layers[i]['name'] == body:
			index = i
			break
	
	# If index not found then print an error and return.
	if index == null:
		print("Error: No body named " + body + " exists for face " + facepath + " to use!")
		return
	
	var facenode = Sprite.new() # Create a new sprite node.
	facenode.set_name(layernames(facepath)) # Give the sprite node the face name for a node name.
	facenode.centered = false # Uncenter the node.
	facenode.texture = load(facepath) # Set the node's texture to the face image.
	facenode.position = Vector2(x,y) # Set the face's position to x and y.
	layers[index]['node'].add_child(facenode) # Add as a child of the body node.
	if type == 'face':
		layers[index]['face'] = facenode # Add the face node the dictionary.
	else:
		layers[index]['other'] = facenode # Add the accessory, blush, whatever to other.



# Switch content with a new texture.
func switch(content, new, type, face=false, x=0, y=0):
	
	var position = false # Don't change position by default.
	var index = getindex(content) # Get index.
	if index == null: return # If index is null return.
	
	# Error if incorrect type.
	if type != 'image' and type != 'video' and type != 'mask':
		print('Error: Switch only accepts image, video, and mask as types. No type: ' + type + '.')
		return
	
	# If types don't match there's a problem.
	if type != layers[index]['type'] and !layers[index].get('mask'):
		print('Error: Wrong switch type. Types do not match.')
		return
	
	# If x or y is not 0 then set position to true.
	if x != 0 or y !=0:
		position = true
	
	# If image then change the face or image texture.
	if type == 'image':
		if face:
			layers[index]['face'].texture = load(new)
			if position: layers[index]['face'].position = Vector2(x,y)
		else:
			layers[index]['node'].texture = load(new)
			if position: position(content, x, y)
	
	# If video then change the stream and play it.
	elif type == 'video':
		layers[index]['node'].stream = load(new)
		layers[index]['node'].play()
		if position: position(content, x, y)
	
	# Else change the mask of image/video being masked.
	else:
		layers[index]['node'].material.shader.set_default_texture_param('mask_texture', load(new))
		if position: position(content, x, y)



# Remove a layer based on it's name.
func remove(cname):
	
	var index # The index cname is in layers.
	var parent # The parent of the cname node.
	
#	# Get the node name of the path.
#	cname = getname(cname)
	
	# Find the index of then content using cname.
	for i in range(layers.size()):
		
		if layers[i]['name'] == cname:
			index = i
			break
	
	# If cname was not found then print an error and exit the function.
	if index == null:
		print('Error: ' + cname + ' is not a valid layer name to remove.')
		return
	
	# If index is 0 then remove the cname node off the end then return.
	if index == 0:
		layers[index]['node'].queue_free()
		layers.remove(index)
		return
	
	# Else remove cname node's child, remove cname node, and add cname node's child to cname's parent node.
	parent = layers[index]['node'].get_parent()
	layers[index]['node'].remove_child(layers[index - 1]['node'])
	parent.remove_child(layers[index]['node'])
	
	# Make position of child node correct after the parent is removed.
	if layers[index - 1]['type'] == 'image':
		if layers[index]['type'] == 'image':
			layers[index - 1]['node'].position += layers[index]['node'].position
		else:
			layers[index - 1]['node'].position += layers[index]['node'].rect_position
	else:
		if layers[index]['type'] == 'image':
			layers[index - 1]['node'].rect_position += layers[index]['node'].position
		else:
			layers[index - 1]['node'].rect_position += layers[index]['node'].rect_position
	
	parent.add_child(layers[index - 1]['node'])
	layers[index]['node'].queue_free()
	layers.remove(index)



# Function to move characters to specified positions.
func position(cname, x, y=0, s=4, t=0, n='all'):
	
	var index # The index of the given node.
	var node # The given node.
	var childnode # The child node.
	var type # The type of node given: img/vid.
	var childtype # The type of the child node.
	var haschild = false # True if the node has a child.
	var mv # Will be set to y if y is a string.
	
	# Get the node name of the path.
	cname = getname(cname)
	
	# Find the index of the given node.
	for i in range(layers.size()):
		
		if layers[i]['name'] == cname:
			index = i
			break
	
	# If index not found then print an error and return.
	if index == null:
		print("Error: No node named " + cname + " exists!")
		return
	
	type = layers[index]['type'] # The node type.
	node = layers[index]['node'] # The node.
	
	# If the node has a child then get it's node, type, and set haschild to true.
	if index - 1 >= 0:
		childtype = layers[index - 1]['type']
		childnode = layers[index - 1]['node']
		haschild = true
	
	# If y is a string then set mv to y, and y to 0.
	if typeof(y) == TYPE_STRING:
		mv = y
		y = 0
		
	# Else if y is not a string or int then print an error and exit.
	elif typeof(y) != TYPE_INT:
		print("Error: The position function for " + cname + " has an incorrect type as it's 3rd argument. Only int and string are accepted.")
		return
	
	# If x is of type integer then give the node it's new position using x and y.
	elif typeof(x) == TYPE_INT:
		
		# If the node has been positioned once before then prepare it for repositioning.
		if layers[index].get('posreset') != null:
			#Set the node position to the negative of it's parents position.
			if type == 'image':
				if index == layers.size() - 1:
					node.position = Vector2(0,0)
				else:
					node.position = -layers[index + 1]['position']
			
			#Set the node position to the negative of it's parents position.
			if type == 'video':
				if index == layers.size() - 1:
					node.rect_position = Vector2(0,0)
				else:
					node.rect_position = -layers[index + 1]['position']
			
			# If thier is a child set it's position to it's 'ideal' position.
			if haschild:
				if childtype == 'image':
					childnode.position = layers[index - 1]['position']
				if childtype == 'video':
					childnode.rect_position = layers[index - 1]['position']
					
		# If the first time being position then set 'posreset' to true.
		else:
			layers[index]['posreset'] = true
		
		layers[index]['position'] = Vector2(x, y) # The new 'ideal' position of node.
		
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
	
	# If x is not an interger then print an error and return.
	else:
		print("Error: The position function for " + cname + " has an incorrect type as it's 2nd argument. Only int is accepted.")
		return
	
	# If mv  has a value then prepare to move the node.
	if mv != null:
		
		# If the node position is the same as the destination do nothing and return.
		if layers[index]['position'].x == x:
			return
		
		# If the destination is negative then make the speed negative.
		if x < layers[index]['position'].x:
			s *= -1
		
		# If slide then do not interact with any characters on the way to destination.
		if mv == 'slide':
			var position = Node.new() # Creates a new Node node for positioning the image.
			position.set_script(load('res://scripts/positioning.gd')) # Give position the positioning script.
			position.set_name(cname + '(Position)') # Give it the image name + (Position)
			add_child(position) # Add it as a child of Display.
			get_node(cname + '(Position)').move(Vector2(s,0), node, 0, x) # Call position's move function.
		
		if mv == 'collide':
			
			# If n is a specific node then set it as collidee.
			if n != 'all':
				
				index = null # Reset index to null.
				
				# Find the index of n.
				for i in range(layers.size()):
				
					if layers[i]['name'] == n:
						index = i
						break
	
				# If n not found then print an error and return.
				if index == null:
					print("Error: No node named " + n + " exists as a target for collision!")
					return
				
				# Else if the collider and collidee are the same, error then return.
				elif node == layers[index]['node']:
					print("Error: Node " + n + " cannot collide with itself!")
					return
				
				# Else make the collidee the node reffered to by n.
				else:
					collidee = layers[index]['node']
			
			if layers[index].get('mask') != null:
				node = node.get_node(node.name)
			
			var position = Node.new() # Creates a new Node node for positioning the image.
			position.set_script(load('res://scripts/positioning.gd')) # Give position the positioning script.
			position.set_name(cname + '(Position)') # Give it the image name + (Position)
			add_child(position) # Add it as a child of Display.
			get_node(cname + '(Position)').move(Vector2(s,0), node, 0, x) # Call position's move function.
			
			# Set the speed and collider globally so collision happens.
			speed = Vector2(s, 0)
			timer = t
			collider = node



# Resize the given image.
func resize(path, x=100, y=100, face=false):
	
	# Get the index on make the scaling factor.
	var index = getindex(path)
	var scale = Vector2(float(x)/100, float(y)/100)
	var size
	
	# Set the scale then attempt to position it close to where it was originally (not exact).
	if face:
		layers[index]['face'].set_scale(scale)
		size = layers[index]['face'].texture.get_size()
		layers[index]['face'].position = Vector2(layers[index]['face'].position.x + (size.x - (size.x * scale.x))/2, layers[index]['face'].position.y + (size.y - (size.y * scale.y))/2)
	else:
		layers[index]['node'].set_scale(scale)
		size = layers[index]['node'].texture.get_size()
		layers[index]['node'].position = Vector2(layers[index]['node'].position.x + (size.x - (size.x * scale.x))/2, layers[index]['node'].position.y + (size.y - (size.y * scale.y))/2)



# Function to fade in an out from black.
func fadeblack(content, fade, spd, mod='self', time=0.5):
	
	var index # Index of content node.
	var percent # Used to calculate modulation.
	var ftimer = Timer.new() # A timer node.
	var face = null # If content has face.
	var other = null # If content has other.
	var p # A var for percentage calculation.
	add_child(ftimer) # Add the timer as a child.
	ftimer.one_shot = true # Make the timer one shot.
	
	# Get the node name of the path.
	content = getname(content)
	
	# Find the index of content.
	for i in range(layers.size()):
		
		if layers[i]['name'] == content:
			index = i
			break
	
	# If content node not found then print an error and return.
	if index == null:
		print("Error: No node named " + content + " exists as a target for collision!")
		return
	
	var node = layers[index]['node'] # Set node to the content node found by index.
	
	# If speed is outside the range 1-50 then print an error and return.
	if spd <= 0 or spd > 100:
		print('Error: The 3rd parameter on fadeblack only accepts values 0 < x <= 100!')
		return
	
	# Reject mod's that are not self or children.
	if mod != 'self' and mod != 'children':
		print("Error: The 4th parameter on fadeblack only accepts 'self' or 'children' as values!")
		return
	
	# Reject time less <= 0.
	if time <= 0:
		print("Error: The 5th parameter on fadeblack only accepts values above 0.")
		return
	
	# Get a face if it exists.
	if layers[index].get('face') and mod == 'self':
		face = layers[index]['face']
		
	# Get the other if it exists.
	if layers[index].get('other') and mod == 'self':
		other = layers[index]['other']
	
	# If fade is out then fade out.
	if fade == 'out':
		percent = 100
		# While percent isn't 0 fade to black.
		while percent != 0:
			percent -= spd # Subtract spd from percent.
			if percent < 0: percent = 0 # Make percent 0 if it falls below.
			p = float(percent)/100 # Make p percent/100
			if mod == 'self': node.set_self_modulate(Color(p,p,p,1)) # Modulate the node by p.
			else: node.set_modulate(Color(p,p,p,1)) # Modulate the node and all it's children by p.
			if face: face.set_self_modulate(Color(p,p,p,1)) # Modulate the face by p.
			if other: other.set_self_modulate(Color(p,p,p,1)) # Modulate the other by p.
			ftimer.start(time) # Start the timer at 0.5 seconds.
			yield(ftimer, 'timeout') # Wait for the timer to finish before continuing.
	
	# If fade is in then fade in.
	elif fade == 'in':
		percent = 0
		# While percent isn't 0 fade from black.
		while percent != 100:
			percent += spd # Add spd to percent.
			if percent > 100: percent = 100 # Make percent 100 if it goes above.
			p = float(percent)/100 # Make p percent/100
			if mod == 'self': node.set_self_modulate(Color(p,p,p,1)) # Modulate the node by p.
			else: node.set_modulate(Color(p,p,p,1)) # Modulate the node and all it's children by p.
			if face: face.set_self_modulate(Color(p,p,p,1)) # Modulate the face by p.
			if other: other.set_self_modulate(Color(p,p,p,1)) # Modulate the other by p.
			ftimer.start(time) # Start the timer at 0.5 seconds.
			yield(ftimer, 'timeout') # Wait for the timer to finish before continuing.
	
	# Else print an error if fade is not in or out.
	else:
		print("Error: The 2nd parameter on fadeblack can only be 'in' or 'out'!")
	
	ftimer.queue_free() # Free the timer.



# Function to fade in an out from black.
func fadealpha(content, fade, spd, mod='self', time=0.5):
	
	var index # Index of content node.
	var percent # Used to calculate modulation.
	var ftimer = Timer.new() # A timer node.
	var face = null # If content has face.
	var other = null # If content has other.
	var p # A var for percentage calculation.
	add_child(ftimer) # Add the timer as a child.
	ftimer.one_shot = true # Make the timer one shot.
	
	# Get the node name of the path.
	content = getname(content)
	
	# Find the index of content.
	for i in range(layers.size()):
		
		if layers[i]['name'] == content:
			index = i
			break
	
	# If content node not found then print an error and return.
	if index == null:
		print("Error: No node named " + content + " exists as a target for collision!")
		return
	
	var node = layers[index]['node'] # Set node to the content node found by index.
	
	# If speed is outside the range 1-50 then print an error and return.
	if spd <= 0 or spd > 100:
		print('Error: The 3rd parameter on fadeblack only accepts values 0 < x <= 100!')
		return
	
	# Reject mod's that are not self or children.
	if mod != 'self' and mod != 'children':
		print("Error: The 4th parameter on fadeblack only accepts 'self' or 'children' as values!")
		return
	
	# Reject time less <= 0.
	if time <= 0:
		print("Error: The 5th parameter on fadeblack only accepts values above 0.")
		return
	
	# Get a face if it exists.
	if layers[index].get('face') and mod == 'self':
		face = layers[index]['face']
	
	# Get the other if it exists.
	if layers[index].get('other') and mod == 'self':
		other = layers[index]['other']
	
	# If fade is out then fade out.
	if fade == 'out':
		percent = 100
		# While percent isn't 0 fade to black.
		while percent != 0:
			percent -= spd # Subtract spd from percent.
			if percent < 0: percent = 0 # Make percent 0 if it falls below.
			p = float(percent)/100 # Make p percent/100
			if mod == 'self': node.set_self_modulate(Color(1,1,1,p)) # Modulate the node by p.
			else: node.set_modulate(Color(1,1,1,p)) # Modulate the node and all it's children by p.
			if face: face.set_self_modulate(Color(1,1,1,p)) # Modulate the face by p.
			if other: other.set_self_modulate(Color(1,1,1,p)) # Modulate the other by p.
			ftimer.start(time) # Start the timer at 0.5 seconds.
			yield(ftimer, 'timeout') # Wait for the timer to finish before continuing.
	
	# If fade is in then fade in.
	elif fade == 'in':
		percent = 0
		# While percent isn't 0 fade from black.
		while percent != 100:
			percent += spd # Add spd to percent.
			if percent > 100: percent = 100 # Make percent 100 if it goes above.
			p = float(percent)/100 # Make p percent/100
			if mod == 'self': node.set_self_modulate(Color(1,1,1,p)) # Modulate the node by p.
			else: node.set_modulate(Color(1,1,1,p)) # Modulate the node and all it's children by p.
			if face: face.set_self_modulate(Color(1,1,1,p)) # Modulate the face by p.
			if other: other.set_self_modulate(Color(1,1,1,p)) # Modulate the other by p.
			ftimer.start(time) # Start the timer at 0.5 seconds.
			yield(ftimer, 'timeout') # Wait for the timer to finish before continuing.
	
	# Else print an error if fade is not in or out.
	else:
		print("Error: The 2nd parameter on fadeblack can only be 'in' or 'out'!")
	
	ftimer.queue_free() # Free the timer.



# Function to get the index of a node.
func getindex(content):
	
	var index # The index of content.
	
	# Get the node name of the path.
	content = getname(content)
	
	# Find the index of content.
	for i in range(layers.size()):
		
		# Return index if found.
		if layers[i]['name'] == content:
			index = i
			return index
	
	# If content node not found then print an error and return.
	if index == null:
		print("Error: No node named " + content + " exists!")
		return



# Function to get a unique node name for an image/video layer.
func layernames(path):
	
	var layname = '' # Appended to to create a unique name.
	
	path = path.left(path.find_last('.')) # Remove the file extension.
	
	# Use the fact that '/' cannot be in file names to find the last slash, and thus the image name after it.
	for i in range(path.find_last('/') + 1, path.length()):
		layname += path[i]
		
	# Check for duplicate file names.
	for i in range(0, layers.size()):
		# If a duplicate is found add a number [#] to imgname.
		if layname == layers[i]['name']:
			# Use layer[i]['name'] under the alias x to make the code shorter.
			var x = layers[i]['name']
			
			# If a numbered [#] image of the same name exists then add 1 to the number then append to imgname.
			# Else append [1] to imgname. The first image added has no number in it.
			if x.find(']') != -1 and x[x.length() - 2].is_valid_integer():
				layname = layname.left(layname.length() - 3)
				layname += '[' + str(int(x[x.length() - 2]) + 1) + ']'
			else:
				layname += '[1]'
	
	return layname # Return the name.



# Handles node parentage so that videos are also on the correct layer.
func nodelayers(index):
	
	var lastel = layers[layers.size() - 1] # Variable containing the last dictionary in the layers array.
	
	# Print an error if the layers array is not populated then exit.
	if layers.size() == 0:
		print('The layers array is empty. Incorrect use of function: The layers array must be of size >= 1.')
		return
	
	# If layers is size 1 then add the node under root.
	if layers.size() == 1:
		global.rootnode.add_child(layers[0]['node'])
		return
	
	# If layers is of size > 1 then decide who is the given nodes parent and child.
	# If index is 0 simply add node 0 under lastel node.
	if index == 0:
		layers[1]['node'].add_child(layers[0]['node'])
		return
	
	# If index is the last in the array then add lastel to the root node, remove the 2nd to last node
	if index == lastel['index']:
		global.rootnode.add_child(lastel['node'])
		global.rootnode.remove_child(layers[lastel['index'] - 1]['node'])
		lastel['node'].add_child(layers[lastel['index'] - 1]['node'])
		return
	
	# If index is not at the ends of layer then add it as a child to the layer below it,
	# then remove the child that is the layer above it from the layer below it,
	# and then add the layer above it as a child.
	layers[index + 1]['node'].add_child(layers[index]['node'])
	layers[index + 1]['node'].remove_child(layers[index - 1]['node'])
	layers[index]['node'].add_child(layers[index - 1]['node'])



# A function to do the repetitive tasks needed when adding a new layer.
func layersetup(path, z):
	
	# If the file doesn't exist then say so, let the user fix the rest.
	if not model.file_exists(path):
		print('Error: The given content ' + path + ' does not exist!')
	
	var content = load(path) # Load the content using it's path.
	var cname = '' # The name of the content
	
	if z == 0:
		cname = 'BG' # If z is zero set cname as BG.
	else:
		cname = layernames(path) # Get a unique name using the content name.
	
	var layer = {"name": cname, "path": path, "content": content, "layer": z, "position": Vector2(0,0)} # Make a dictionary of content information.
	layers.append(layer) # Append the dictionary to the layers array.
	var index = layers.size() - 1 # Get the index of the insertion.
	layers[index]['index'] = index # Make the index a key.
	layers.sort_custom(SortDictsDescending, 'sort') # Sort layers in decsending order based on 'layer'.
	
	# Get the new index of the node after the sort.
	for i in range(layers.size()):
		
		if layers[i]['name'] == cname:
			index = i
			break
	
	# Make an array of the info to send back and then return it.
	var retarray = [cname, index, content]
	return retarray



# Mash helper function for adding meshes.
func maskmesh(info, node, masknode):
	var meshnode = MeshInstance2D.new() # Create a new MeshInstance2D.
	meshnode.name = masknode # Name the node masknode.
	meshnode.position = Vector2(OS.window_size.x/2, OS.window_size.y/2) # Position correctley.
	meshnode.mesh = load('res://models/' + masknode + '.tres') # Load the mesh model.
	meshnode.visible = false # Make the mesh invisible.
	
	var areanode = Area2D.new() # Create a new Area2D.
	var shapenode = CollisionPolygon2D.new() # Create a new Collision
	areanode.connect('area_entered', self, '_character_entered', [areanode]) # Connect the Area2D to a signal for when other areas enter it.
	areanode.connect('area_exited', self, '_character_exited', [areanode]) # Connect the Area2D to a signal for when other areas exit it.
	areanode.add_child(shapenode) # Add the CP2D as a child of Area2D.
	AddMeshShape(areanode, meshnode) # Create a Shape for CP2D to use out of the mesh.
	meshnode.add_child(areanode) # Add the Area2D as a child of meshnode.
	layers[info[1]]['area'] = areanode # Add the Area2D as a key for meshnode to access.
	node.add_child(meshnode) # Add meshnode as a child of imgnode.



# Called when a character touches another.
func _character_entered(area, ogarea):
	if collidee == null:
		if ogarea.get_parent() == collider:
			_movement(area) # Move the area.
	else:
		if area.get_parent() == collidee and ogarea.get_parent() == collider:
			_movement(area) # Move the area.



# Called when a character stops touching another.
func _character_exited(area, ogarea):
	if collidee == null:
		if ogarea.get_parent() == collider:
			_end_movement(area) # Stop the area.
	else:
		if area.get_parent() == collidee and ogarea.get_parent() == collider:
			_end_movement(area) # Stop the area.



# Movement helper.
func _movement(area):
	var position = Node.new() # Creates a new Node node for positioning the area's parent node.
	position.set_script(load('res://scripts/positioning.gd')) # Give position the positioning script.
	position.set_name(area.get_parent().name + '(Position)') # Give it the area parent name + (Position)
	add_child(position) # Add position as a child of Display.
	get_node(area.get_parent().name + '(Position)').move(speed, area.get_parent(), timer) # Call position's move function with collider's speed.



# End-Movement helper.
func _end_movement(area):
	# If the timer is 0 then stop the motion.
	if get_node(area.get_parent().name + '(Position)').timer == 0:
		get_node(area.get_parent().name + '(Position)').finish() # Ends node movement when the collider leaves the area.
		
	# Else if timer > 0 create a timer to determine when to end it.
	else:
		var endtimer = Timer.new() # Create a new timer node.
		add_child(endtimer) # Add the timer node as a child of Display.
		endtimer.start(get_node(area.get_parent().name + '(Position)').timer) # Set the Timer to the given time.
		endtimer.connect('timeout', self, '_timer_end', [get_node(area.get_parent().name + '(Position)'), endtimer]) # On Timer end call _timer_end().



# Function called when position timer ends.
func _timer_end(area, time):
	time.queue_free() # Free the timer node.
	area.finish() # Ends node movement.



# Function to play a video again when it ends. Thus looping it.
func loopvideo(node):
	node.play()



# Creates a polygon shape usable for collision from a given mesh.
# Credit to Xrayez: https://github.com/Xrayez/godot-mesh-instance-collision-2d
func AddMeshShape(area, mesh):
	
	# Get triangles points from mesh
	var points = mesh.mesh.get_faces()
	
	var idx = 0
	var shapes = []
	
	while idx < points.size():
		
		# Each three vertices represent one triangle
		# Converts automatically from Vector3 to Vector2!
		var tri_points = PoolVector2Array([points[idx], points[idx + 1], points[idx + 2]])
		
		# Create an actual triangle shape
		var tri_shape = ConvexPolygonShape2D.new()
		tri_shape.points = tri_points
		shapes.push_back(tri_shape)
		
		idx += 3
		
	for sh in shapes:
		# Add created shapes to this collision body
		# `0` indicates the first shape owner which is `CollisionPolygon2D'
		area.shape_owner_add_shape(0, sh)



# Function to get the node name of a path.
func getname(path):
	var node = '' # Used to build node name.
	
	path = path.left(path.find_last('.')) # Remove the file extension.
	
	# Use the fact that '/' cannot be in file names to find the last slash, and thus the image name after it.
	for i in range(path.find_last('/') + 1, path.length()):
		node += path[i]
	
	return node



# Returns true if the given path already exists.
func exists(path):
	var layname = '' # Appended to to create a layer name.
	
	path = path.left(path.find_last('.')) # Remove the file extension.
	
	# Use the fact that '/' cannot be in file names to find the last slash, and thus the image name after it.
	for i in range(path.find_last('/') + 1, path.length()):
		layname += path[i]
	
	# Return true if a matching layer is found.
	for i in range(0, layers.size()):
		if layname == layers[i]['name']:
			return true
	
	return false # Else return false.



# Results in layers being sorted from top layer to bottom layer.
class SortDictsDescending:
	
	# Sort the layers array based on the 'layer' key in descending order.
	static func sort(d1, d2):
		if d1['layer'] > d2['layer']:
			# Switch their indexes in the array.
			var tmp = d1['index']
			d1['index'] = d2['index']
			d2['index'] = tmp
			# Returns true so that the elements are switched.
			return true
		
		return false # Returns false so that nothing happends.