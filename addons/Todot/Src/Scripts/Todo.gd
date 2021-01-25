tool
extends Control


var drag := false
onready var list : PanelContainer = get_node("../../../")
onready var todot :Control = get_node("../../../../../../")


func _on_Todo_button_down():
	drag = true


func _input(event):
	if event is InputEventMouseButton and !event.is_pressed():
		if event.button_index == 1 and drag:
			drag = false
			var pos = todot.get_local_mouse_position()
			if self in todot.mouse.get_children():
				todot.to_list(self)

	elif event is InputEventMouseMotion and drag:
		if get_parent().name != "Mouse":
			todot.to_mouse(self, get_local_mouse_position())
