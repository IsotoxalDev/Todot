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
	if !event is InputEventMouseMotion:
		handle_drag_logic()
	pass

func handle_drag_logic():
	pass
#	if !drag_data: return
#	var mouse_pos = checklist_container.get_local_mouse_position().y + checklist_scroll.scroll_vertical
#	var checklist_index
#	if checklist_container.get_rect().position.y > mouse_pos: checklist_index = 0
#	if checklist_container.get_rect().end.y > mouse_pos: checklist_index = 0
#	for c in checklist_container.get_children():
#		if mouse_pos > c.get_rect().position:
#			if mouse_pos < c.get_rect().end.y:
#				checklist_index = c.get_index()
#	match drag_data["Item"].get_groups()[0]:
##		"Checklist":
##			if drag_data["Preview"].get_index() == checklist_index: return
##			checklist_container.move_child(drag_data["Preview"], checklist_index)
##		"Item":
##			var checklist = checklist_container.get_child(checklist_index)
##			if !drag_data["Preview"] in checklist.checkitem_container.get_children():
##				drag_data["Preview"].get_parent().remove_child(drag_data["Preview"])
##				checklist.checkitem_container.add_child(drag_data["Preview"])
##				print(checklist_index)
##			var card_size = drag_data["Preview"].rect_size.y + checklist.checkitem_container.get_constant("separation")
##			var cards_count = checklist.checkitem_container.get_child_count()
##			var item_index = floor((mouse_pos.y-checklist.box.rect_size.y+checklist_scroll_offset)/card_size)
###			print(item_index)
###			print(cards_count)
##			item_index = 0 if item_index < 0 else item_index if item_index < cards_count else cards_count
###			print(item_index)
##			checklist.checkitem_container.move_child(drag_data["Preview"], item_index)
##			drag_data["Checklist"] = checklist

func clear_data():
	var idx = drag_data["Preview"].get_index()
	drag_data["Preview"].queue_free()
	match drag_data["Item"].get_groups()[0]:
		"Checklist":
			checklist_container.add_child(drag_data["Item"])
			checklist_container.move_child(drag_data["Item"], idx)
		"Item":
			drag_data["Checklist"].checkitem_container.add_child(drag_data["Item"])
			drag_data["Checklist"].checkitem_container.move_child(drag_data["Item"], idx)
	drag_data = {}

# Set the card datas to the respective fields
func card_pressed(card : Card):
	self.card = card
	title.set_text(card.name)
	title.set_tooltip(card.name)
	description.set_text(card.description)
	for checklist in card.checklists:
		add_checklist(checklist)
	popup_centered()

# Saving and stuff
func _on_CardDetails_popup_hide():
	card.name = title.text
	card.description = description.text
	for child in checklist_container.get_children():
		child.queue_free()
	card.emit_signal("changed", card)
	card = null

func _on_AddChecklist_pressed():
	add_checklist_popup.popup_centered()

func add_checklist_pressed(title):
	title = title.strip_edges()
	if title == "": return
	var data = Checklist.new(title)
	add_checklist(data)
	
func add_checklist(data: Checklist):
	var checklist = checklist_scene.instance()
	checklist.connect("drag_start", self, "set_data")
	checklist.connect("drag_end", self, "clear_data")
	checklist_container.add_child(checklist)
	checklist.data = data
	card.checklists.append(data)
