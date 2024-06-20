extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func beerAnimation():
	var yellow = get_node("BeerMeArea2D/BeerMeYellowSprite2D")
	var tween = create_tween()
	yellow.show()
	yellow.self_modulate.a = 1
	tween.tween_property(yellow, "self_modulate:a", 0.0, 0.3)

func _on_beer_me_area_2d_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			beerAnimation()
