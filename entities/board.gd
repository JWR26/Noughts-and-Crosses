class_name Board

extends CSGCombiner3D


const NOUGHT: String = "O"
const CROSS: String = "X"
const EMPTY: String = " "

const OFFSET: int = 2
const Y_OFFSET: float = 0.1
const ROWS: int = 3
const COLUMNS: int = 3

var current_board: Array = [[EMPTY, EMPTY, EMPTY], [EMPTY, EMPTY, EMPTY], [EMPTY, EMPTY, EMPTY]]


func get_current_board() -> Array:
	return current_board


func get_empty_squares() -> PackedVector3Array:
	var squares: PackedVector3Array = []
	
	for r in range(ROWS):
		for c in range(COLUMNS):
			if current_board[r][c] == EMPTY:
				squares.append(Vector3(c*OFFSET, Y_OFFSET, r*OFFSET))
	
	return squares


func get_winner() -> PackedVector2Array:
	# check the rows then colums for straight line
	for r in range(ROWS):
		if current_board[r][0] == current_board[r][1] and current_board[r][0] == current_board[r][2] and current_board[r][0] != EMPTY:
			return [Vector2(r * OFFSET,0 * OFFSET), Vector2(r * OFFSET,1 * OFFSET), Vector2(r * OFFSET,2 * OFFSET)]
	
	for c in range(COLUMNS):
		if current_board[0][c] == current_board[1][c] and current_board[0][c] == current_board[2][c] and current_board[0][c] != EMPTY:
			return [Vector2(0 * OFFSET,c * OFFSET), Vector2(1 * OFFSET,c * OFFSET), Vector2(2 * OFFSET,c * OFFSET)]
	
	# check diagonals
	if current_board[0][0] == current_board[1][1] and current_board[2][2] == current_board[0][0] and current_board[0][0] != EMPTY:
		return [Vector2(0 * OFFSET,0 * OFFSET), Vector2(1 * OFFSET,1 * OFFSET), Vector2(2 * OFFSET,2 * OFFSET)]
	if current_board[0][2] == current_board[1][1] and current_board[2][0] == current_board[0][2] and current_board[0][2] != EMPTY:
		return [Vector2(0 * OFFSET,2 * OFFSET), Vector2(1 * OFFSET,1 * OFFSET), Vector2(2 * OFFSET,0 * OFFSET)]
	
	return []


func is_board_full() -> bool:
	for r in range(ROWS):
		for c in range(COLUMNS):
			if current_board[r][c] == EMPTY:
				return false
	
	return true


func update_board(pos: Vector3, piece: Piece.TYPE) -> void:
	var row: int = int(pos.z) / OFFSET
	var column: int = int(pos.x) / OFFSET
	current_board[row][column] = NOUGHT if piece == Piece.TYPE.NOUGHT else CROSS
