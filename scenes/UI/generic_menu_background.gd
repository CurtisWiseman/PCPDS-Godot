extends Sprite

signal intro_finished
signal outro_finished

enum Track {
	In,
	Out,
	Idle
}

export var base_prefix = "res://images/UI/In-game menus/"
export var idle_prefix = ""
export var in_prefix = ""
export var out_prefix = ""

export var idle_duration = 0
export var in_duration = 0
export var out_duration = 0

export var idle_offset = 0
export var in_offset = 0
export var out_offset = 0

export var idle_digits = 5
export var in_digits = 5
export var out_digits = 5


#So they don't get ARC'd
var old_frames = {}

export var cur_track = Track.Idle
var frame_num = -1

const FRAME_TIME = 1.0/30.0
var timer = 0.0

#
# Called when the node enters the scene tree for the first time.
func _ready():
	texture = null

func menu_in():
	cur_track = Track.In
	frame_num = -1

func menu_out():
	cur_track = Track.Out
	frame_num = -1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not is_visible_in_tree() and frame_num != -1:
		return
	if timer >= FRAME_TIME:
		while timer >= FRAME_TIME:
			frame_num = (frame_num+1)
			timer -= FRAME_TIME
			
		match cur_track:
			Track.In:
				if frame_num >= in_duration:
					emit_signal("intro_finished")
					cur_track = Track.Idle
					frame_num = 0
			Track.Out:
				if frame_num >= out_duration:
					emit_signal("outro_finished")
					frame_num = out_duration
			Track.Idle:
				frame_num = frame_num%idle_duration
		var path = base_prefix
		var num_offset = 0
		var digits = 0
		#Done seperately so the above match can change tracks
		match cur_track:
			Track.In:
				num_offset = in_offset
				digits = in_digits
				path += in_prefix
			Track.Out:
				num_offset = out_offset
				digits = out_digits
				path += out_prefix
			Track.Idle:
				num_offset = idle_offset
				digits = idle_digits
				path += idle_prefix
		
		var num_text = str(frame_num+num_offset)
		while num_text.length() < digits:
			num_text = "0"+num_text
		texture = load(path + num_text + ".png")
		if texture != null:
			old_frames[texture.resource_path] = texture
		emit_signal("frame_changed")
	timer += delta
