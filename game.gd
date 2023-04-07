extends Node3D

const NOUGHT_START_POSITIONS: PackedVector3Array = [
	Vector3(-2, 0, 0),
	Vector3(-1.75, 0, 2.5),
	Vector3(-4, 0, 1.75),
	Vector3(-4.5, 0, 0),
	Vector3(-3.5, 0, -2)
]
const CROSS_START_POSITIONS: PackedVector3Array = [
	Vector3(8,0,6),
	Vector3(9.5,0,7),
	Vector3(6,0,7.5),
	Vector3(8,0,8),
	Vector3(10,0,5)
]

const MOVE_DELAY:float = 1.0
const ROTATION_DELAY:float = 3.0

var moved_pieces: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.move_piece.connect(_on_move_piece)
	add_piece(Piece.TYPE.NOUGHT)
	add_piece(Piece.TYPE.CROSS)


func add_piece(type: Piece.TYPE) -> void:
	var positions: PackedVector3Array
	
	match type:
		Piece.TYPE.NOUGHT:
			positions = NOUGHT_START_POSITIONS
		Piece.TYPE.CROSS:
			positions = CROSS_START_POSITIONS
	
	for pos in positions:
		var p: Piece = Piece.new(type)
		add_child(p)
		p.set_global_position(pos)


func get_random_unmoved_piece(type: Piece.TYPE) -> Piece:
	var unmoved_piece: Array = []
	
	for child in get_children():
		child = child as Piece
		if child is Piece and moved_pieces.find(child) == -1 and child.get_type() == type:
			unmoved_piece.append(child)
	
	if unmoved_piece.size() == 0:
		return null
	
	return unmoved_piece[randi() % unmoved_piece.size()]


func move_piece_to(pos: Vector3, type: Piece.TYPE) -> void:
	var p = get_random_unmoved_piece(type)
	moved_pieces.append(p)
	
	var tween: Tween = get_tree().create_tween()
	var hover_pos: Vector3 = pos + Vector3.UP
	tween.tween_property(p, "position", hover_pos, MOVE_DELAY).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(p, "position", pos, MOVE_DELAY).set_trans(Tween.TRANS_CUBIC)


func rotate_camera() -> void:
	var tween: Tween = get_tree().create_tween()
	var new_rotation = Vector3.ZERO if ($CameraPivotPoint.rotation_degrees.y == 180) else Vector3(0, 180, 0)
	tween.tween_property($CameraPivotPoint, "rotation_degrees", new_rotation, ROTATION_DELAY).set_trans(Tween.TRANS_CUBIC).set_delay(MOVE_DELAY)


func _on_move_piece(pos: Vector3) -> void:
	print("move piece to:")
	print(pos)
	move_piece_to(pos, Piece.TYPE.NOUGHT)
	rotate_camera()

