extends Control

signal closed

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
	$close.visible = false
	yield($background, "intro_finished")
	$close.visible = true
	$master_volume.visible = true
	$music_volume.visible = true
	$sfx_volume.visible = true
	
func menu_out():
	$master_volume.visible = false
	$music_volume.visible = false
	$sfx_volume.visible = false
	$background.menu_out()
	$close.visible = false
	yield($background, "outro_finished")
	emit_signal("closed")
	visible = false
