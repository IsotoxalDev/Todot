tool
extends Control


var hover := false
var drag := false
onready var title : Label = $HBoxContainer/Todo/Title
onready var list : PanelContainer = get_node("../../../")
onready var todot :Control = get_node("../../../../../../")


func _on_Todo_button_down():
	drag = true


func _on_Todo_mouse_entered():
	hover = true


func _on_Todo_mouse_exited():
	hover = false


func _process(delta):
	if title:
		title.set_size(Vector2.ZERO)
		rect_min_size.y = title.get_size().y+15
		title.get_parent().rect_min_size.y = title.get_size().y+10


func _input(event):
	if event is InputEventMouseButton and event.button_index == 1:
		if !event.is_pressed() and drag:
			drag = false
			var pos = todot.get_local_mouse_position()
			if self in todot.mouse.get_children():
				todot.to_list(self)
		elif event.is_pressed():
			if hover:
				yield(get_tree().create_timer(0.2), "timeout")
				if get_parent().name != "Mouse":
					$TodoPopup.popup_centered()

	elif event is InputEventMouseMotion and drag:
		if get_parent().name != "Mouse":
			todot.to_mouse(self, get_local_mouse_position())
