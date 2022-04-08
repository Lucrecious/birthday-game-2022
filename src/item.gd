class_name PickUpItem
extends Area2D

enum Type {
	Regular,
	Alcohol,
}

export(Type) var type := Type.Regular

export(int) var points := 100
