extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	get_window().content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
