extends Node

@export var circle_scene: PackedScene
@export var cross_scene: PackedScene


var player: int
var player_panel_pos: Vector2i
var temp_marker
var grid_data: Array
var grid_pos: Vector2i
var board_size: int
var cell_size: int
var row_sum: int
var col_sum: int
var diagonal1_sum: int
var diagonal2_sum: int
var winner: int
var moves: int

# Called when the node enters the scene tree for the first time.
func _ready():
	board_size = $Board.texture.get_width()
	cell_size = board_size/3
	#panel coordinates
	player_panel_pos = $PlayerPanel.get_position()
	new_game()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			#checks if mouse is on game board
			if event.position.x < board_size:
				#convert mouse pos into grid location
				grid_pos = Vector2i(event.position / cell_size)
				
				if grid_data[grid_pos.y][grid_pos.x] == 0:
					grid_data[grid_pos.y][grid_pos.x] = player
					create_marker(player, grid_pos * cell_size + Vector2i(cell_size / 2, cell_size / 2))
					if(check_win() != 0):
						get_tree().paused = true # stops game
						#####################call end screen with winner
					elif moves ==9:
						get_tree().paused = true
						#####################call end screen with winner
					player *= -1 # changes player
					#panel marker
					temp_marker.queue_free()
					create_marker(player, player_panel_pos + Vector2i(cell_size / 2, cell_size / 2), true)
					##print(grid_data)

func new_game():
	player = 1
	winner = 0
	grid_data = [
		[0,0,0],
		[0,0,0],
		[0,0,0]
		]
		#marker for starting player
	
	create_marker(player, player_panel_pos + Vector2i(cell_size / 2, cell_size / 2), true)

func create_marker(player, position, temp = false):
	#create marker node and add as a child
	if player == 1:
		var circle = circle_scene.instantiate()
		circle.position = position
		add_child(circle)
		if temp: temp_marker = circle
	else:
		var cross = cross_scene.instantiate()
		cross.position = position
		add_child(cross)
		if temp: temp_marker = cross

func check_win(): # adds markers for row col and diags
	for i in len(grid_data):
		row_sum = grid_data[i][0] + grid_data[i][1] + grid_data[i][2]
		col_sum = grid_data[0][i] + grid_data[1][i] + grid_data[2][i]
		diagonal1_sum = grid_data[0][0] + grid_data[1][1] + grid_data[2][2]
		diagonal2_sum = grid_data[0][2] + grid_data[1][1] + grid_data[2][0]
	
		#checks if equal to 3 or -3
		if row_sum == 3 or col_sum == 3 or diagonal1_sum == 3 or diagonal2_sum == 3:
			winner = 1
		elif row_sum == -3 or col_sum == -3 or diagonal1_sum == -3 or diagonal2_sum == -3:
			winner = -1
	return winner
	
