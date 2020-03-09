extends Control

var listOfSaves = []
var listOfImages = []
var currentPage = 1
var numOfPages = 0


# Function to display saves and connect node signals.
func _ready():
	loadSaveGames()
	
	for page in $"Save Pages".get_children():
		numOfPages += 1
		for node in page.get_children():
			node.connect('pressed', self, '_on_LoadBox_pressed', [node.name])
	
	for button in $"Page Buttons".get_children():
		button.connect('pressed', self, '_on_PageButton_pressed', [button.name])



# Function to congregate loading functions.
func loadSaveGames():
	loadSaves()
	displaySaves()



# Displays the gathered saves on their corresponding SaveBox.
func displaySaves():
	
	# Clean slate.
	for page in $"Save Pages".get_children():
		for node in page.get_children():
			node.texture_normal = load('res://images/loadscreen/empty_tile.png')
			node.texture_hover = load('res://images/loadscreen/empty_tile_hovered.png')
	
	var file = File.new()
	
	for save in listOfSaves:
		file.open_encrypted_with_pass('user://saves/' + save, File.READ, 'G@Y&D3@D')
		var saveName = save.substr(0, save.length() - 5)
		var saveImage = null
		var box
		
		for image in listOfImages:
			if saveName.is_subsequence_of(image):
				saveImage = image
				break
		
		for page in $"Save Pages".get_children():
			for node in page.get_children():
				if saveName == "save" + node.name.substr(7):
					box = node
		
		if saveImage:
			var img = Image.new()
			var texture = ImageTexture.new()
			img.load('user://saves/' + saveImage)
			texture.create_from_image(img)
			box.texture_normal = texture
			box.texture_hover = null
		else:
			box.texture_normal = load('res://images/loadscreen/empty_tile_no_image.png')
			box.texture_hover = load('res://images/loadscreen/empty_tile_hovered_no_image.png')
		
		var delName = box.name + 'DeleteSave'
		if box.get_node(delName): box.remove_child(box.get_node(delName))
		
		var deleteSave = TextureButton.new()
		deleteSave.name = delName
		deleteSave.rect_scale = Vector2(4, 4)
		deleteSave.texture_normal = load('res://images/loadscreen/x.png')
		deleteSave.connect("pressed", self, "_deleteSave", [box, deleteSave])
		box.add_child(deleteSave)
		
		file.close()



# Gathers existing saves and their related images.
func loadSaves():
	
	listOfSaves = []
	listOfImages = []
	var directory = Directory.new()
	
	if !directory.dir_exists("user://saves"):
		directory.make_dir("user://saves")
	
	directory.open("user://saves")
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
func _on_LoadBox_pressed(saveBoxName):
	var saveFile = saveBoxName.substr(7, saveBoxName.length())
	saveFile = 'save' + saveFile + '.tres'
	
	for save in listOfSaves:
		if save == saveFile:
			get_tree().paused = true
			game.newLoad(saveFile)
			hide()
			get_tree().paused = false
			break



# Function to delete a save.
func _deleteSave(saveBox, deleteSaveButton):
	var saveBoxName = saveBox.name
	var saveNum = saveBoxName.substr(7, saveBoxName.length())
	var saveName = 'save' + saveNum + '.'
	var directory = Directory.new()
	var saveImage = false
	
	for image in listOfImages:
		if saveName.is_subsequence_of(image):
			saveImage = true
			break
	
	if saveImage: directory.remove('user://saves/' + saveName + 'png')
	directory.remove('user://saves/' + saveName + 'tres')
	
	saveBox.texture_normal = load('res://images/loadscreen/empty_tile.png')
	saveBox.texture_hover = load('res://images/loadscreen/empty_tile_hovered.png')
	deleteSaveButton.queue_free()
#	PauseScreen.reloadLoad = true
	loadSaveGames()



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

# Goes to the page specified by the selected button.
func _on_PageButton_pressed(buttonName):
	get_node('Save Pages/Page' + str(currentPage)).visible = false
	currentPage = int(buttonName.substr(5, buttonName.length()))
	get_node('Save Pages/Page' + str(currentPage)).visible = true
