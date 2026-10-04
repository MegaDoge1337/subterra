extends Node3D

@onready var raycast: RayCast3D = $RayCast
@onready var tooltip: Label = $VBoxContainer/Tooltip


func _process(delta: float) -> void:
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if !collider:
			tooltip.text = ""
			return
		
		if collider is Item:
			tooltip.text = collider.get_item_name()
	else:
		tooltip.text = ""
