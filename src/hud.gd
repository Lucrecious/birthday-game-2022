extends CanvasLayer

export(NodePath) var _game_path := NodePath()

onready var _game := NodE.get_node_with_error(self, _game_path, Node2D) as Node2D
onready var _score_number_label := $Margin/Control/HBox/ScoreNumber as ScoreLabel
onready var _tutorial_label := $Margin/Control/Center/Tutorial as Label
onready var _drunk_shader := $DrunkShader as ColorRect

onready var _good_item_get_sound := $GoodItemGet as AudioStreamPlayer
onready var _bad_item_get_sound := $BadItemGet as AudioStreamPlayer

func _ready() -> void:
	_game.connect('points_changed', self, '_on_points_changed')
	_on_points_changed()
	
	_game.connect('drank_alcohol', self, '_on_drank_alcohol')
	
	_game.connect('started', self, '_on_game_started', [], CONNECT_ONESHOT)

var _current_total_points := 0
func _on_points_changed() -> void:
	if _game.total_points > _current_total_points:
		_good_item_get_sound.play()
	elif _game.total_points < _current_total_points:
		_bad_item_get_sound.play()
	
	_current_total_points = _game.total_points
	_score_number_label.set_score(_game.total_points)

func _on_game_started() -> void:
	_tutorial_label.visible = false

onready var _drunk_tween := NodE.add_child(self, Tween.new()) as Tween
func _on_drank_alcohol() -> void:
	_drunk_tween.remove_all()
	
	_drunk_tween.interpolate_method(self, '_set_drunkness', 0.0, 50.0, .5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	_drunk_tween.interpolate_method(self, '_set_drunkness', 50.0, 0.0, .5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 5.0)
	_drunk_tween.start()

func _set_drunkness(amount: float) -> void:
	_drunk_shader.material.set_shader_param('sprite_scale', Vector2(amount, amount))
