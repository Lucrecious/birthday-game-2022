extends Node

const GameScene := preload('res://src/game.tscn')

onready var _nick_button := $Background/Margin/Control/Starts/Nick as ToolButton
onready var _stelios_button := $Background/Margin/Control/Starts/Stelios as ToolButton

onready var _nick_sprite := $Background/Margin/Control/Nick as Node2D
onready var _stelios_sprite := $Background/Margin/Control/Stelios as Node2D

onready var _countdown_label := $Background/Margin/Control/Center/Countdown as Label
onready var _countdown_center := $Background/Margin/Control/Center as Control

onready var _fade_out := $FadeOut as ColorRect

onready var _start_timer := NodE.add_child(self, TimEr.one_shot(5.0, self, '_on_start_timeout')) as Timer
onready var _tween := NodE.add_child(self, Tween.new()) as Tween

func _ready() -> void:
	_nick_button.connect('button_down', self, '_on_button_down', [_nick_sprite])
	_stelios_button.connect('button_down', self, '_on_button_down', [_stelios_sprite])
	
	_nick_button.connect('button_up', self, '_on_button_up', [_nick_sprite, _nick_sprite.global_position])
	_stelios_button.connect('button_up', self, '_on_button_up', [_stelios_sprite, _stelios_sprite.global_position])
	
	_countdown_label.visible = false

func _on_button_down(sprite: Node2D) -> void:
	_start_timer.start()
	
	_countdown_label.visible = true
	
	_tween.remove_all()
	
	var center := _countdown_center.rect_global_position + _countdown_center.rect_size / 2.0
	
	_tween.interpolate_property(sprite, 'global_position', null, center + Vector2.UP * 150.0, .2, Tween.TRANS_CUBIC)
	_tween.start()

func _on_button_up(sprite: Node2D, position: Vector2) -> void:
	_start_timer.stop()
	
	_countdown_label.visible = false
	
	_tween.remove_all()
	_tween.interpolate_property(sprite, 'global_position', null, position, .2, Tween.TRANS_CUBIC)
	_tween.start()

func _process(delta: float) -> void:
	_countdown_label.text = str(ceil(_start_timer.time_left))

func _on_start_timeout() -> void:
	_nick_button.disconnect('button_down', self, '_on_button_down')
	_nick_button.disconnect('button_up', self, '_on_button_up')
	_stelios_button.disconnect('button_down', self, '_on_button_down')
	_stelios_button.disconnect('button_up', self, '_on_button_up')
	
	var play_scene := GameScene.instance()
	
	if _nick_button.pressed:
		play_scene.mode = GameMode.Name.Nick
	elif _stelios_button.pressed:
		play_scene.mode = GameMode.Name.Stelios
	
	var tween := Tween.new()
	tween.interpolate_property(_fade_out, 'modulate:a', 0.0, 1.0, 1.0, Tween.TRANS_EXPO, Tween.EASE_IN)
	tween.interpolate_callback(self, 1.5, '_transition_to_game_scene', play_scene)
	add_child(tween)
	tween.start()

func _transition_to_game_scene(game_scene: Node) -> void:
	get_tree().root.add_child(game_scene)
	get_parent().remove_child(self)
	queue_free()
