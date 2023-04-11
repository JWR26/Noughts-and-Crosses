class_name MouseArea

extends Area3D


var selected := false
var is_player_turn: bool = false


func _ready() -> void:
	EventBus.player_turn.connect(on_player_turn)
	EventBus.move_piece.connect(on_move_piece)


func hide_pieces() -> void:
	for child in get_children():
		if child is Piece:
			child.queue_free()


func _on_mouse_entered() -> void:
	if not selected and is_player_turn:
		var piece = Piece.new(Piece.TYPE.NOUGHT)
		add_child(piece)


func _on_mouse_exited() -> void:
	hide_pieces()


func on_player_turn() -> void:
	is_player_turn = true


func on_move_piece(pos: Vector3) -> void:
	is_player_turn = false
	if global_position == pos:
		selected = true


func _on_input_event(_camera: Node, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	var input := event as InputEventMouseButton
	if not input or not is_player_turn:
		return
	
	if input.pressed and not input.is_double_click() and not selected:
		hide_pieces()
		EventBus.move_piece.emit(global_position)
