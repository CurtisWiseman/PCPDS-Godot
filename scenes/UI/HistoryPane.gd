extends Control

onready var popup = $Popup
onready var label = $Popup/RichTextLabel

func _ready():
	label.bbcode_text = "--- BEGINNING OF HISTORY ---"

func add_line(text, speaker):
	var new_history_line = ""
	if speaker:
		new_history_line += "(" + speaker + ") "
	new_history_line += text
	
	label.bbcode_text += "\n" + new_history_line

func _process(delta):
	if game.blockInput:
		return
	if Input.is_action_just_pressed("ui_toggle_history"):
		_toggle_history_visible()

func _toggle_history_visible():
	if popup.visible:
		popup.hide()
		global.pause_input = false
	else:
		popup.popup_centered_ratio()
		global.pause_input = true
