tool
extends HBoxContainer

signal drag_end()
signal drag_start(data)
signal data_changed()

var data = CheckItem setget set_data

onready var check_box = $CheckBox
onready var title = $Title

func _ready(): emit_signal("data_changed")

func emit_drag(data): emit_signal("drag_start", data)

func set_data(item: CheckItem):
	data = item
	check_box.pressed = item.done
	title.title.text = item.name
	title.hint_tooltip = item.name
	if !item.is_connected("changed", self, "set_data"):
		item.connect("changed", self, "set_data")

func update_data():
	data.done = check_box.pressed
	emit_signal("data_changed")
