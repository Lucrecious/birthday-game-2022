extends CanvasLayer

export(NodePath) var _game_path := NodePath()

onready var _game := NodE.get_node_with_error(self, _game_path, Node2D) as Node2D
onready var _score_number_label := $Margin/Control/HBox/ScoreNumber as Label
onready var _tutorial_label := $Margin/Control/Center/Tutorial as Label

func _ready() -> void:
	_game.connect('points_changed', self, '_on_points_changed')
	_on_points_changed()
	
	_game.connect('started', self, '_on_game_started', [], CONNECT_ONESHOT)

func _on_points_changed() -> void:
	_score_number_label.text = str(_game.total_points) 

func _on_game_started() -> void:
	_tutorial_label.visible = false
