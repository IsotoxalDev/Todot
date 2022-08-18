tool
extends PopupDialog


export var x_width : int = 10 setget set_x_width

onready var close_button: Button = $"%CloseButton"
onready var title: Label = $"%Title"
onready var title_edit: LineEdit = $"%TitleEdit"
onready var checklist_container: VBoxContainer = $"%ChecklistContainer"
onready var desc: TextEdit = $"%Description"
onready var todot = get_node("../../")

var checklist = preload("res://addons/Todot/Src/Scenes/Checklist.tscn")
var todo : Control
var hover := false

func _on_Control_mouse_entered():
	hover = true


func _on_Control_mouse_exited():
	hover = false


func _on_CloseButton_pressed():
	todo.hover = false
	hide()


func _draw():
	var start = close_button.rect_position
	draw_line(Vector2(0, 0) + start, Vector2(x_width, x_width) + start, Color.black, 5, true)
	draw_line(Vector2(x_width, 0) + start, Vector2(0, x_width) + start, Color.black, 5, true)


func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if hover:
			title.hide()
			title_edit.show()
			title_edit.text = title.text
			title_edit.select_all()
			title_edit.grab_focus()
		elif !hover:
			reset()
	if event is InputEventKey and event.get_scancode() == KEY_ENTER:
		reset()


func _on_TodoPopup_popup_hide():
	todo.text = title_edit.text
	todo.desc = desc.text
	todo.checklist = []
	for i in checklist_container.get_children():
		var checkitems = []
		for j in i.check_item_container.get_children():
			checkitems.append({
				'name': j.get_node("LineEdit").text,
				'done': j.get_node("CheckBox").pressed
			})
		todo.checklist.append({
			'name': i.title.text,
			'checkitems': checkitems,
		})
	todot.save()
	pass


func todo_pressed(todo : Todo):
	self.todo = todo
	title.set_text(todo.text)
	title_edit.set_text(todo.text)
	if !title.text:
		title.hide()
		title_edit.show()
		title_edit.text = title.text
		title_edit.grab_focus()
	desc.set_text(todo.desc)
	for i in checklist_container.get_children(): i.queue_free()
	for i in todo.checklist:
		var checklist_inst = checklist.instance()
		checklist_container.add_child(checklist_inst)
		checklist_inst.title.text = i.name
		for j in i.checkitems:
			checklist_inst._add_check_item(j.name, j.done)
	popup_centered()


func set_x_width(val):
	x_width = val
	update()


func reset():
	if title and todo:
		title.show()
		title.text = title_edit.text
		title_edit.hide()
		todo.title.set_text(title.text)


func _on_Button_pressed():
	var checklist_inst = checklist.instance()
	checklist_container.add_child(checklist_inst)
