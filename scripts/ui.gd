extends CanvasLayer

const GREEN = Color8(106, 190, 48, 128)
const TRANSPARENT = Color(0, 0, 0, 0)

@onready var player = $'../Player'
@onready var start_ticks_msec = Time.get_ticks_msec()

func animate_win(position):
	if visible:
		return
	
	visible = true
	
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT).set_parallel(true)
	var anchor_origin = get_viewport().canvas_transform * position / get_viewport().get_visible_rect().size
	
	tween.tween_property($ColorRect, 'anchor_left', 0, 0.65).from(anchor_origin.x)
	tween.tween_property($ColorRect, 'anchor_top', 0, 0.65).from(anchor_origin.y)
	tween.tween_property($ColorRect, 'anchor_right', 1, 0.65).from(anchor_origin.x)
	tween.tween_property($ColorRect, 'anchor_bottom', 1, 0.65).from(anchor_origin.y)
	tween.tween_property($ColorRect, 'modulate', Color.BLACK, 0.65).from(GREEN)
	
	$VBoxContainer.visible = true

func _on_retry_pressed():
	$VBoxContainer.visible = false
	
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	
	tween.tween_property($ColorRect, 'modulate:a', 0, 0.35)
	tween.tween_callback(func(): visible = false)
	
	player.position = get_parent().get_current_level_retry_position()
	
	player.enabled = true

func animate_end():
	visible = true
	
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	
	tween.tween_property($ColorRect, 'modulate', Color.BLACK, 5).from(TRANSPARENT)
	tween.parallel()
	tween.tween_property($VBoxContainer, 'modulate:a', 1, 5).from(0)
	tween.tween_callback(func(): player.set_physics_process(false))
	
	var seconds = (Time.get_ticks_msec() - start_ticks_msec) / 1000
	var minutes = seconds / 60
	
	seconds -= minutes * 60
	
	$VBoxContainer/Message.text = '[center]You escaped the box by finding all 9 [color=#639bff]secrets[/color]! It only took you %02d:%02d. Thanks for playing my game <3[/center]' % [minutes, seconds]
	$VBoxContainer/Message.add_theme_font_size_override('normal_font_size', 50)
	
	$VBoxContainer/Retry.visible = false
	$VBoxContainer/Links.visible = true
	$VBoxContainer.visible = true
