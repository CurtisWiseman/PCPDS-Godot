extends Camera2D

var shakeTimer = Timer.new()
var waitTimer = Timer.new()
var posX = 1920/2
var posY = 1080/2
var finishMovment = false
var lastOffset
var lastZoom

signal movement_finished
signal camera_movment_finished

# Function to ready the camera.
func _ready():
	set_drag_margin(drag_margin_top, 0)
	set_drag_margin(drag_margin_bottom, 0)
	set_drag_margin(drag_margin_left, 0)
	set_drag_margin(drag_margin_right, 0)
	lastOffset = Vector2(posX, posY)
	lastZoom = Vector2(1,1)
	offset = lastOffset
	current = true
	
	waitTimer.wait_time = 0.01
	waitTimer.autostart = false
	waitTimer.one_shot = true
	add_child(waitTimer)
	
	shakeTimer.autostart = false
	shakeTimer.one_shot = true
	add_child(shakeTimer)



# Zoom to a given percent on a given point at a given speed from the current zoom.
# The given position will be the center of the zoom, not the left/top sides.
# Negative values for percent will zoom into the picture, flip it, and zoom back out to the given percent.
func zoom(percent:int=100, x:int=offset.x, y:int=offset.y, speed:float=0.5):
	if global.cameraMoving or compare(percent): return
	global.pause_input = true
	global.cameraMoving = true
	lastZoom = Vector2(percent/100.0, percent/100.0)
	lastOffset = Vector2(x,y)
	
	if speed <= 0:
		print('Invalid value for parameter 4 of systems.camera.zoom()! Must be greater than 0.')
		return
	
	if percent == 0:
		print('Invalid value for parameter 1 of systems.camera.zoom()! Must not equal to 0.')
		return
	
	var zoomBy = zoom.x * 100
	var offsetBy = abs((zoomBy - percent)/speed)
	if offsetBy == 0: return
	offsetBy = Vector2((offset.x - x)/offsetBy, (offset.y - y)/offsetBy)
	var Offset = offset
	
	if percent < zoomBy:
		while zoomBy > percent and !finishMovment:
			if zoomBy - speed > percent: zoomBy -= speed
			else: zoomBy = percent
			Offset = Offset - offsetBy
			zoom = Vector2(zoomBy/100.0, zoomBy/100.0)
			offset = Offset
			waitTimer.start()
			yield(waitTimer, 'timeout')
	elif percent > zoomBy:
		while zoomBy < percent and !finishMovment:
			if zoomBy + speed < percent: zoomBy += speed
			else: zoomBy = percent
			Offset = Offset - offsetBy
			zoom = Vector2(zoomBy/100.0, zoomBy/100.0)
			offset = Offset
			waitTimer.start()
			yield(waitTimer, 'timeout')
	
	offset = Vector2(x,y)
	global.cameraMoving = false
	global.pause_input = false
	emit_signal('movement_finished')



# Function to pan from current camera position to a given position.
# The given position will be the center of the pan, not the left/top sides.
func pan(x:int=posX, y:int=posY, numOfTimes:int=100):
	var goal = Vector2(x,y)
	if global.cameraMoving or offset == goal: return
	global.pause_input = true
	global.cameraMoving = true
	lastOffset = Vector2(x,y)
	
	if numOfTimes < 1:
		print('Invalid value for parameter 3 of systems.camera.pan()! Must be greater than 0.')
		return
	
	var offsetBy = Vector2((x - offset.x)/numOfTimes, (y - offset.y)/numOfTimes)
	var Offset = offset
	
	if offset.x <= goal.x and offset.y <= goal.y:
		while offset <= goal and !finishMovment:
			if goal < Offset: break
			offset = Offset
			Offset = Offset + offsetBy
			waitTimer.start()
			yield(waitTimer, 'timeout')
	elif offset.x >= goal.x and offset.y <= goal.y:
		while offset.x >= goal.x and offset.y <= goal.y and !finishMovment:
			if goal.x > Offset.x or goal.y < offset.y: break
			offset = Offset
			Offset = Offset + offsetBy
			waitTimer.start()
			yield(waitTimer, 'timeout')
	elif offset.x <= goal.x and offset.y >= goal.y:
		while offset.x <= goal.x and offset.y >= goal.y and !finishMovment:
			if goal.x < Offset.x or goal.y > offset.y: break
			offset = Offset
			Offset = Offset + offsetBy
			waitTimer.start()
			yield(waitTimer, 'timeout')
	elif offset.x >= goal.x and offset.y >= goal.y:
		while offset >= goal and !finishMovment:
			if goal > Offset: break
			offset = Offset
			Offset = Offset + offsetBy
			waitTimer.start()
			yield(waitTimer, 'timeout')
	
	offset = goal
	global.cameraMoving = false
	global.pause_input = false
	emit_signal('movement_finished')



# Function to randomly shake the screen by a given shake ammount for a given amount of time in the given direction(s).
func shake(shake:int=3, direction='all', time:float=0.3):
	if global.cameraMoving: return
	global.pause_input = true
	global.cameraMoving = true
	var ogOffset = offset
	
	if time <= 0:
		print('Invalid value for parameter 3 of systems.camera.shake()! Must be greater than 0.')
		return
	
	shakeTimer.wait_time = time
	shakeTimer.start()
	
	if direction == 'all':
		while !shakeTimer.is_stopped() and !finishMovment:
			offset = offset + Vector2(rand_range(-1.0, 1.0) * shake, rand_range(-1.0, 1.0) * shake)
			waitTimer.start()
			yield(waitTimer, 'timeout')
			offset = ogOffset
			waitTimer.start()
			yield(waitTimer, 'timeout')
	elif direction == 'vertical':
		while !shakeTimer.is_stopped() and !finishMovment:
			offset.y = offset.y + rand_range(-1.0, 1.0) * shake
			waitTimer.start()
			yield(waitTimer, 'timeout')
			offset.y = ogOffset.y
			waitTimer.start()
			yield(waitTimer, 'timeout')
	elif direction == 'horizontal':
		while !shakeTimer.is_stopped() and !finishMovment:
			offset.x = offset.x + rand_range(-1.0, 1.0) * shake
			waitTimer.start()
			yield(waitTimer, 'timeout')
			offset.x = ogOffset.x
			waitTimer.start()
			yield(waitTimer, 'timeout')
	else:
		print('Invalid value for parameter 2 of systems.camera.shake()! Must be "all", "vertical", or "horizontal" only.')
	
	finishMovment = false
	offset = ogOffset
	global.pause_input = false
	global.cameraMoving = false
	emit_signal('movement_finished')



# Run the following boolean calulation.
func compare(percent): return (zoom.x-(percent/100.0)) <= 0.00001



# Function to end camera movment.
func finishCameraMovment():
	finishMovment = true
	waitTimer.wait_time = 0.1
	waitTimer.start()
	yield(waitTimer, 'timeout')
	waitTimer.wait_time = 0.01
	finishMovment = false
	global.cameraMoving = false
	emit_signal('camera_movment_finished')