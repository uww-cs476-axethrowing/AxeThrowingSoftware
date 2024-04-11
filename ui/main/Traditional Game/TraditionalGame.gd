extends Node2D
var playerList = PlayerList.global_list
var sbArray = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for index in range(playerList.size()):
		var sbString = "ScoreBoardRow" + str(index + 1)
		var current = get_node(sbString)
		current.show()
		sbArray.append(current)
		current.get_child(0).set_text(playerList[index])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
