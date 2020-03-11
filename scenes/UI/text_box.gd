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

var sprite

var target_visibility = true

func _ready():
	sprite = Sprite.new()
	sprite.centered = false
	sprite.position.x = 335
	sprite.position.y = -120
	add_child(sprite)
	check_all_texboxes()
	
func check_all_texboxes():
	var all_speakers = ['???', '9/11', 'action giraffe', 'adelram', 'announcer', 'artsofartso', 'azumi', 'ben', 'ben and munchy', 'ben & jesse', 'brunswick', 'bush', 'cafeteria lady', 'cerise', 'cider', 'clara', 'colt corona', 'connor', 'copkillers', 'cop killers', 'crocs', 'davoo', 'davoo collective', 'digi', 'donatello', 'drug dealer', 'drunken man', 'endlesswar', 'endless war', 'ephraim', 'geoff', 'gibbon', 'god', 'gungirl', 'hussiefox', 'indigo interlopers', 'interlopers', 'jesse', 'k1p', 'kazee', 'lethal', 'lord of ghosts', 'magda', 'mage', 'magicks', 'may', 'maygib', 'michelle', 'mumkey jones', 'munchy', 'nate', 'pcpg', 'phone', 'redman', 'russel', 'schrafft', 'smearg', 'snob', 'sophia', 'thoth', 'tom', 'uwupedy', 'v', 'vincent', 'voice from downstairs']
	var f = File.new()
	for s in all_speakers:
		if not f.file_exists(get_prefix(s)+"000.png"):
			prints("BAD CHARACTER TEXT BOX:", s, get_prefix(s))
			
func get_prefix(character):
	var char_id = character.to_lower().replace(" ", "")
	if char_id == "":
		return get_prefix("blank")
	elif char_id == "player" or global.playerName.to_lower() == character or char_id == "phone" or char_id == "???" or char_id == "announcer" or char_id == "bush" or char_id == "cafeterialady" or char_id == "drunkenman":
		return get_prefix("pcpg")
	if char_id == "digi":
		return "res://images/UI/Text box/"+char_id+"/text box 2 - "+char_id+"_"
	elif char_id == "benandmunchy":
		return get_prefix("lethal")
	elif char_id == "ben&jesse":
		return get_prefix("v")
	elif char_id == "cider":
		return get_prefix("kazee")
	elif char_id == "connor" or char_id == "crocs":
		return get_prefix("bluewhale")
	elif char_id == "endless war":
		return get_prefix("endlesswar")
	elif char_id == "9/11":
		return get_prefix("911")
	elif char_id == "adelram":
		return get_prefix("cerise")
	elif char_id == "brunswick":
		return get_prefix("sophia")
	elif char_id == "coltcorona":
		return get_prefix("colt")
	elif char_id == "interlopers":
		return get_prefix("indigointerlopers")
	elif char_id == "lordofghosts" or char_id == "vincent" or char_id == "brunswick" or char_id == "magda":
		return get_prefix("sophia")
	elif char_id == "uwupedy":
		return get_prefix("endlesswar")
	elif char_id == "mumkeyjones":
		return get_prefix("mumkey")
	elif char_id == "hussiefox":
		return get_prefix("v")
	elif char_id == "god" or char_id == "artsofartso":
		return "res://images/UI/Text box/artsofartso/artsofartso_"
	elif char_id == "jesse" or char_id == "thoth":
		return "res://images/UI/Text box/jesse/text box 8 - jesse_"
	elif char_id == "nate" or char_id == "donatello":
		return "res://images/UI/Text box/nate/text box 7 - nate_"
	elif char_id == "mage":
		return "res://images/UI/Text box/mage/text box 4 - mage_"
	elif char_id == "gibbon" or char_id == "voicefromdownstairs":
		return "res://images/UI/Text box/gibbon/text box 6 - gibbon_"
	elif char_id == "davoo" or char_id == "davoocollective":
		return "res://images/UI/Text box/davoo/text box 5 - davoo_"
	elif char_id == "copkillers" or char_id == "ephraim" or char_id == "k1p" or char_id == "magicks" or char_id == "smearg" or char_id == "schrafft":
		return get_prefix("magicksrampage") 
	elif char_id == "ben":
		return "res://images/UI/Text box/ben/text box 9 - ben_"
	elif char_id == "munchy" or char_id == "connor":
		return "res://images/UI/Text box/munchy/text box 3 - munchy_"
	else:
		return "res://images/UI/Text box/" + char_id + "/textbox_" + char_id + "_"
		
#Unused ATM
func load_all_characters_frames(character):
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

func get_texture_path(num, prefix):
	var num_text = str(num)
	while num_text.length() < 3:
		num_text = "0"+num_text
	return prefix+num_text+".png"
		
func load_single_frame(parent, num, prefix):
	var texture = load(get_texture_path(num, prefix))
	var spr = Sprite.new()
	spr.texture = texture
	spr.name = "frame_" + str(num)
	spr.centered = false
	spr.position.x = 300
	spr.position.y = -100
	parent.add_child(spr)
	
func load_single_frame_into_sprite(sprite, num, prefix):
	var texture = load(get_texture_path(num, prefix))
	if texture == null:
		prints(num)
	sprite.texture = texture
	sprite.name = "frame_" + str(num)
	
func swap_character(character):
	current_char = character
	#Just wait until next frame!
	#load_single_frame_into_sprite(sprite, cur_frame, get_prefix(character))
	
#Unused ATM
func swap_character_load_all(character):
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
	
func show_frame():
	if current_char != null:
		load_single_frame_into_sprite(sprite, cur_frame, get_prefix(current_char))
		
	
func queue_load(character):
	#character_load_queue.append(character)
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if timer >= FRAME_TIME:
		while timer > FRAME_TIME:
			cur_frame = (cur_frame+1)%105
			timer -= FRAME_TIME
		if (current_char == "gibbon" and cur_frame == 49) or (current_char == "ben" and cur_frame == 93):
			cur_frame += 1
		show_frame()
	timer += delta
	
	if modulate.a >= 0.001 and not target_visibility:
		modulate.a = lerp(modulate.a, 0.0, delta*3.0)
	if modulate.a <= 0.999 and target_visibility:
		modulate.a = lerp(modulate.a, 1.0, delta*3.0)
		
func make_visible():
	target_visibility = true
	
func make_invisible():
	target_visibility = false
