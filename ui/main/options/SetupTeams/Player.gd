extends Object

var playerScore = 0
var playerName = ""
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_playerName():
	return playerName

func set_playerName(name):
	playerName = name
