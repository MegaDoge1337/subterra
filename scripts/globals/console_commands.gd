extends Node


func _ready() -> void:
	Console.add_command("noclip", noclip)


## Searchig for `ProtoController` node on current scene and enable freeflying.
func noclip() -> void:
	var scene_root = get_tree().root
	var player = scene_root.find_child("ProtoController", true, false)
	if player.freeflying:
		player.disable_freefly()
	else:
		player.enable_freefly()
