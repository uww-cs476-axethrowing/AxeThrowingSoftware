extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_quit_pressed():
	get_tree().quit()

func _on_setup_teams_menu_bt_pressed():
	get_tree().change_scene_to_file("res://ui/main/options/SetupTeams/SetupTeams.tscn")


func _on_standard_target_menu_bt_pressed():
	get_tree().change_scene_to_file("res://ui/main/Traditional Game/TraditionalGame.tscn")
