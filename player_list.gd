extends Node
var global_list = []

# Called when the node enters the scene tree for the first time.
func _ready():
	global_list.append("Player 1")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_List(list):
	global_list = list
