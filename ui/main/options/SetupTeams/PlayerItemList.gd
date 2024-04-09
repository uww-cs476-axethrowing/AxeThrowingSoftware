extends ItemList
var currentPlayer = -1


# Called when the node enters the scene tree for the first time.
func _ready():
	print(PlayerList.global_list)
	for player in PlayerList.global_list:
		self.add_item(str(player))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	currentPlayer = self.get_selected_items()
	
func add_PlayerIL(name):
	self.add_item(name)
	
func get_current():
	return currentPlayer
