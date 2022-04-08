extends AnimationPlayer

onready var _jump := NodE.get_sibling_with_error(self, InfiniteRunnerJump) as InfiniteRunnerJump

func _ready() -> void:
	_jump.connect('floor_left', self, '_on_floor_left')
	_jump.connect('floor_hit', self, '_on_floor_hit')
	_jump.connect('vertical_direction_changed', self, '_on_vertical_direction_changed')
	
	_on_floor_left()

func _on_vertical_direction_changed() -> void:
	if _jump.is_on_floor():
		return
	
	_on_floor_left()

func _on_floor_left() -> void:
	if _jump.velocity.y < -0.1:
		play('rise')
		return
	
	play('to_fall')

func _on_floor_hit() -> void:
	play('run')
