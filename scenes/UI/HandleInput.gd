extends LineEdit

signal return_signal

var node = null;
var regex = null;
var placeholder = null;
var position = null;
var blink = false;

func _ready():
	
	self.add_font_override("normal_font", global.defaultFont)
	
	if node == null:
		print('Must provide calling node for input handling.')
		queue_free()
	
	grab_focus()
	if position != null: self.rect_position = position
	if placeholder != null: placeholder_text = placeholder
	if blink: caret_blink = true;

func _input(event):
	if Input.is_key_pressed(KEY_ENTER) and text != "":
		if regex != null:
			if (text.match(regex)):
				emit_signal("return_signal", text, true)
			else:
				emit_signal("return_signal", text, false)
		else:
			emit_signal("return_signal", text, true)