tool
extends Button


signal on_enter_pressed


var hover := false
var drag := false
onready var title: Label = $"%Title"
onready var edit_box: HBoxContainer = $"%EditBox"
onready var title_edit: LineEdit = $"%TitleEdit"
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


func _gui_input(event: InputEvent) -> void:
	if event.is_pressed():
			if hover:
				yield(get_tree().create_timer(0.2), "timeout")
				if list.get_parent().name != "Mouse":
					title.hide()
					edit_box.show()
					title_edit.grab_focus()
					title_edit.editable = true
					title_edit.select_all()


func _input(event):
	if event is InputEventMouseButton and event.button_index == 1:
		if !event.is_pressed():
			if drag:
				drag = false
				var pos = todot.get_local_mouse_position()
				if list in todot.mouse.get_children():
					todot.to_list(list)
			reset()

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
		edit_box.hide()
		title_edit.editable = false
		if title_edit.get_text():
			title.set_text(title_edit.get_text())
		else:
			title.set_text(title_edit.placeholder_text)

		todot.save()


func _on_Remove_pressed() -> void:
	list.remove()
