extends RichTextLabel

var counter = 0
var max_count = 1
#var textArray = [""]
signal has_been_read

func _input(event):
	
	if event.is_pressed():
		if get_visible_characters() > get_total_character_count():
			#set_visible_characters(0)
			#this was actually unnecessary. 
			#set_bbcode(textArray[counter])
			
			emit_signal("has_been_read")
		else:
			set_visible_characters(get_total_character_count())

func say(text):
	#I'm going to just make this read out one string
	
	counter = 0
	set_visible_characters(0)
#	max_count = text.size()-1
#	textArray = text
	set_bbcode(text)
	
	return


func _on_Timer_timeout():
	set_visible_characters(get_visible_characters()+1) # Replace with function body.
