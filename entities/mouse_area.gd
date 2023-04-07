class_name MouseArea

extends Area3D


var selected := false


func _on_mouse_entered() -> void:
	if not selected:
		var piece = Piece.new(Piece.TYPE.NOUGHT)
		add_child(piece)


func _on_mouse_exited() -> void:
	for child in get_children():
		if child is Piece:
			child.queue_free()


func _on_input_event(_camera: Node, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	var input := event as InputEventMouseButton
	if not input:
		return
	
	if input.pressed:
		selected = true
		EventBus.move_piece.emit(global_position)
