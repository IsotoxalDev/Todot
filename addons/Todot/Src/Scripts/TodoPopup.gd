tool
extends PopupDialog


var hover := false
export var x_width : int = 10 setget set_x_width
export var x_pos : Vector2 = Vector2(0, 0) setget set_x_pos
onready var todo : Control
onready var close_button : Button = $CloseButton
onready var title : Label = $VBoxContainer/HBoxContainer/Control/Title
onready var title_edit : LineEdit = $VBoxContainer/HBoxContainer/Control/HBoxContainer/TitleEdit


func _on_Control_mouse_entered():
	hover = true


func _on_Control_mouse_exited():
	hover = false


func _on_CloseButton_pressed():
	todo.hover = false
	hide()


func _draw():
	draw_line(Vector2(0, 0) + x_pos, Vector2(x_width, x_width) + x_pos, Color.black, 5, true)
	draw_line(Vector2(x_width, 0) + x_pos, Vector2(0, x_width) + x_pos, Color.black, 5, true)


func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if hover:
			title.hide()
			title_edit.show()
			title_edit.text = title.text
			title_edit.select_all()
			title_edit.grab_focus()
			title.hide()
		elif !hover:
			reset()
	if event is InputEventKey and event.get_scancode() == KEY_ENTER:	reset()


func todo_pressed(todo : Todo):
	self.todo = todo
	title.set_text(todo.text)
	popup_centered()


func set_x_width(val):
	x_width = val
	update()


func set_x_pos(val):
	x_pos = val
	update()


func reset():
	if title and todo:
		title.show()
		title.text = title_edit.text
		title_edit.hide()
		todo.title.set_text(title.text)
