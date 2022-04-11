class_name ScoreLabel
extends Label

var number_amount := 0

func set_score(amount: int) -> void:
	var from := number_amount
	number_amount = amount
	_update_text(from)

onready var _tween := NodE.add_child(self, Tween.new()) as Tween
func _update_text(from_amount: int) -> void:
	_tween.remove_all()
	
	var color := Color.forestgreen
	if number_amount < from_amount:
		color = Color.crimson
	
	_tween.interpolate_method(self, '_set_text', from_amount, number_amount, 1.0,
		Tween.TRANS_EXPO, Tween.EASE_OUT)
	
	_tween.interpolate_property(self, 'rect_scale', Vector2(1, 1), Vector2(1.5, 1.5), .25,
		Tween.TRANS_EXPO, Tween.EASE_OUT)
	_tween.interpolate_property(self, 'rect_scale', Vector2(1.5, 1.5), Vector2(1, 1), .25,
		Tween.TRANS_EXPO, Tween.EASE_OUT, .5)
	
	_tween.interpolate_property(self, 'modulate', Color.white, color, .25,
		Tween.TRANS_EXPO, Tween.EASE_OUT)
	_tween.interpolate_property(self, 'modulate', color, Color.white, .25,
		Tween.TRANS_EXPO, Tween.EASE_OUT, .5)
	
	
	_tween.start()

func _set_text(amount: int) -> void:
	text = str(amount)
