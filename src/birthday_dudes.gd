extends Node2D

func init_mode(mode: int) -> void:
	var dudes := NodE.get_children(self, BirthdayDude)
	ObjEct.group_call(dudes, 'init_mode', [mode])
