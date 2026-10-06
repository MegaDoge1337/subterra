class_name Item
extends RigidBody3D

@export_category("Basics params")
@export var title: String
@export var type: ItemsData.TYPE

@export_category("Flags")
@export var has_capacity: bool = false

@export_category("Capacity params")
@export var bar_title: String = "Capacity"
@export var max_value: int = 100
@export var current_value: int = 0
@export var step: int = 1
