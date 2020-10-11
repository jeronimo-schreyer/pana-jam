extends PanelContainer

export (String) var dialogue_file
export (NodePath) var _feed

onready var parser = WhiskersParser.new(self)
onready var dialogue_data = parser.open_whiskers(dialogue_file)
onready var last_conversacion = $VBoxContainer/Comentarios/VBoxContainer/Control
onready var feed : Feed = get_node(_feed)

var __opcion = preload("res://ui/opcion.tscn")
var __conversacion = preload("res://ui/conversacion.tscn")
var block = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	var block = parser.start_dialogue(dialogue_data)
	
	for comment in block.text.split("\n-----\n"):
		create_conversation(comment)
	
	if block.options.size() > 0:
		for option in block.options:
			create_option(option.key, option.text)

func create_conversation(comment):
		var conversacion = __conversacion.instance()
		conversacion.get_node("RichTextLabel").bbcode_text = comment
		$VBoxContainer/Comentarios/VBoxContainer.add_child_below_node(
			last_conversacion, conversacion)
		last_conversacion = conversacion

func create_option(key : String, text : String):
	var opcion : Opcion = __opcion.instance()
	opcion.key = key
	opcion.text = text
	opcion.connect("selected", self, "on_opcion_pressed")
	opcion.connect("pressed", feed, "on_opcion_pressed")
	$VBoxContainer/Comentarios/VBoxContainer/Opciones.add_child(opcion)

func on_opcion_pressed(key, text):
	create_conversation(text)
	for child in $VBoxContainer/Comentarios/VBoxContainer/Opciones.get_children():
		$VBoxContainer/Comentarios/VBoxContainer/Opciones.remove_child(child)
	
	block = parser.next(key)
	if !block.empty():
		for comment in block.text.split("\n-----\n"):
			create_conversation(comment)
