extends Sprite

signal intro_finished
signal outro_finished

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

func menu_in():
	cur_track = Track.In
	frame_num = 0
	texture = null
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if timer >= FRAME_TIME:
		while timer >= FRAME_TIME:
			frame_num = (frame_num+1)
			timer -= FRAME_TIME
			
		match cur_track:
			Track.In:
				if frame_num >= 18:
					emit_signal("intro_finished")
					cur_track = Track.Idle
					frame_num = 0
			Track.Out:
				if frame_num >= 18:
					emit_signal("outro_finished")
					frame_num = 0
			Track.Idle:
				frame_num = frame_num%62
		var path = "res://images/UI/In-game menus/Settings menu/"
		var num_offset = 0
		#Done seperately so the above match can change tracks
		match cur_track:
			Track.In:
				path += "In/Main_"
			Track.Out:
				#for node in $"../NewButtons".get_children():
				#	node.visible = false
				path += "Out/Main_"
			Track.Idle:
				num_offset = 18
				path += "Loop/Main_"
		var num_text = str(frame_num+num_offset)
		while num_text.length() < 5:
			num_text = "0"+num_text
		texture = load(path + num_text + ".png")
	timer += delta
