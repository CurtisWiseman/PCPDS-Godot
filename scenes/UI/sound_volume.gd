extends Sprite

export var affected_bus = "Master"

var grabbed = false
var grab_mouse_pt = null
var grab_knob_pt = null
# Called when the node enters the scene tree for the first time.
func _ready():
	var factor = clamp(1.0-(AudioServer.get_bus_volume_db(AudioServer.get_bus_index(affected_bus))/-45.0), 0.0, 1.0)
	$knob.position.x = lerp($min_x.position.x, $knob.position.x, factor)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var p = get_global_mouse_position()
	var knob_box = $knob/hit_area.get_global_rect()
	if Input.is_action_just_pressed("advance_text") and knob_box.has_point(p):
		grabbed = true
		grab_mouse_pt = p
		grab_knob_pt = $knob.position
	if (not Input.is_action_pressed("advance_text")) or not Input.is_action_pressed("advance_text"):
		grabbed = false
	if not visible:
		grabbed = false
	if grabbed:
		var desired_move_pt = Vector2(grab_knob_pt.x+(p-grab_mouse_pt).x, grab_knob_pt.y)
		if desired_move_pt.x < $min_x.position.x:
			desired_move_pt.x = $min_x.position.x
		if desired_move_pt.x > $max_x.position.x:
			desired_move_pt.x = $max_x.position.x
		if desired_move_pt.distance_to($knob.position) > 1:
			var factor = clamp((desired_move_pt.x-$min_x.position.x)/($max_x.position.x-$min_x.position.x), 0.0, 1.0)
			var db
			if factor < 0.01:
				db = -1000
			else:
				db = lerp(-45.0, 0, factor)
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index(affected_bus), db)
		$knob.position = desired_move_pt
