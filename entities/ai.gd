class_name AIPlayer

extends Node

var current_board: Board


func _init(b: Board) -> void:
	self.current_board = b
	EventBus.ai_turn.connect(play_turn)


func play_turn() -> void:
	#var move: Vector3 = minimax(current_board, true)
	
	var available_moves: PackedVector3Array = current_board.get_empty_squares()
	var move: Vector3 = available_moves[randi() % available_moves.size()]
	EventBus.move_piece.emit(move)


func minimax(board: Board, is_maximising: bool) -> Vector3:
	
	var available_moves: PackedVector3Array = board.get_empty_squares()
	
	
	var optimum_move: Vector3
	
	
	
	return optimum_move
