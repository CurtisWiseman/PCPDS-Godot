extends LineEdit

signal return_signal

var node = null;
var regex = null;
var placeholder = null;
var position = null;
var blink = false;


func _ready():
	connect("text_changed", self, "_sanitize_name")
	
	self.add_font_override("normal_font", global.defaultFont)
	
	if node == null:
		print('Must provide calling node for input handling.')
		queue_free()
	
	grab_focus()
	if position != null: self.rect_position = position
	if placeholder != null: placeholder_text = placeholder
	if blink: caret_blink = true;

func _sanitize_name(new_text):
	var res = ""
	var cursor_pos = caret_position
	for c in text.lstrip(" "):
		var char_code = c.ord_at(0)
		if c.is_valid_integer() or ('a'.ord_at(0) <= char_code and char_code <= 'z'.ord_at(0)) or ('A'.ord_at(0) <= char_code and char_code <= 'Z'.ord_at(0)) or c == " ":
			res += c
	text = res
	caret_position = min(cursor_pos, text.length())
	
func _input(event):
	if Input.is_key_pressed(KEY_ENTER) and text != "":
		if regex != null:
			if (text.match(regex)):
				emit_signal("return_signal", text, true)
			else:
				emit_signal("return_signal", text, false)
		else:
			emit_signal("return_signal", text, true)
