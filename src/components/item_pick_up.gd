class_name ItemPickUp
extends Area2D

signal scored(type, points)

func _ready() -> void:
	connect('area_entered', self, '_on_area_entered')

func _on_area_entered(area: Area2D) -> void:
	var pickup_item := area as PickUpItem
	if not pickup_item:
		return
	
	pickup_item.get_parent().remove_child(pickup_item)
	pickup_item.queue_free()
	
	emit_signal('scored', pickup_item.type, pickup_item.points)
