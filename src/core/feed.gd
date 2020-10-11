extends ScrollContainer
class_name Feed

export (PackedScene) var next_day
export (float) var scroll_sensitivity = 1

var holding = false
var answered = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	for publicacion in $PanelContainer/VBoxContainer.get_children():
		publicacion.feed = self

func on_opcion_pressed():
	answered = answered + 1
	if answered == $PanelContainer/VBoxContainer.get_child_count():
		get_tree().change_scene_to(next_day)
	
func _on_gui_input(event : InputEvent):
	if event is InputEventMouseButton:
		holding = event.pressed
	
	if event is InputEventMouseMotion and holding:
		scroll_vertical += -event.speed.y * scroll_sensitivity
