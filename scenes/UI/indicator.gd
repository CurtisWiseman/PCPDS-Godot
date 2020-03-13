extends Sprite

signal intro_finished
signal outro_finished

enum Track {
	Finished,
	Speaking
}

#So they don't get ARC'd
var old_frames = {}

export var cur_track = Track.Finished
var frame_num = -1

const FRAME_TIME = 1.0/30.0
var timer = 0.0

#
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func speaking():
	if cur_track != Track.Speaking:
		cur_track = Track.Speaking
		frame_num = -1

func finished():
	if cur_track != Track.Finished:
		cur_track = Track.Finished
		frame_num = -1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not is_visible_in_tree() and frame_num != -1:
		return
	if timer >= FRAME_TIME:
		while timer >= FRAME_TIME:
			frame_num = (frame_num+1)
			timer -= FRAME_TIME
			
		var path = "res://images/UI/Text box/Text box scrawl"
		var num_offset = 0
		#Done seperately so the above match can change tracks
		match cur_track:
			Track.Finished:
				frame_num = frame_num%59
				num_offset = 18
				path += "finish/Comp 2_"
			Track.Speaking:
				frame_num = frame_num%53
				path += "/Dots_"
		
		var num_text = str(frame_num+num_offset)
		while num_text.length() < 5:
			num_text = "0"+num_text
		texture = load(path + num_text + ".png")
		if texture != null:
			old_frames[texture.resource_path] = texture
		emit_signal("frame_changed")
	timer += delta
