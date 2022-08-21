class_name Card extends Resource

export var name: String
export var description: String
export var checklist: Array

func _init(name = "Enter Name", description = "", checklist = []):
	self.name = name
	self.description = description
	self.checklist = checklist
