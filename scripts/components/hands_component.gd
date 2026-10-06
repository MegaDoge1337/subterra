extends Node3D

@onready var wrench_marker = $WrenchMarker
@onready var fuel_can_marker = $FuelCanMarker

var picked_item: Item

func pick_up_item(item: Item) -> void:
	if !item:
		return
	item.reparent(self)
	
	# update position/rotation and disable physics
	match item.type:
		ItemsData.ITEM_TYPE.WRENCH:
			item.global_position = wrench_marker.global_position
			item.rotation = Vector3(0, -90, 0)
			item.freeze = true
		ItemsData.ITEM_TYPE.FUEL_CAN:
			item.global_position = fuel_can_marker.global_position
			item.rotation = Vector3(0, 0, 0)
			item.freeze = true
	
	await get_tree().create_timer(0.1).timeout
	picked_item = item

func drop_item() -> void:
	picked_item.reparent(get_tree().current_scene)
	picked_item.freeze = false
	picked_item = null
