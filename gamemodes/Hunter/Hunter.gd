extends Node2D
var playerList = PlayerList.global_list
#This array holds the "Frame Row" objects from each "Scoreboard Row" object
var sbArray = []
#This array holds the totals of each player's score
var totals = []
#variables to keep track of current player/frame
var currentFrame = 0
var currentPlayer = 0
#help for adding/setting scores
var tempScoreHolder = 0
#Styles for buttons
var styleForCurrent = preload("res://ui/main/SetupTeams/BlueButtonStyleNormal.tres")
var styleForNormal = preload("res://ui/main/SetupTeams/ButtonStyleNormal.tres")
#var that will control when animation plays 
var winnerbool = false
#array to hold duck objects
var ducks = []
#RNG
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	#Setting winner lable to hide
	get_node("WinnerText").hide()
	#Sets the y position of the bottom buttons based on how many players there are
	get_node("BottomButtonsContainer").position.y = (playerList.size() * 31) + 2
	#Loop that sets up scoreboard based on how many players there are
	for index in range(playerList.size()):
		var sbString = "Scoreboard/ScoreBoardRow" + str(index + 1)
		var tsString = "Scoreboard/TotalScoresContainer/TotalScore" + str(index + 1)
		var current = get_node(sbString)
		var currentTS = get_node(tsString)
		current.show()
		currentTS.show()
		sbArray.append(current.get_child(1))
		current.get_child(0).set_text(playerList[index])
		totals.append(0)
		UpdateCurrentStyle(currentPlayer,currentFrame, styleForCurrent)
	spawnDucks()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var move_speed = 500.0
	var rotSpeed = 5
	if winnerbool:
		get_node("WinnerPath/WinnerPathFollow").progress += move_speed * delta
		get_node("WinnerPath/WinnerPathFollow/WinnerAxe").rotation += rotSpeed * delta
	if get_node("WinnerPath/WinnerPathFollow").progress > 615:
		winnerbool = false


func nextPlayer():
	if(currentFrame != 10): #Added to prevent clicking the target after the last frame from crashing the program
		#sets the text of the scoreboard to the clicked number
		sbArray[currentPlayer].get_children()[currentFrame].set_text(str(tempScoreHolder))
		#adds clicked number to player's total score
		totals[currentPlayer] += tempScoreHolder
		#sets the text of the total score
		get_node("Scoreboard/TotalScoresContainer").get_child(currentPlayer).set_text(str(totals[currentPlayer]))
		tempScoreHolder = 0
		currentPlayer += 1
		
		#Goes to next frame after last player
	if(currentPlayer > playerList.size() - 1):
		currentPlayer = 0
		currentFrame += 1
		
	#Use this to check who wins after frame 10
	if (currentFrame >= 10):
		var winnerscore = totals.max()
		var winner = totals.rfind(winnerscore)
		print(str(playerList[winner]) + " Wins") 
		showWinner(playerList[winner])
		return
	#Updating the styles for scoreboard (makes it look better)
	UpdateCurrentStyle(currentPlayer, currentFrame, styleForCurrent)
	var prev = findPreviousPlayer()
	UpdateCurrentStyle(prev[0], prev[1], styleForNormal)

#Used for updating the box style of a player
func UpdateCurrentStyle(player, frame, style):
	if(currentFrame != 10): #Added to prevent clicking undo after the last frame from crashing the program
		var currentsbRow = "Scoreboard/ScoreBoardRow" + str(player + 1)
		get_node(currentsbRow).get_child(0).set("theme_override_styles/read_only", style)
		get_node(currentsbRow).get_child(1).get_children()[frame].set("theme_override_styles/read_only", style)
	
#Finds the previous player, even across frames
#Returns a list: [prev player index, prev frame]
func findPreviousPlayer():
	if(currentPlayer == 0 and currentFrame == 0):
		return [0, 0]
	elif(currentPlayer == 0):
		return [playerList.size() - 1, currentFrame - 1]
	else:
		return [currentPlayer - 1, currentFrame]

#For displaying the winner
func showWinner(winnerName):
	winnerbool = true
	get_node("WinnerText").set_text(str(winnerName) + " Wins!")
	get_node("wintimer").start()

#For spawning ducks
func spawnDucks():
	for i in range(5):
		var duck = clone(get_node("DuckFlyArea"))
		duck.position = Vector2(rng.randi_range(30, 460), rng.randi_range(305, 510))
		duck.show()
		ducks.append(duck)
	for i in range(5):
		var duck = clone(get_node("DuckSitArea"))
		duck.position = Vector2(rng.randi_range(30, 460), rng.randi_range(540, 630))
		duck.show()
		ducks.append(duck)

#For duplicating objects
func clone(object):
	var children = object.get_children()
	var dupscript = object.get_script()
	var dup = object.duplicate()
	for child in children.size():
		var dupchild = children[child].duplicate()
		dup.add_child(dupchild)
	dup.set_script(dupscript)
	get_node(".").add_child(dup)
	return dup

#Connectors
func _on_miss_button_button_down():
	if(currentFrame != 10):
		nextPlayer()

func _on_undo_button_button_down():
	if(currentFrame != 10): #Added to prevent clicking undo after the last frame from crashing the program
		#finds prev player
		var prev = findPreviousPlayer()
		#Changes styles to reflect current player
		UpdateCurrentStyle(currentPlayer, currentFrame, styleForNormal)
		UpdateCurrentStyle(prev[0], prev[1], styleForCurrent)
		#Updates current variables
		currentPlayer = prev[0]
		currentFrame = prev[1]
		#finds the point that was last clicked
		var lastPoint = int(sbArray[currentPlayer].get_children()[currentFrame].get_text())
		#Updates total
		totals[currentPlayer] -= lastPoint
		get_node("Scoreboard/TotalScoresContainer").get_child(currentPlayer).set_text(str(totals[currentPlayer]))
		#Updates scoreboard text
		sbArray[currentPlayer].get_children()[currentFrame].set_text("")

func _on_new_game_button_button_down():
	get_tree().change_scene_to_file("res://gamemodes/Hunter/Hunter.tscn")

func _on_main_menu_button_button_down():
	get_tree().change_scene_to_file("res://ui/main/menu.tscn")


func _on_wintimer_timeout():
	get_node("WinnerText").show()
