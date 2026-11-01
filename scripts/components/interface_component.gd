extends Node3D

@onready var bottom_panel = $Panel
@onready var item_title: Label = $Panel/HBoxContainer/ItemTitle
@onready var capacity_title: Label = $Panel/HBoxContainer/CapacityTitle
@onready var capacity_bar: ProgressBar = $Panel/HBoxContainer/CapacityBar

@onready var viewer_panel: Panel = $Viewer
@onready var viewer_text: RichTextLabel = $Viewer/ViewerText


func _ready() -> void:
	hide_all_and_reset()


func reset() -> void:
	item_title.text = ""
	capacity_title.text = ""
	capacity_bar.max_value = 100
	capacity_bar.value = 0
	viewer_text.text = ""


func hide_all_and_reset():
	item_title.hide()
	capacity_title.hide()
	capacity_bar.hide()
	bottom_panel.hide()
	viewer_text.hide()
	viewer_panel.hide()
	reset()
