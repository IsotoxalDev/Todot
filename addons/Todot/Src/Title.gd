tool
extends Button

signal on_edit()
signal drag_start(data)
signal drag_end()

var drag_data = {}
export var list: NodePath

onready var title: Label = $"%Title"
onready var title_edit: LineEdit = $"%TitleEdit"

# If the Item has no text give it the placeholder text
func _ready() -> void:
	if list: $"%MenuButton".show()
	if !title.text: return
	get_node(list).rect_rotation = 5
	title.text = title_edit.placeholder_text
	title_edit.text = title_edit.placeholder_text

# When pressed show the line edit to edit the title and do focus stuff
func _pressed() -> void:
	title.hide()
	title_edit.show()
	title_edit.grab_focus()
	title_edit.select_all()

# Godot doesn't remove focus when you click anywhere on screen so had to do it manually
func _input(event) -> void:
	if !title_edit: return
	if !title_edit.has_focus(): return
	if event is InputEventMouseButton && event.is_pressed():
		reset()

func _on_TitleEdit_text_entered(new_text) -> void: reset()

# Reset the title so the title gets bigger and can be smaller
func reset() -> void:
	title.show()
	title_edit.hide()
	if title_edit.text != "":
		title.text = title_edit.text
		emit_signal("on_edit")
	else:
		title_edit.text = title.text

# Fix the size.
func fix_size():
	rect_min_size.y = title.rect_size.y

func get_drag_data(position) -> Dictionary:
	if !list: return {}
	var data = {}
	data["Item"] = get_node(list)
	var idx = data["Item"].get_index()
	var preview = TextureRect.new()
	var img = get_viewport().get_texture().get_data()
	img.flip_y()
	var t = ImageTexture.new()
	t.create_from_image(img.get_rect(data["Item"].get_global_rect()))
	preview.texture = t
	preview.rect_size = data["Item"].rect_size
	var c = Control.new()
	c.add_child(preview)
	preview.set_position(-get_local_mouse_position())
	set_drag_preview(c)
	
	data["Preview"] = ColorRect.new()
	data["Preview"].color = Color(0, 0, 0, 0.5)
	data["Preview"].rect_min_size = data["Item"].rect_size
	data["Preview"].size_flags_vertical = SIZE_EXPAND
	data["Item"].get_parent().add_child(data["Preview"])
	data["Item"].get_parent().remove_child(data["Item"])
	data["Preview"].get_parent().move_child(data["Preview"], idx)
	emit_signal("drag_start", data)
	c.connect("tree_exiting", self, "emit_signal", ["drag_end"])
	return data

