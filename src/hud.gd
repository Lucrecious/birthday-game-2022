extends CanvasLayer

export(NodePath) var _game_path := NodePath()
export(NodePath) var _score_number_label_path := NodePath()

onready var _game := NodE.get_node_with_error(self, _game_path, Node2D) as Node2D
onready var _score_number_label := NodE.get_node_with_error(self, _score_number_label_path, Label) as Label

func _ready() -> void:
	_game.connect('points_changed', self, '_on_points_changed')
	_on_points_changed()

func _on_points_changed() -> void:
	_score_number_label.text = str(_game.total_points) 
