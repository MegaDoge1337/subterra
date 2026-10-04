extends Node


func _ready() -> void:
	Console.add_command("noclip", noclip)
	Console.add_command("controller-info", controller_info)

## Searching for player controller on scene.
func get_controller() -> Node:
	var scene_root = get_tree().root
	var protoController = scene_root.find_child("ProtoController", true, false)
	var theEagleController = scene_root.find_child("TheEagleController", true, false)
	if !protoController:
		return theEagleController
	return protoController

func controller_info() -> void:
	var controller = get_controller()
	if !controller:
		Console.print_error("No player controller on scene")
		return
	Console.print_line("Current controller: %s" % controller.name)

## Searchig for `ProtoController` node on current scene and enable freeflying.
func noclip() -> void:
	var controller = get_controller()
	if !controller:
		Console.print_error("No player controller on scene")
		return
	if controller.freeflying:
		controller.disable_freefly()
	else:
		controller.enable_freefly()
