tool
extends Button

signal drag_start(data)
signal drag_end()

var data: Card setget set_data
export var margin: int = 20

onready var title: Label = $"%Title"
onready var edit_button = $"%EditButton"

func set_data(card: Card):
	data = card
	card.connect("changed", self, "set_data")
	title.text = card.name
	hint_tooltip = card.description

# The size need to be fixed according to the title's size
func fix_size():
	if !title: return
	rect_min_size.y = title.rect_size.y + margin

# Hacky hidden edit button
func _input(event):
	if !event is InputEventMouseMotion: return
	var rect = get_rect()
	rect.position = Vector2.ZERO
	if rect.has_point(get_local_mouse_position()):
		edit_button.modulate = Color.white
	else: edit_button.modulate = Color.transparent

func _on_EditButton_pressed():
	pass

# Drag stuff
func get_drag_data(position):
	var data = {}
	data["Item"] = self
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
	data["Item"].get_parent().add_child(data["Preview"])
	data["Item"].get_parent().remove_child(data["Item"])
	data["Preview"].get_parent().move_child(data["Preview"], idx)
	emit_signal("drag_start", data)
	c.connect("tree_exiting", self, "emit_signal", ["drag_end"])
	return data
