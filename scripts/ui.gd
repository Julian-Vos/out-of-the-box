extends CanvasLayer

@onready var player = $'../Player'

func animate(position):
	if visible:
		return
	
	visible = true
	
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT).set_parallel(true)
	var anchor_origin = get_viewport().canvas_transform * position / get_viewport().get_visible_rect().size
	
	tween.tween_property($ColorRect, 'anchor_left', 0, 0.65).from(anchor_origin.x)
	tween.tween_property($ColorRect, 'anchor_top', 0, 0.65).from(anchor_origin.y)
	tween.tween_property($ColorRect, 'anchor_right', 1, 0.65).from(anchor_origin.x)
	tween.tween_property($ColorRect, 'anchor_bottom', 1, 0.65).from(anchor_origin.y)
	tween.tween_property($ColorRect, 'modulate:a', 1, 0.65).from(0.5)
	
	$VBoxContainer.visible = true

func _on_button_pressed():
	$VBoxContainer.visible = false
	
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	
	tween.tween_property($ColorRect, 'modulate:a', 0, 0.35)
	tween.tween_callback(func(): visible = false)
	
	player.position.x = -700
	player.position.y = 4
	
	player.enabled = true
