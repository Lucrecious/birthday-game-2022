extends Node2D

signal points_changed

export(NodePath) var _player_path := NodePath()

onready var _player := get_node(_player_path)

var total_points := 0

func _ready() -> void:
	var item_pickup := NodE.get_child(_player, ItemPickUp) as ItemPickUp
	assert(item_pickup)
	
	item_pickup.connect('scored', self, '_on_player_scored')

func _on_player_scored(type: int, points: int) -> void:
	total_points += points
	emit_signal('points_changed')
