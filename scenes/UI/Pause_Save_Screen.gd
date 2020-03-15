extends Control

signal intro_finished
signal outro_finished

var listOfSaves = []
var listOfImages = []
var currentPage = 1
var numOfPages = 0
var PauseScreen

export var loads_instead_of_saves = false

var current_selected_button = null

# Function to display saves and connect node signals.
func _ready():
	loadSaveGames()
	
	for page in $"Save Pages".get_children():
		numOfPages += 1
		for node in page.get_children():
			node.connect('pressed', self, '_on_LoadBox_pressed', [node])
	
	for button in $"Page Buttons".get_children():
		button.connect('pressed', self, '_on_PageButton_pressed', [button])
		
	current_selected_button = $"Page Buttons".get_child(0)
	var tmp = current_selected_button.texture_normal
	current_selected_button.texture_normal = current_selected_button.texture_disabled
	current_selected_button.texture_disabled = tmp
	
	connect("visibility_changed", self , "visible_changed")

func menu_in():
	$"Save Pages".visible = false
	$"Page Buttons".visible = false
	$close_button.visible = false
	$background.menu_in()
	yield($background, "frame_changed")
	visible = true
	yield($background, "intro_finished")
	$"Save Pages".visible = true
	$"Page Buttons".visible = true
	$close_button.visible = true
	emit_signal("intro_finished")
	
func menu_out():
	$background.menu_out()
	$"Save Pages".visible = false
	$"Page Buttons".visible = false
	$close_button.visible = false
	yield($background, "outro_finished")
	visible = false
	emit_signal("outro_finished")
	
func _process(delta):
	for page in $"Save Pages".get_children():
		for button in page.get_children():
			button.get_node("hover").visible = button.is_hovered()
			
func visible_changed():
	var mod
	if not loads_instead_of_saves and ((global.pause_input and not global.dialogueBox.displayingChoices) or not game.safeToSave):
		mod = Color(0.1, 0.1, 0.1, 1.0)
	else:
		mod = Color(1.0, 1.0, 1.0, 1.0)
	for page in $"Save Pages".get_children():
		for node in page.get_children():
			node.modulate = mod
	
# Function to congregate loading functions.
func loadSaveGames():
	loadSaves()
	displaySaves()



# Displays the gathered saves on their corresponding SaveBox.
func displaySaves():
	
	var file = File.new()
	
	for save in listOfSaves:
		#file.open_encrypted_with_pass(game.SAVE_FOLDER + '/' + save, File.READ, 'G@Y&D3@D')
		var saveName = save.substr(0, save.length() - 5)
		var saveImage = null
		var box
		
		for image in listOfImages:
			if saveName.is_subsequence_of(image):
				saveImage = image
				break
		
		for page in $"Save Pages".get_children():
			var pageNum = int(page.name.right(1))
			for node in page.get_children():
				var saveInPageNum = int(node.name.right(1))
				var saveNum = (pageNum-1)*6+saveInPageNum
				if saveName == "save" + str(saveNum):
					box = node.get_node("gfx")
				
		if saveImage and box != null:
			var img = Image.new()
			var texture = ImageTexture.new()
			img.load(game.SAVE_FOLDER + '/' + saveImage)
			texture.create_from_image(img)
			box.texture = texture
			box.scale.x = 390.0/texture.get_width()
			box.scale.y = 217.0/texture.get_height()
			box.position = Vector2(14, 16)
		else:
			box.texture = null
		
		file.close()



# Gathers existing saves and their related images.
func loadSaves():
	
	listOfSaves = []
	listOfImages = []
	var directory = Directory.new()
	
	if !directory.dir_exists(game.SAVE_FOLDER):
		directory.make_dir(game.SAVE_FOLDER)
	
	directory.open(game.SAVE_FOLDER)
	directory.list_dir_begin(true)
		
	while true:
		var file = directory.get_next()
		
		if directory.file_exists(file):
			if file.match('save*.tres'):
				listOfSaves.append(file)
			elif file.match('save*.png'):
				listOfImages.append(file)
		elif file == '':
			break



