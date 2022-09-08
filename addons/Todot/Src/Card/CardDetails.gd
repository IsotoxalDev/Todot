tool
extends WindowDialog

onready var title: Label = $"%Title".title
onready var title_edit: LineEdit = $"%Title".title_edit
onready var checklist_container: VBoxContainer = $"%ChecklistContainer"
onready var description: TextEdit = $"%Description"
onready var add_checklist_popup = $"%AddChecklistPopup"
onready var checklist_scroll = $"%ChecklistScroll"

var drag_data: Dictionary = {}
var checklist_scene = preload("res://addons/Todot/Src/Checklist/Checklist.tscn")
var card : Card


func set_data(data): drag_data = data

func _input(event):
	handle_drag_logic()
	pass

func handle_drag_logic():
	if !drag_data: return
	var mouse_pos = checklist_container.get_local_mouse_position()
	var checklist_scroll_offset = checklist_scroll.scroll_vertical
	var checklist_size = drag_data["Preview"].rect_size.y+checklist_container.get_constant("separation")
	var checklist_count = checklist_container.get_child_count()-1
	var checklist_index = floor((mouse_pos.y+checklist_scroll_offset)/checklist_size)
	checklist_index = 0 if checklist_index < 0 else checklist_index if checklist_index < checklist_count else checklist_count
	match drag_data["Item"].get_groups()[0]:
		"Checklist":
			if drag_data["Preview"].get_index() == checklist_index: return
			checklist_container.move_child(drag_data["Preview"], checklist_index)
#		"Card":
#			var list = list_container.get_child(xindex)
#			if !drag_data["Preview"] in list.card_container.get_children():
#				drag_data["Preview"].get_parent().remove_child(drag_data["Preview"])
#				list.card_container.add_child(drag_data["Preview"])
#			var scroll_vertical = list.card_scroll.scroll_vertical
#			var title = list.title.rect_size.y
#			var card_size = drag_data["Preview"].rect_size.y + list.card_container.get_constant("separation")
#			var cards_count = list.card_container.get_child_count()
#			var yindex = floor((mouse_pos.y+scroll_vertical+title)/card_size)-2
#			yindex = 0 if yindex < 0 else yindex if yindex < cards_count else cards_count
#			list.card_container.move_child(drag_data["Preview"], yindex)
#			drag_data["List"] = list

func clear_data():
	var idx = drag_data["Preview"].get_index()
	drag_data["Preview"].queue_free()
	match drag_data["Item"].get_groups()[0]:
		"Checklist":
			checklist_container.add_child(drag_data["Item"])
			checklist_container.move_child(drag_data["Item"], idx)
#		"Card":
#			drag_data["List"].card_container.add_child(drag_data["Item"])
#			drag_data["List"].card_container.move_child(drag_data["Item"], idx)
	drag_data = {}

# Set the card datas to the respective fields
func card_pressed(card : Card):
	self.card = card
	title.set_text(card.name)
	title.set_tooltip(card.name)
	description.set_text(card.description)
	for i in checklist_container.get_children(): i.queue_free()
	for i in card.checklist:
		var checklist_inst = checklist_scene.instance()
		checklist_container.add_child(checklist_inst)
		checklist_inst.title.text = i.name
		for j in i.checkitems:
			checklist_inst._add_check_item(j.name, j.done)
	popup_centered()

# Saving and stuff
func _on_CardDetails_popup_hide():
	card.name = title.text
	card.description = description.text
	card.checklist = []
	for i in checklist_container.get_children():
		var checkitems = []
#		for j in i.check_item_container.get_children():
#			checkitems.append({
#				'name': j.get_node("LineEdit").text,
#				'done': j.get_node("CheckBox").pressed
#			})
		card.checklist.append({
			'name': i.title.text,
			'checkitems': checkitems,
		})
	card.emit_signal("changed", card)
	# TODO: Emit on_editi signal
	card = null

func _on_AddChecklist_pressed():
	add_checklist_popup.popup_centered()

func add_checklist(title):
	if title.strip_edges() == "": return
	var checklist = checklist_scene.instance()
	checklist.connect("drag_start", self, "set_data")
	checklist.connect("drag_end", self, "clear_data")
	yield(get_tree(), "idle_frame")
	checklist_container.add_child(checklist)
	checklist.title.title.text = title
