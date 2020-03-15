extends Control

signal intro_finished
signal outro_finished

# Called when the node enters the scene tree for the first time.
func _ready():
	$voices_button/cross.visible = global.voicesOn


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func menu_in():
	$voices_button/cross.visible = global.voicesOn
	$master_volume.visible = false
	$music_volume.visible = false
	$sfx_volume.visible = false
	$voices_button.visible = false
	$background.menu_in()
	visible = true
	$close_button.visible = false
	yield($background, "intro_finished")
	$close_button.visible = true
	$master_volume.visible = true
	$music_volume.visible = true
	$sfx_volume.visible = true
	$voices_button.visible = true
	emit_signal("intro_finished")
	
func menu_out():
	$background.menu_out()
	yield($background, "frame_changed")
	$master_volume.visible = false
	$music_volume.visible = false
	$sfx_volume.visible = false
	$close_button.visible = false
	$voices_button.visible = false
	yield($background, "outro_finished")
	emit_signal("outro_finished")
	visible = false


func _on_voices_button_pressed():
	global.voicesOn = not global.voicesOn
	$voices_button/cross.visible = global.voicesOn
