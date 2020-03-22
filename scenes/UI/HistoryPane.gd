extends Control

onready var label = $RichTextLabel

var lines = PoolStringArray()

func _ready():
	label.bbcode_text = "--- BEGINNING OF HISTORY ---"
	label.add_font_override("normal_font", global.defaultFont)
	label.add_font_override("bold_font", global.defaultFontBold)
	label.add_font_override("italics_font", global.defaultFontItalic)
	label.add_font_override("bold_italics_font", global.defaultFontBoldItalic)

func add_line(text, speaker):
	var new_history_line = ""
	if speaker:
		new_history_line += "(" + speaker + ") "
	if text != null: #This happened to me once?
		new_history_line += text.replace("/n", "")
		
	lines.append(new_history_line)
	
	while lines.size() > 100:
		lines.remove(0)
	
	label.bbcode_text = lines.join("\n")

func _process(delta):
	if game.blockInput:
		return
	if Input.is_action_just_pressed("ui_toggle_history"):
		_toggle_history_visible()

func _toggle_history_visible():
	if visible:
		hide()
		global.pause_input = false
	else:
		show()
		global.pause_input = true
