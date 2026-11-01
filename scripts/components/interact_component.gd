extends Node3D

@onready var raycast: RayCast3D = $RayCast
@onready var crosshair: Label = $VBoxContainer/Crosshair
@onready var tooltip: Label = $VBoxContainer/Tooltip


func _process(_delta: float) -> void:
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider is Item:
			tooltip.text = collider.title
	else:
		tooltip.text = ""


func get_interact_item() -> Item:
	if raycast.is_colliding():
		return raycast.get_collider()
	return null


func show_crosshair_and_tooltip() -> void:
	crosshair.show()
	tooltip.show()


func hide_crosshair_and_tooltip() -> void:
	crosshair.hide()
	tooltip.hide()
