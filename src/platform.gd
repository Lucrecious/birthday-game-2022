tool
class_name LinePlatform
extends KinematicBody2D

export(float) var length := 200.0 setget _length_set
func _length_set(value: float) -> void:
	length = value
	update()

export(Color) var color := Color.black setget _color_set
func _color_set(value: Color) -> void:
	color = value
	update()

export(float) var height := 10.0 setget _height_set
func _height_set(value: float) -> void:
	height = value
	update()

func _ready() -> void:
	if Engine.editor_hint:
		return
	
	var line := Line2D.new()
	line.add_point(Vector2.ZERO)
	line.add_point(Vector2(length, 0))
	line.width = height / 2.0
	line.default_color = color
	line.joint_mode = Line2D.LINE_JOINT_ROUND
	line.begin_cap_mode = Line2D.LINE_CAP_ROUND
	line.end_cap_mode = Line2D.LINE_CAP_ROUND
	
	add_child(line)
	
	var collision := CollisionShape2D.new()
	
	var rectangle := RectangleShape2D.new()
	collision.shape = rectangle
	rectangle.extents = Vector2(length / 2.0, height / 4.0 - 1.0)
	collision.position = Vector2(length / 2.0, 0)
	collision.one_way_collision = true
	collision.one_way_collision_margin = 5.0
	
	add_child(collision)

func _draw():
	if not Engine.editor_hint:
		return
	
	draw_line(Vector2.ZERO, Vector2(length, 0), color, height)
