class_name PlatformMover
extends Node2D

var speed := 100.0

func _ready() -> void:
	get_tree().connect('node_added', self, '_on_node_added')
	
	for child in get_children():
		if not child is LinePlatform:
			continue
		_add_moving_components(child as LinePlatform)

func _on_node_added(node: Node) -> void:
	if node.get_parent() != self:
		return
	
	var platform := node as LinePlatform
	if not platform:
		return
	
	_add_moving_components(platform)

func _add_moving_components(platform: LinePlatform) -> void:
	var move := PlatformMove.new()
	move.speed_pixels = speed
	move.direction = Vector2.LEFT
	
	platform.add_child(move)