# Function to make a new save and link it to the clicked box.
func _on_LoadBox_pressed(saveBox):
	var pageNum = int(saveBox.get_parent().name.right(1))
	var saveBoxNum = (pageNum-1)*6+int(saveBox.name.right(1))
	
	if loads_instead_of_saves:
		var saveFile = 'save' + str(saveBoxNum) + '.tres'
		for save in listOfSaves:
			if save == saveFile:
				game.newLoad(saveFile)
				if get_tree().paused:
					global.toggle_pause()
				break
	elif (not global.pause_input or global.dialogueBox.displayingChoices) and game.safeToSave:
		PauseScreen.visible = false
		
		global.pause_input = true
			
		# Stop any sliding characters.
		var display = global.rootnode.get_node('Systems/Display')
		#var sliders = []
		#var still_sliders = false
		#while global.sliding or still_sliders:
		#	#get_tree().paused = false
		#	still_sliders = false
		#	for child in display.get_children():
		#		if child.name.match("*(*P*o*s*i*t*i*o*n*)*"):
		#			sliders.append(child.finish())
		#			still_sliders = true
		#	global.sliding = false
		#	#get_tree().paused = true
		#	var ogTime = $Wait.wait_time
		#	$Wait.wait_time = 1
		#	$Wait.start()
		#	yield($Wait, 'timeout')
		#	$Wait.wait_time = ogTime
		# Stop camera movment if it is moving
		#if global.cameraMoving:
		#	var camera = global.rootnode.get_node('Systems/Camera')
		#	global.pause_input = true
		#	get_tree().paused = false
		#	camera.finishCameraMovment()
		#	yield(camera, 'camera_movment_finished')
		#	camera.zoom = camera.lastZoom
		#	camera.offset = camera.lastOffset
		#	get_tree().paused = true
		#	global.pause_input = false
		
		# Stop any fading if it is happening
		#while global.fading or display.faders.size() > 0:
		#	#get_tree().paused = false
		#	global.finish_fading()
		#	var ogTime = $Wait.wait_time
		#	$Wait.wait_time = 1
		#	$Wait.start()
		#	yield($Wait, 'timeout')
		#	$Wait.wait_time = ogTime
		#	#get_tree().paused = true
		
		$Wait.start()
		yield($Wait, 'timeout')
		
		
		game.newSave(saveBoxNum)
		loadSaveGames()
		PauseScreen.reloadLoad = true
		global.pause_input = false
		PauseScreen.visible = true

# Goes to the page left of the current if it exists.
func _on_LeftPage_pressed():
	if currentPage > 1:
		get_node('Save Pages/Page' + str(currentPage)).visible = false
		currentPage -= 1
		get_node('Save Pages/Page' + str(currentPage)).visible = true

# Goes to the page right of the current if it exists.
func _on_RightPage_pressed():
	if currentPage < numOfPages:
		get_node('Save Pages/Page' + str(currentPage)).visible = false
		currentPage += 1
		get_node('Save Pages/Page' + str(currentPage)).visible = true

func change_texture(button):
	var deltah = button.texture_disabled.get_height()-button.texture_normal.get_height()
	var deltaw = button.texture_disabled.get_width()-button.texture_normal.get_width()
	button.rect_position -= Vector2(deltah*0.5, deltaw*0.5)
	var tmp = button.texture_normal
	button.texture_normal = button.texture_disabled
	button.texture_disabled = tmp

# Goes to the page specified by the selected button.
func _on_PageButton_pressed(button):
	change_texture(current_selected_button)
	
	get_node('Save Pages/Page' + str(currentPage)).visible = false
	currentPage = int(button.name.right(1))
	get_node('Save Pages/Page' + str(currentPage)).visible = true
	current_selected_button = button
	change_texture(current_selected_button)
