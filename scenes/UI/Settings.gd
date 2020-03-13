extends Control

signal intro_finished
signal outro_finished

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func menu_in():
	$master_volume.visible = false
	$music_volume.visible = false
	$sfx_volume.visible = false
	$background.menu_in()
	visible = true
	$close_button.visible = false
	yield($background, "intro_finished")
	$close_button.visible = true
	$master_volume.visible = true
	$music_volume.visible = true
	$sfx_volume.visible = true
	emit_signal("intro_finished")
	
func menu_out():
	$background.menu_out()
	yield($background, "frame_changed")
	$master_volume.visible = false
	$music_volume.visible = false
	$sfx_volume.visible = false
	$close_button.visible = false
	yield($background, "outro_finished")
	emit_signal("outro_finished")
	visible = false
