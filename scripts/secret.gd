@tool
extends Area2D

@export var size = Vector2(20, 20):
	set(value):
		size = value
		
		$CollisionShape2D.shape.size = size

func _on_area_entered(_area):
	var level = get_parent()
	var game = level.get_parent()
	
	game.current_level = int(level.name.right(1)) + 1
	
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	
	tween.tween_property(game.get_node('Camera2D'), 'position', game.get_current_level_position(), 0.65)
