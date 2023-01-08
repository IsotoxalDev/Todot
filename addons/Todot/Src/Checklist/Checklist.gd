tool
extends VBoxContainer

signal drag_end()
signal drag_start(data)

var data: Checklist setget set_data
var checkitem_scene = preload("res://addons/Todot/Src/Checkitem/CheckItem.tscn")

onready var box = $"%Box"
onready var title = $"%Title"
onready var add_item_box = $"%AddItemBox"
onready var add_item_btn = $"%AddCheckitem"
onready var checkitem_edit = $"%AddItemEdit"
onready var checkitem_container = $"CheckitemContainer"
onready var progress_bar = $"%ProgressBar"
onready var progress_label = $"%ProgressLabel"

func _input(event):
	if !event is InputEventMouseButton: return
	if !add_item_box.visible: return
	if !add_item_box.get_global_rect().has_point(get_global_mouse_position()):
		add_item_box.hide()
		add_item_btn.show()

func set_data(checklist: Checklist):
	data = checklist
	if !checklist.is_connected("changed", self, "set_data"):
		checklist.connect("changed", self, "set_data")
	title.title.text = checklist.name
	var items_in_tree = checkitem_container.get_children()
	if checklist.items.size() != items_in_tree.size():
		while checklist.items.size() > items_in_tree.size():
			var checkitem = checkitem_scene.instance()
			checkitem_container.add_child(checkitem)
			checkitem.connect("drag_start", self, "emit_drag")
			checkitem.connect("drag_end", self, "emit_signal", ["drag_end"])
			items_in_tree = checkitem_container.get_children()
		while checklist.items.size() < items_in_tree.size():
			items_in_tree[-1].queue_free()
	for idx in checklist.items.size():
		items_in_tree[idx].data = checklist.items[idx]
		if !items_in_tree[idx].is_connected("data_changed", self, "update_progress"):
			items_in_tree[idx].connect("data_changed", self, "update_progress")
	update_progress()

func update_progress():
	if data.items.size() <= 0: return
	progress_bar.max_value = data.items.size()
	var value = 0.0
	for item in data.items:
		if item.done == true: value += 1
	var progress = (value / progress_bar.max_value) * 100
	progress_label.text = str(int(progress), "%")
	var tween = create_tween()
	tween.tween_property(progress_bar, "value", value, 0.1)

func emit_drag(data): emit_signal("drag_start", data)

func add_checkitem(_n = ""):
	var text = checkitem_edit.text.strip_edges()
	if text == "": return
	var checkitem = CheckItem.new(text)
	data.items.append(checkitem)
	set_data(data)
