tool
extends Button


var hower := false
var drag := false
onready var title : Label = $Title
onready var title_edit : LineEdit = $LineEdit
onready var list : PanelContainer = get_node("../../")
onready var todot : Control = get_node("../../../../../")


func _on_ListTitle_button_down():
	drag = true


func _on_ListTitle_mouse_entered():
	hower = true


func _on_ListTitle_mouse_exited():
	hower = false


func _process(delta):
	if title != null:
		rect_min_size = title.get_size()
		get_parent().queue_sort()


func _input(event):
	if event is InputEventMouseButton and event.button_index == 1:
		if !event.is_pressed():
			if drag:
				drag = false
				var pos = todot.get_local_mouse_position()
				if list in todot.mouse.get_children():
					todot.to_list(list)

		if event.is_pressed():
			if hower:
				yield(get_tree().create_timer(0.2), "timeout")
				if list.get_parent().name != "Mouse":
					title.hide()
					title_edit.show()
					title_edit.select_all()
					title_edit.grab_focus()

			elif !hower:	reset()

	elif event is InputEventMouseMotion and drag:
		if list != null:
			if list.get_parent().name != "Mouse":
				todot.to_mouse(list, get_local_mouse_position())
	elif event.is_action("ui_accept"):	reset()


func reset():
	if title != null:
		title.show()
		title_edit.hide()
		title.set_text(title_edit.get_text())
