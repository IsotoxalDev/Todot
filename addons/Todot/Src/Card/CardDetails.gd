tool
extends WindowDialog

onready var title: Label = $"%Title".title
onready var title_edit: LineEdit = $"%Title".title_edit
onready var checklist_container: VBoxContainer = $"%ChecklistContainer"
onready var desc: TextEdit = $"%Description"
#onready var todot = get_node("../../")

var checklist = preload("res://addons/Todot/Src/Scenes/Checklist.tscn")
var card : Card

# Set the card datas to the respective fields
func card_pressed(card : Card):
	self.card = card
	title.set_text(card.name)
	title_edit.set_text(card.name)
	if !title.text:
		title.hide()
		title_edit.show()
		title_edit.text = title.text
		title_edit.grab_focus()
	desc.set_text(card.description)
	for i in checklist_container.get_children(): i.queue_free()
	for i in card.checklist:
		var checklist_inst = checklist.instance()
		checklist_container.add_child(checklist_inst)
		checklist_inst.title.text = i.name
		for j in i.checkitems:
			checklist_inst._add_check_item(j.name, j.done)
	popup_centered()

func _on_Button_pressed():
	var checklist_inst = checklist.instance()
	checklist_container.add_child(checklist_inst)

# Saving and stuff
func _on_CardDetails_popup_hide():
	card.name = title_edit.text
	card.description = desc.text
	card.checklist = []
	for i in checklist_container.get_children():
		var checkitems = []
		for j in i.check_item_container.get_children():
			checkitems.append({
				'name': j.get_node("LineEdit").text,
				'done': j.get_node("CheckBox").pressed
			})
		card.checklist.append({
			'name': i.title.text,
			'checkitems': checkitems,
		})
	card.emit_signal("changed", card)
	# TODO: Emit on_editi signal
	card = null
