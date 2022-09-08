extends WindowDialog

signal add_checklist(title)

onready var edit = $"%Edit"

func _on_AddChecklistPopup_about_to_show():
	edit.text = "Checklist"
	yield(get_tree(), "idle_frame")
	edit.select_all()
	edit.grab_focus()

func add_checklist(_n = ""):
	hide()
	emit_signal("add_checklist", edit.text)
