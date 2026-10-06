extends Node3D

@onready var raycast: RayCast3D = $RayCast
@onready var tooltip: Label = $VBoxContainer/Tooltip


func _process(delta: float) -> void:
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
