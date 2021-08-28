tool
extends Button


signal on_enter_pressed


var hover := false
var drag := false
onready var title : Label = $HBoxContainer/Control/Title
onready var title_edit : LineEdit = $HBoxContainer/Control/LineEdit
onready var list : PanelContainer = get_node("../../")
onready var todot : Control = get_node("../../../../../")


func _on_ListTitle_button_down():
	drag = true


func _on_ListTitle_mouse_entered():
	hover = true


func _on_ListTitle_mouse_exited():
	hover = false


func _process(delta):
	if title != null and list != null and list.get_parent().name == "ListContainer":
		title.set_size(Vector2.ZERO)
		rect_min_size = title.get_size()
		list.get_parent().queue_sort()


func _input(event):
	if event is InputEventMouseButton and event.button_index == 1:
		if !event.is_pressed():
			if drag:
				drag = false
				var pos = todot.get_local_mouse_position()
				if list in todot.mouse.get_children():
					todot.to_list(list)
			reset()

		if event.is_pressed():
			if hover:
				yield(get_tree().create_timer(0.2), "timeout")
				if list.get_parent().name != "Mouse":
					title.hide()
					title_edit.show()
					title_edit.select_all()
					title_edit.grab_focus()


	elif event is InputEventMouseMotion and drag:
		if list != null:
			if list.get_parent().name != "Mouse":
				todot.to_mouse(list, get_local_mouse_position())
	elif event is InputEventKey and event.get_scancode() == KEY_ENTER:
		if event.pressed:
			reset()
			emit_signal("on_enter_pressed")


func reset():
	if title != null:
		title.show()
		title_edit.hide()
		title.set_text(title_edit.get_text())
		todot.save()
