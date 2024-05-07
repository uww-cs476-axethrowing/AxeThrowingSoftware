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
var hitducks = []
#RNG
var rng = RandomNumberGenerator.new()
var spawnLocs = []

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
	readyNextPlayer()

func startPlayer():
	get_node("StartButton").hide()
	spawnDucks()
	get_node("RoundTimer").start()
	get_node("RoundTimer/TimerText").show()

func readyNextPlayer():
	destroyDucks()
	ducks.clear()
	get_node("StartButton").set_text(str(playerList[currentPlayer]) + "'s Turn")
	get_node("StartButton").show()
	get_node("RoundTimer/TimerText").hide()


func checkWinner():
	if (currentFrame >= 10):
		get_node("RoundTimer").stop()
		get_node("RoundTimer/TimerText").hide()
		var winnerscore = totals.max()
		var winner = totals.rfind(winnerscore)
		print(str(playerList[winner]) + " Wins") 
		showWinner(playerList[winner])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var move_speed = 500.0
	var rotSpeed = 9
	if winnerbool:
		get_node("WinnerPath/WinnerPathFollow").progress += move_speed * delta
		get_node("WinnerPath/WinnerPathFollow/WinnerAxe").rotation += rotSpeed * delta
	if get_node("WinnerPath/WinnerPathFollow").progress > 310:
		winnerbool = false
	get_node("RoundTimer/TimerText").set_text(str(round(get_node("RoundTimer").get_time_left())))


func nextThrow(addScore):
	if(currentFrame != 10): #Added to prevent clicking the target after the last frame from crashing the program
		#sets the text of the scoreboard to the clicked number
		sbArray[currentPlayer].get_children()[currentFrame].set_text(str(addScore))
		#adds clicked number to player's total score
		totals[currentPlayer] += addScore
		#sets the text of the total score
		get_node("Scoreboard/TotalScoresContainer").get_child(currentPlayer).set_text(str(totals[currentPlayer]))
		addScore = 0
		currentFrame += 1
	if(currentFrame == 10 and currentPlayer == playerList.size() - 1):
		checkWinner()
		return
	if(currentFrame == 10):
		nextPlayer()
	#Updating the styles for scoreboard (makes it look better)
	UpdateCurrentStyle(currentPlayer, currentFrame, styleForCurrent)
	var prev = findPrevious()
	if(prev == null):
			return
	UpdateCurrentStyle(prev[0], prev[1], styleForNormal)

func nextPlayer():
	currentPlayer += 1
	currentFrame = 0
	get_node("RoundTimer").stop()
	readyNextPlayer()

#Used for updating the box style of a player
func UpdateCurrentStyle(player, frame, style):
	if(currentFrame != 10): #Added to prevent clicking undo after the last frame from crashing the program
		var currentsbRow = "Scoreboard/ScoreBoardRow" + str(player + 1)
		get_node(currentsbRow).get_child(0).set("theme_override_styles/read_only", style)
		get_node(currentsbRow).get_child(1).get_children()[frame].set("theme_override_styles/read_only", style)
	
#Finds the previous player, even across frames
#Returns a list: [prev player index, prev frame]
func findPrevious():
	if(currentFrame != 0):
		return [currentPlayer, currentFrame - 1]
	else:
		return null

#For displaying the winner
func showWinner(winnerName):
	#winnerbool = true
	destroyDucks()
	get_node("WinnerText").set_text(str(winnerName) + " Wins!")
	get_node("wintimer").start()

#For spawning ducks
func spawnDucks():
	for i in range(5):
		var duck = clone(get_node("DuckFlyArea"))
		duck.position = getNextSpawnLoc(305, 510, 50)
		duck.connect("click", onDuckClick)
		duck.show()
		ducks.append(duck)
		duck.setIndex(ducks.size() - 1)
	for i in range(5):
		var duck = clone(get_node("DuckSitArea"))
		duck.position = getNextSpawnLoc(540, 630, 60)
		duck.connect("click", onDuckClick)
		duck.show()
		ducks.append(duck)
		duck.setIndex(ducks.size() - 1)

func destroyDucks():
	spawnLocs.clear()
	for duck in ducks:
		duck.queue_free()

func getNextSpawnLoc(ymin, ymax, mindist):
	while true:
		var x = rng.randi_range(30, 460)
		var y = rng.randi_range(ymin, ymax)
		var newLoc = Vector2(x,y)
		var tooClose = false
		for loc in spawnLocs:
			if newLoc.distance_to(loc) < mindist:
				tooClose = true;
				break;
		if !tooClose:
			spawnLocs.append(newLoc)
			return newLoc

func onDuckClick():
	addHitDucks()
	nextThrow(1)

func addHitDucks():
	for duck in ducks:
		if(not duck.is_visible()):
			hitducks.append(duck)

#For duplicating objects
func clone(object):
	var children = object.get_children()
	var dup = object.duplicate()
	for child in children.size():
		var dupchild = children[child].duplicate()
		dup.add_child(dupchild)
	get_node(".").add_child(dup)
	return dup

#Connectors
func _on_miss_button_button_down():
	if(currentFrame != 10 and not get_node("RoundTimer").is_stopped()):
		nextThrow(0)

func _on_undo_button_button_down():
	if(currentFrame != 10): #Added to prevent clicking undo after the last frame from crashing the program
		#finds prev player
		var prev = findPrevious()
		if(prev == null):
			return
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
		hitducks.pop_back().show()

func _on_new_game_button_button_down():
	get_tree().change_scene_to_file("res://gamemodes/Hunter/Hunter.tscn")

func _on_main_menu_button_button_down():
	get_tree().change_scene_to_file("res://ui/main/menu.tscn")


func _on_wintimer_timeout():
	get_node("WinnerText").show()


func _on_start_button_button_down():
	startPlayer()


func _on_round_timer_timeout():
	UpdateCurrentStyle(currentPlayer, currentFrame, styleForNormal)
	while currentFrame < 10:
		#sets the text of the scoreboard to the clicked number
		sbArray[currentPlayer].get_children()[currentFrame].set_text(str(0))
		currentFrame += 1
	if(currentPlayer == playerList.size() - 1):
		checkWinner()
	else:
		UpdateCurrentStyle(currentPlayer + 1, currentFrame, styleForCurrent)
		nextPlayer()
		readyNextPlayer()
