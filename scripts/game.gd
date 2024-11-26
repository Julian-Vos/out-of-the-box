extends Node

var current_level = 7

func _ready():
	$Camera2D.position = get_current_level_position()
	$Player.position = get_current_level_retry_position()

func get_current_level_position():
	return get_node('Level%d' % current_level).position

func get_current_level_retry_position():
	return get_node('Level%d/Retry' % current_level).global_position

func _unhandled_input(event):
	if current_level == 4 && event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
		var coords = $TileMapLayer.local_to_map(get_viewport().canvas_transform.affine_inverse() * event.position)
		
		if $TileMapLayer.get_cell_atlas_coords(coords) == Vector2i.RIGHT:
			$TileMapLayer.set_cell(coords)
