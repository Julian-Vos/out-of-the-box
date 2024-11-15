extends Node2D

const RED = Color8(172, 50, 50)
const YELLOW = Color8(251, 242, 54)
const HALF_DIAGONAL_LENGTH = sqrt(48 ** 2 + 96 ** 2)

func _ready():
	for c in 6:
		for r in 12:
			var sprite = Sprite2D.new()
			
			sprite.texture = preload('res://assets/player_fragment.png')
			sprite.position.x = c * 16 - 40
			sprite.position.y = r * 16 - 88
			
			add_child(sprite)

func animate(on_finished, speed):
	modulate = RED
	
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	
	tween.tween_property(self, 'modulate', YELLOW, 0.65)
	tween.parallel()
	tween.tween_property(self, 'position', Vector2.ZERO, 0.65)
	tween.tween_callback(on_finished)
	
	var children_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	for child in get_children():
		var closest_point_h = Geometry2D.get_closest_point_to_segment_uncapped(child.position, Vector2.ZERO, position)
		var closest_point_v = Geometry2D.get_closest_point_to_segment_uncapped(child.position, Vector2.ZERO, position.rotated(PI / 2))
		var offset_h = (child.position - closest_point_h) * sin((1 - closest_point_h.length() / HALF_DIAGONAL_LENGTH) * PI / 2) * speed / 500
		var offset_v = (child.position - closest_point_v) * 1.05
		
		children_tween.parallel()
		children_tween.tween_property(child, 'offset', offset_h + offset_v, 0.2)
	
	children_tween.set_ease(Tween.EASE_IN)
	
	for child in get_children():
		children_tween.tween_property(child, 'offset', Vector2.ZERO, 0.45)
		children_tween.parallel()
