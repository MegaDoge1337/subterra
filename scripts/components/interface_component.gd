extends Node3D

@onready var bottom_panel = $Panel
@onready var item_title: Label = $Panel/HBoxContainer/ItemTitle
@onready var capacity_title: Label = $Panel/HBoxContainer/CapacityTitle
@onready var capacity_bar: ProgressBar = $Panel/HBoxContainer/CapacityBar


func _ready() -> void:
	hide_all_and_reset()


func reset() -> void:
	item_title.text = ""
	capacity_title.text = ""
	capacity_bar.max_value = 100
	capacity_bar.value = 0


func hide_all_and_reset():
	item_title.hide()
	capacity_title.hide()
	capacity_bar.hide()
	bottom_panel.hide()
	reset()
