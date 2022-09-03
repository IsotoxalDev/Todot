tool
extends PanelContainer

signal on_edit()
signal drag_start(data)
signal drag_end(data)
signal card_pressed(card)

const card_scene = preload("res://addons/Todot/Src/Card/CardButton.tscn")

onready var title = $"%ListTitle"
onready var card_scroll = $"%CardScroll"
onready var add_card_box = $"%AddCardBox"
onready var add_card_button = $"%AddButton"
onready var add_card_edit = $"%AddCardEdit"
onready var card_container = $"%CardContainer"

export var plugin_rect: Rect2

func _ready():
	title.connect("on_edit", self, "emit_signal", ["on_edit"])
	title.connect("drag_start", self, "handle_drag_signal", ["drag_start"])
	title.connect("drag_end", self, "emit_signal", ["drag_end"])

func _input(event):
	if event is InputEventMouseButton && add_card_box && add_card_edit.has_focus():
		if !add_card_box.get_global_rect().has_point(get_global_mouse_position()):
			add_card_box.hide()
			add_card_button.show()

func handle_drag_signal(data: Dictionary, sig: String): emit_signal(sig, data)

func set_plugin_rect(todot: Control):
	plugin_rect = todot.get_rect()

func fix_theme(todot: Control):
	add_stylebox_override("panel", todot.list_panel)

func add_card_button_pressed(_n = ""):
	var card = Card.new(add_card_edit.text)
	add_card_edit.select_all()
	add_card(card)
	emit_signal("on_edit")

func add_card(data: Card):
	var card = card_scene.instance()
	card.connect("pressed", self, "emit_signal", ["card_pressed", data])
	card.connect("drag_start", self, "handle_drag_signal", ["drag_start"])
	card.connect("drag_end", self, "emit_signal", ["drag_end"])
	card_container.add_child(card)
	card_container.move_child(card, card_container.get_child_count()-1)
	card.data = data

func fix_size():
	if !get_tree(): return
	yield(get_tree().create_timer(0.0000000001), "timeout")
	if plugin_rect.encloses(card_container.get_global_rect()):
		card_scroll.rect_min_size.y = card_container.rect_size.y
	else:
		rect_min_size.y = plugin_rect.end.y
