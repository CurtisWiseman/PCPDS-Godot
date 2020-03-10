extends Node2D


#This handles the custom graphics text boxes

#so, every time a character speaks, it'll populate the textbox if it needs to
#otherwise it'll use the old ones, once too many characters are cached, we ditch some

var character_load_queue = []
var loading_node = null
var load_point = 0

var load_lock = false

var character_map = {}
var node_to_character = {}
var cur_frame = 0
var current_char = null

const FRAME_TIME = 1.0/30.0
var timer = 0.0

func _ready():
	pass

func get_prefix(character):
	if global.playerName.to_lower() == character or character == "":
		return get_prefix("pcpg")
	if character == "digi" or character == "connor":
		return "res://images/UI/Text box/"+character+"/text box 2 - "+character+"_"
	elif character == "connor":
		return get_prefix("bluewhale")
	elif character == "endless war":
		return get_prefix("endlesswar")
	else:
		return "res://images/UI/Text box/" + character + "/textbox_" + character + "_"
		
func load_all_characters_frames(character):
	prints("LOADING ALL ON", character)
	if character_load_queue.front() == character:
		character_load_queue.pop_front()
		load_point = 0
		loading_node.queue_free()
		remove_child(loading_node)
			
	var parent = Node2D.new()
	parent.name = character
	add_child(parent)
	var pref = get_prefix(character)
	
	for i in range(0, 105):
		load_single_frame(parent, i, pref)
		
	set_textbox_parent(parent, character)
	return parent
	
func set_textbox_parent(parent, character):
	parent.visible = false
	if get_children().size() > 10:
		var removed = get_child(0)
		character_map.erase(node_to_character[removed])
		node_to_character.erase(removed)
		removed.queue_free()
	character_map[character] = parent

		
func load_single_frame(parent, num, prefix):
	var num_text = str(num)
	while num_text.length() < 3:
		num_text = "0"+num_text
	var texture = load(prefix+num_text+".png")
	var spr = Sprite.new()
	spr.texture = texture
	spr.name = "frame_" + num_text
	spr.centered = false
	spr.position.x = 300
	spr.position.y = -100
	parent.add_child(spr)
		
func swap_character(character):
	if not character_map.has(character):
		load_all_characters_frames(character)
	var character_node = character_map[character]
	node_to_character[character_node] = character
	move_child(character_node, get_child_count())
	
	for other in character_map.values():
		if character_node != other:
			other.visible = false
	
	character_node.visible = true
	current_char = character
	for f in character_node.get_children():
		f.visible = false
	character_node.get_child(cur_frame).visible = true
	
func advance_frame():
	if current_char != null:
		character_map[current_char].get_child(cur_frame).visible = false
		cur_frame = (cur_frame+1)%105
		character_map[current_char].get_child(cur_frame).visible = true
	
func queue_load(character):
	character_load_queue.append(character)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	while timer > FRAME_TIME:
		advance_frame()
		timer -= FRAME_TIME
		
	if character_load_queue.size() > 0:
		if loading_node == null:
			loading_node = Node2D.new()
			loading_node.name = character_load_queue.front()
			add_child(loading_node)
			loading_node.visible = false
		print("LOADING FRAME: " + character_load_queue.front(), load_point)
		load_single_frame(loading_node, load_point, get_prefix(character_load_queue.front()))
		load_point += 1
		if load_point >= 105:
			print("DONE!")
			load_point = 0
			set_textbox_parent(loading_node, character_load_queue.pop_front())
			loading_node = null
	timer += delta
	
