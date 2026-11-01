class_name Item
extends RigidBody3D

@export_category("Basics params")
@export var title: String
@export var type: ItemsData.TYPE

@export_category("Flags")
@export var has_capacity: bool = false
@export var has_notes: bool = false

@export_category("Capacity params")
@export var bar_title: String = "Capacity"
@export var max_value: int = 100
@export var current_value: int = 0
@export var step: int = 1

@export_category("Notes params")
@export_global_file("*.txt") var notes_path: String

func get_notes_text() -> String:
	return FileAccess.open(notes_path, FileAccess.READ).get_as_text()
