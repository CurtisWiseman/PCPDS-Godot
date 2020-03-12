extends Sprite

signal click_finish
export var button_num = 1

enum Track {
	Hover,
	Unhover,
	Idle,
	Click,
	Selected
}
var cur_track = Track.Idle
var frame_num = -1

const FRAME_TIME = 1.0/30.0
var timer = 0.0

#To stop them getting ARC'd
var old_frames = {}

#
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func click():
	cur_track = Track.Click
	frame_num = -1
	
func clicking():
	return cur_track == Track.Click

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not is_visible_in_tree() and frame_num != -1:
		return
	var mouse_p = get_global_mouse_position()
	if not get_parent().get_parent().input_locked:
		if Rect2(global_position-get_rect().size*0.5, get_rect().size).has_point(mouse_p):
			if Input.is_action_just_pressed("advance_text") and not cur_track == Track.Click:
				cur_track = Track.Click
				frame_num = 0
			elif not (cur_track == Track.Hover or cur_track == Track.Selected or cur_track == Track.Click):
				cur_track = Track.Hover
				frame_num = 0
		elif (cur_track == Track.Hover or cur_track == Track.Selected):
			cur_track = Track.Unhover
			frame_num = 0
	
	if timer >= FRAME_TIME:
		while timer >= FRAME_TIME:
			frame_num = frame_num+1
			timer -= FRAME_TIME
		var path = "res://images/UI/Title screen/Title screen button animations/Button" + str(button_num)+"/"
		
		#Done first to allow for track changes
		match cur_track:
			Track.Hover:
				var hover_limit
				match button_num:
					2:
						hover_limit = 50
					4:
						hover_limit = 25
					_:
						hover_limit = 32
				if frame_num >= hover_limit:
					frame_num = 0
					cur_track = Track.Selected
			Track.Unhover:
				var unhover_limit
				match button_num:
					1:
						unhover_limit = 12
					2: 
						unhover_limit = 13
					3:
						unhover_limit = 14
					4:
						unhover_limit = 11
				if frame_num >= unhover_limit:
					cur_track = Track.Idle
					frame_num = 0
			Track.Click:
				var click_limit
				match button_num:
					3:
						click_limit = 11
					2:
						click_limit = 10
					_:
						click_limit = 9
				if frame_num >= click_limit:
					cur_track = Track.Idle
					emit_signal("click_finish")
					frame_num = 0
		
		if cur_track == Track.Idle:
			if texture == null or texture.resource_path != "Menu_Button"+str(button_num)+"_Unselected.png":
				texture = load(path + "Menu_Button"+str(button_num)+"_Unselected.png")
				old_frames[texture.resource_path] = texture
			frame_num = 0
		elif cur_track == Track.Selected:
			if texture == null or texture.resource_path != "Menu_Button"+str(button_num)+"_Selected.png":
				texture = load(path + "Menu_Button"+str(button_num)+"_Selected.png")
				old_frames[texture.resource_path] = texture
			frame_num = 0
		else:
			match cur_track:
				Track.Hover:
					path += "Hover/Menu_Button" + str(button_num) + "_Hover_"
				Track.Unhover:
					path += "Unhover/Menu_Button" + str(button_num) + "_Unhover_"
				Track.Click:
					path += "Click/Menu_Button" + str(button_num) + "_Click_"
			
			var num_text = str(frame_num)
			while num_text.length() < 3:
				num_text = "0"+num_text
				
				
			texture = load(path + num_text + ".png")
			old_frames[texture.resource_path] = texture
	timer += delta
