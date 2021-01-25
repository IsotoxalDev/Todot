tool
extends PopupDialog


var hover := false
onready var todo : Control = get_node("../")
onready var title : Label = $VBoxContainer/Control/Title
onready var title_edit : LineEdit = $VBoxContainer/Control/HBoxContainer/TiltleEdit


func _on_Control_mouse_entered():
	hover = true


func _on_Control_mouse_exited():
	hover = false


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
	if event.is_action_pressed("ui_accept"):	reset()


func reset():
	if title:
		title.show()
		title.text = title_edit.text
		title_edit.hide()
	todo.title.set_text(title.text)
