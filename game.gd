extends Node3D

const NOUGHT_START_POSITIONS: PackedVector3Array = [
	Vector3(-3, 0, -1),
	Vector3(-4.5, 0, -2),
	Vector3(-1, 0, -2.5),
	Vector3(-3, 0, -3),
	Vector3(-5, 0, 0)
]
const CROSS_START_POSITIONS: PackedVector3Array = [
	Vector3(7,0,5),
	Vector3(8.5,0,6),
	Vector3(5,0,6.5),
	Vector3(7,0,7),
	Vector3(9,0,4)
]

const MOVE_DELAY:float = 1.0
const ROTATION_DELAY:float = 2.0

var ai: AIPlayer
var is_player_turn: bool = true
var moved_pieces: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	
	ai = AIPlayer.new($Board)
	
	EventBus.move_piece.connect(_on_move_piece)
	add_piece(Piece.TYPE.NOUGHT)
	add_piece(Piece.TYPE.CROSS)
	EventBus.player_turn.emit()


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
	var new_rotation = Vector3(0, 180, 0) if is_player_turn else Vector3.ZERO
	tween.tween_property($CameraPivotPoint, "rotation_degrees", new_rotation, ROTATION_DELAY).set_trans(Tween.TRANS_CUBIC).set_delay(MOVE_DELAY)


func _on_move_piece(pos: Vector3) -> void:
	var piece_type: Piece.TYPE = Piece.TYPE.NOUGHT if is_player_turn else Piece.TYPE.CROSS
	move_piece_to(pos, piece_type)
	$Board.update_board(pos, piece_type)
	
	var winning_line = $Board.get_winner()
	
	if winning_line:
		print(winning_line)
		await get_tree().create_timer(ROTATION_DELAY + MOVE_DELAY).timeout
		animate_winning_line(winning_line, piece_type)
	elif not $Board.is_board_full():
		#rotate_camera()
		await get_tree().create_timer(ROTATION_DELAY + MOVE_DELAY).timeout
		change_turn()


func change_turn() -> void:
	if is_player_turn:
		is_player_turn = false
		EventBus.ai_turn.emit()
	else:
		is_player_turn = true
		EventBus.player_turn.emit()


func animate_winning_line(line: PackedVector2Array, piece_type: Piece.TYPE) -> void:
	
	for child in get_children():
		child = child as Piece
		if child is Piece and child.get_type() == piece_type:
			for pos in line:
				if child.is_placed_at(pos):
					var tween: Tween = get_tree().create_tween()
					var original_pos: Vector3 = child.position
					var hover_pos: Vector3 = Vector3(pos.y, 1.0, pos.x)
					tween.tween_property(child, "position", hover_pos, MOVE_DELAY/2).set_trans(Tween.TRANS_CUBIC)
					tween.tween_property(child, "position", original_pos, MOVE_DELAY/2).set_trans(Tween.TRANS_CUBIC).set_delay(MOVE_DELAY)
