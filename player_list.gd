extends Node
var global_list = []
var currentPlayer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	global_list.append("Player 1")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_List(list):
	global_list = list

func set_current_player(current):
	currentPlayer = current
