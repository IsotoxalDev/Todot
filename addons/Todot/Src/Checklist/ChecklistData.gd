class_name Checklist extends Resource

export var name: String
export var items: Array

func _init(name: String = "", items: Array= []):
	self.name = name; self.items = items
