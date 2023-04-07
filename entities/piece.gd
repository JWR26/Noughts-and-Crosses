class_name Piece

extends Node3D


enum TYPE {
	NOUGHT,
	CROSS
}

var nought = preload("res://entities/nought.tscn")
var cross = preload("res://entities/cross.tscn")

var type:TYPE

func _init(t: TYPE, opacity: float = 1.0) -> void:
	self.type = t
	match self.type:
		TYPE.NOUGHT:
			self.add_child(nought.instantiate())
		TYPE.CROSS:
			self.add_child(cross.instantiate())
	print(type)


func get_type() -> TYPE:
	return type
