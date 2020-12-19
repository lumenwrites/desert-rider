extends TouchScreenButton

var radius = Vector2(64,64)

func _ready():
	pass
	
func _input(event):
	return
	if event is InputEventScreenDrag or (event is InputEventScreenTouch and event.is_pressed()):
		set_global_position(event.position - radius/2)
