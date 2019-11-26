extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	$CenterContainer/Pause_Buttons/Save.grab_focus()

func _physics_prcoess(delta):
	if $CenterContainer/Pause_Buttons/Backlog.is_hovered() == true:
		$CenterContainer/Pause_Buttons/Backlog.grab_focus()
	if $CenterContainer/Pause_Buttons/Quit.is_hovered() == true:
		$CenterContainer/Pause_Buttons/Quit.grab_focus()
	if $CenterContainer/Pause_Buttons/Load.is_hovered() == true:
		$CenterContainer/Pause_Buttons/Load.grab_focus()

func _input(event):
	if event.is_action_pressed("pause"): #Originally, this was using ui_cancel. I created my own input_map type in Project Settings -> Input Map
		$CenterContainer/Pause_Buttons/Save.grab_focus() #It is linked to the Escape key and the Start button on controllers
		get_tree().paused = not get_tree().paused
		visible = not visible

func _on_Save_pressed():
	pass # Will evantually open the save system

func _on_Load_pressed():
	pass # Will evantually open the load system

func _on_Backlog_pressed():
	pass # Will evantually open the backlog system

func _on_Quit_pressed():
	$CenterContainer/Pause_Buttons/Quit/Quit_Confirmation.popup_centered()

func _on_Quit_Confirmation_confirmed():
	get_tree().quit()

func _on_History_pressed():
	pass # Replace with function body.
