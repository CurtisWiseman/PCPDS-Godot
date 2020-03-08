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


func zoom(zoom_factor : float, intended_offset : Vector2, speed : float):
	if global.cameraMoving: return
	global.pause_input = true
	global.cameraMoving = true
	var left = -1920.0*0.5
	var right = -left
	var top = -1080.0*0.5
	var bottom = -top
	
	intended_offset = Vector2(right*intended_offset.x, bottom*intended_offset.y)
	
	var start_offset = Vector2(offset.x, offset.y)-Vector2(posX, posY)
	var start_zoom = Vector2(zoom.x, zoom.y)
	var target_zoom = Vector2(zoom_factor, zoom_factor)
	var time = 0.0
	while time < speed:
		zoom = start_zoom.linear_interpolate(target_zoom, time/speed)
		#Clamp the offset so that it doesn't go outside the image
		var cur_left = left*zoom.x 
		var cur_right = right*zoom.x 
		var cur_top = top*zoom.y
		var cur_bottom = bottom*zoom.y 
		
		var offset_this_frame = start_offset.linear_interpolate(intended_offset, time/speed)
		#offset_this_frame.x = clamp(offset_this_frame.x, left-cur_left, right-cur_right)
		#offset_this_frame.y = clamp(offset_this_frame.y, top-cur_top, bottom-cur_bottom)
		offset = offset_this_frame+Vector2(posX, posY)
		waitTimer.start()
		yield(waitTimer, 'timeout')
		time += waitTimer.wait_time
	
	#offset = Vector2(x,y)
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
