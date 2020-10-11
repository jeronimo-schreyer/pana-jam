extends ScrollContainer
class_name Feed

export (PackedScene) var next_day
export (float) var scroll_sensitivity = 1

var holding = false

# Called when the node enters the scene tree for the first time.
func _ready():
	for publicacion in $PanelContainer/VBoxContainer.get_children():
		publicacion.feed = self

func switch_to_next_scene():
	yield(get_tree().create_timer(5), "timeout")
	get_tree().change_scene_to(next_day)
	
func _on_gui_input(event : InputEvent):
	if event is InputEventMouseButton:
		holding = event.pressed
	
	if event is InputEventMouseMotion and holding:
		scroll_vertical += -event.speed.y * scroll_sensitivity
