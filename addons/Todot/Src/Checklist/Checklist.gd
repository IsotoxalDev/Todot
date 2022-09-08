tool
extends VBoxContainer

signal drag_end()
signal drag_start(data)

onready var title = $"%Title"

func emit_drag(data): emit_signal("drag_start", data)
