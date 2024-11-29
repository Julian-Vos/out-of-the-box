@tool
extends Area2D

@export var size = Vector2(50, 50):
	set(value):
		size = value
		
		$CollisionShape2D.shape.size = size
@export var direction = Vector2(0, 0):
	set(value):
		direction = value
		
		$StaticBody2D.position = direction * size

func _on_area_entered(_area):
	$StaticBody2D/CollisionShape2D.set_deferred('disabled', false)
	
	var level = get_parent()
	var game = level.get_parent()
	
	if game.current_level == 7:
		game.get_node('Player').dragging_offset = null
	
	game.current_level = int(level.name.right(1)) + 1
	
	var ui = game.get_node('UI')
	var camera = game.get_node('Camera2D')
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	
	if game.current_level < 10:
		ui.current_level_new = true
		ui.show_current_level_name()
		
		tween.tween_property(camera, 'position', game.get_current_level_position(), 1)
	else:
		ui.animate_end()
		
		tween.tween_property(camera, 'zoom', Vector2(0.05, 0.05), 10).set_ease(Tween.EASE_OUT)
