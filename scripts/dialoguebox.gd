extends Polygon2D

var dialogue = ["Hello my friends", "How are you?", "Are you well?", "I'm having fun"]
var i = 0

func say(words, character = ""):
	#Nametag is the label above the textbox, dialogue's say is what changes updates the textbox.
	#character is second to make it a default parameter so you can use the function without a character.
	
	get_node("Nametag").text = character
	get_node("Dialogue").say(words)
	

# doing "say("Thing","Character1") say("Other thing","Character2") won't work as it is set up.
# how it works is it reads out the current text, and when the player is done reading, it comes back to this function
#It may be a matter of just having the written script reading out line by line whoever is talking.
func _on_Dialogue_has_been_read():
	if i < dialogue.size():
		say(dialogue[i], "Mage")
		i = i + 1
	
	return
