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

var old_frames = {}

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
	if not visible:
		return
	if timer >= FRAME_TIME:
		while timer >= FRAME_TIME:
			frame_num = (frame_num+1)
			timer -= FRAME_TIME
			
		match cur_track:
			Track.In:
				if frame_num >= 11:
					emit_signal("intro_finished")
					cur_track = Track.Idle
					frame_num = 0
			Track.Out:
				if frame_num >= 11:
					emit_signal("outro_finished")
					frame_num = 0
			Track.Idle:
				frame_num = frame_num%449
		var path = "res://images/UI/In-game menus/Pause menu/"
		var num_offset = 0
		var min_digits = 0
		#Done seperately so the above match can change tracks
		match cur_track:
			Track.In:
				path += "Intro/intro "
			Track.Out:
				#for node in $"../NewButtons".get_children():
				#	node.visible = false
				path += "Outro/"
			Track.Idle:
				num_offset = 13
				min_digits = 5
				path += "Loop/pause menu exporter_"
				
		var num_text = str(frame_num+num_offset)
		while num_text.length() < min_digits:
			num_text = "0"+num_text
		texture = load(path + num_text + ".png")
		old_frames[texture.resource_path] = texture
	timer += delta
