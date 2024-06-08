extends Node2D
var currentPlayer = 1
var X = preload("res://Sprites/Xtictactoe.png")
var O = preload("res://Sprites/Otictactoe.png")
var XGreen = preload("res://Sprites/XGreen.png")
var OGreen = preload("res://Sprites/OGreen.png")
var board = []
var savedBoards = []
var playerTurns = []
var winnerbool = false
@onready var winnerRibbon = get_node("RibbonSprite2D")
var animate = false



# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("OTextureRect").hide()
	board = [
		[0, 0, 0],
		[0, 0, 0],
		[0, 0, 0]
	]
	winnerRibbon.scale = Vector2(0, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if currentPlayer == 1:
		get_node("OTextureRect").hide()
		get_node("XTextureRect").show()
	else:
		get_node("OTextureRect").show()
		get_node("XTextureRect").hide()
	if animate and winnerRibbon.scale < Vector2(.6, .5):
		winnerRibbon.scale.x += .02
		winnerRibbon.scale.y += .02
	else:
		animate = false

func winnerAnimation(winner):
	winnerRibbon.get_child(0).text = winner
	animate = true

func changeButtonTexture(button, player, loc, winnerBool):
	button = get_node(button)
	if !winnerBool:
		if player == 1:
			button.texture_normal = X
			updateBoard(loc[0], loc[1], 1)
		else:
			button.texture_normal = O
			updateBoard(loc[0], loc[1], 2)
	else:
		if player == 1:
			button.texture_normal = XGreen
			updateBoard(loc[0], loc[1], 1)
		else:
			button.texture_normal = OGreen
			updateBoard(loc[0], loc[1], 2)

func checkForWinner():
	var winner = check_winner()
	if winner[0] == 0:
		nextPlayer()
	else:
		winnerbool = true
		for pos in winner[1]:
			changeButtonTexture(location_to_string(pos), winner[0], pos, true)
		winnerAnimation("Player " + str(winner[0]) + " Wins!")

#0 = empty, 1 = X, 2 = 0
func updateBoard(x, y, num):
	board[x][y] = num
	savedBoards.append(deep_copy(board))
	playerTurns.append(currentPlayer)
	print(board)

func nextPlayer():
	currentPlayer += 1
	if currentPlayer > 2:
		currentPlayer = 1

func check_winner():
	# Check rows
	for row in range(3):
		if board[row][0] != 0 and board[row][0] == board[row][1] and board[row][1] == board[row][2]:
			return [board[row][0], [Vector2(row, 0), Vector2(row, 1), Vector2(row, 2)]]
	
	# Check columns
	for col in range(3):
		if board[0][col] != 0 and board[0][col] == board[1][col] and board[1][col] == board[2][col]:
			return [board[0][col], [Vector2(0, col), Vector2(1, col), Vector2(2, col)]]

	# Check diagonals
	if board[0][0] != 0 and board[0][0] == board[1][1] and board[1][1] == board[2][2]:
		return [board[0][0], [Vector2(0, 0), Vector2(1, 1), Vector2(2, 2)]]
	if board[0][2] != 0 and board[0][2] == board[1][1] and board[1][1] == board[2][0]:
		return [board[0][2], [Vector2(0, 2), Vector2(1, 1), Vector2(2, 0)]]

	# No winner
	return [0, []]

func location_to_string(loc):
	var locations = {
		Vector2(0, 0): "BoardGridContainer/TopLeft",
		Vector2(0, 1): "BoardGridContainer/TopMiddle",
		Vector2(0, 2): "BoardGridContainer/TopRight",
		Vector2(1, 0): "BoardGridContainer/MiddleLeft",
		Vector2(1, 1): "BoardGridContainer/MiddleMiddle",
		Vector2(1, 2): "BoardGridContainer/MiddleRight",
		Vector2(2, 0): "BoardGridContainer/BottomLeft",
		Vector2(2, 1): "BoardGridContainer/BottomMiddle",
		Vector2(2, 2): "BoardGridContainer/BottomRight"
	}
	return locations.get(Vector2(loc[0], loc[1]), "")

func deep_copy(array):
	var result = []
	for row in array:
		var new_row = []
		for item in row:
			new_row.append(item)
		result.append(new_row)
	return result

func _on_top_left_button_down():
	if !winnerbool:
		changeButtonTexture("BoardGridContainer/TopLeft", currentPlayer, [0,0], false)
		checkForWinner()


func _on_top_middle_button_down():
	if !winnerbool:
		changeButtonTexture("BoardGridContainer/TopMiddle", currentPlayer, [0,1], false)
		checkForWinner()


func _on_top_right_button_down():
	if !winnerbool:
		changeButtonTexture("BoardGridContainer/TopRight", currentPlayer, [0,2], false)
		checkForWinner()


func _on_middle_left_button_down():
	if !winnerbool:
		changeButtonTexture("BoardGridContainer/MiddleLeft", currentPlayer, [1,0], false)
		checkForWinner()


func _on_middle_middle_button_down():
	if !winnerbool:
		changeButtonTexture("BoardGridContainer/MiddleMiddle", currentPlayer, [1,1], false)
		checkForWinner()


func _on_middle_right_button_down():
	if !winnerbool:
		changeButtonTexture("BoardGridContainer/MiddleRight", currentPlayer, [1,2], false)
		checkForWinner()


func _on_bottom_left_button_down():
	if !winnerbool:
		changeButtonTexture("BoardGridContainer/BottomLeft", currentPlayer, [2,0], false)
		checkForWinner()


func _on_bottom_middle_button_down():
	if !winnerbool:
		changeButtonTexture("BoardGridContainer/BottomMiddle", currentPlayer, [2,1], false)
		checkForWinner()


func _on_bottom_right_button_down():
	if !winnerbool:
		changeButtonTexture("BoardGridContainer/BottomRight", currentPlayer, [2,2], false)
		checkForWinner()


func _on_main_menu_button_button_down():
	get_tree().change_scene_to_file("res://ui/main/menu.tscn")


func _on_new_game_button_button_down():
	get_tree().change_scene_to_file("res://gamemodes/TicTacToe/TicTacToe.tscn")


func _on_miss_button_button_down():
	if !winnerbool:
		nextPlayer()


func _on_undo_button_button_down():
	if !winnerbool:
		if savedBoards.size() > 1:
			savedBoards.pop_back()
			board = deep_copy(savedBoards[-1])
			currentPlayer = playerTurns.pop_back()
			for x in range(3):
				for y in range(3):
					var button_name = location_to_string(Vector2(x, y))
					var button = get_node(button_name)
					if board[x][y] == 1:
						button.texture_normal = X
					elif board[x][y] == 2:
						button.texture_normal = O
					else:
						button.texture_normal = null
		else:
			get_tree().change_scene_to_file("res://gamemodes/TicTacToe/TicTacToe.tscn")
