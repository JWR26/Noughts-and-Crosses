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


func get_type() -> TYPE:
	return type


func is_placed_at(coordinate: Vector2) -> bool:
	print(coordinate, " - ", global_position)
	return global_position.x == coordinate.y and global_position.z == coordinate.x
