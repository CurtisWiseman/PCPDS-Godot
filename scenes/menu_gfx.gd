extends Sprite

signal intro_finished
signal outro_finished

#so they don't get ARC'd
var old_frames = {}

enum Track {
	In,
	Out,
	Idle
}
var cur_track = Track.In
var frame_num = 0

const FRAME_TIME = 1.0/30.0
var timer = 0.0

#
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func menu_out():
	cur_track = Track.Out
	frame_num = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if timer >= FRAME_TIME:
		while timer >= FRAME_TIME:
			frame_num = (frame_num+1)
			timer -= FRAME_TIME
			
		match cur_track:
			Track.In:
				if frame_num >= 73:
					emit_signal("intro_finished")
					cur_track = Track.Idle
					frame_num = 0
			Track.Out:
				if frame_num >= 73:
					emit_signal("outro_finished")
					frame_num = 72
			Track.Idle:
				frame_num = frame_num%77
		var path = "res://images/UI/Title screen/"
		var num_offset = 0
		#Done seperately so the above match can change tracks
		match cur_track:
			Track.In:
				path += "Title in with buttons/Title_in_withbuttons_"
			Track.Out:
				for node in $"../NewButtons".get_children():
					node.visible = false
				path += "Title out with buttons/Title_out_withbuttons_"
			Track.Idle:
				num_offset = 73
				path += "Title idle/Title_idle_"
		var num_text = str(frame_num+num_offset)
		while num_text.length() < 3:
			num_text = "0"+num_text
		var ticks = OS.get_ticks_msec()
		texture = load(path + num_text + ".png")
		old_frames[texture.resource_path] = texture
	timer += delta
