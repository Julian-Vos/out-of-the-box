extends CanvasLayer

const LEVEL_NAMES = [
	'Left behind',
	"Hold up, what's going on?",
	'Out of sight, out of mind',
	'It starts to click',
	"Let's try the fourth direction",
	'Just stay calm now',
	"They're dragging this out",
	'Over and out',
	'0ut 0f the b0x',
]
const GREEN = Color8(106, 190, 48, 128)
const TRANSPARENT = Color(0, 0, 0, 0)

var level_name_tween

@onready var player = $'../Player'
@onready var start_ticks_msec = Time.get_ticks_msec()

func _ready():
	show_current_level_name()

func show_current_level_name():
	if level_name_tween != null:
		level_name_tween.kill()
	
	level_name_tween = create_tween().set_trans(Tween.TRANS_SINE)
	
	level_name_tween.tween_property($Label, 'anchor_top', 0.25, 0.5).from(0.2)
	level_name_tween.parallel()
	level_name_tween.tween_property($Label, 'anchor_bottom', 0.25, 0.5).from(0.2)
	level_name_tween.parallel()
	level_name_tween.tween_property($Label, 'modulate:a', 1, 0.5).from(0)
	level_name_tween.tween_property($Label, 'anchor_top', 0.3, 0.5).set_delay(5)
	level_name_tween.parallel()
	level_name_tween.tween_property($Label, 'anchor_bottom', 0.3, 0.5).set_delay(5)
	level_name_tween.parallel()
	level_name_tween.tween_property($Label, 'modulate:a', 0, 0.5).set_delay(5)
	
	var current_level = get_parent().current_level
	
	$Label.text = 'Level %d: %s' % [current_level, LEVEL_NAMES[current_level - 1]]
	$Label.visible = true

func animate_win(position):
	if $ColorRect.visible:
		return
	
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT).set_parallel()
	var anchor_origin = get_viewport().canvas_transform * position / get_viewport().get_visible_rect().size
	
	tween.tween_property($ColorRect, 'anchor_left', 0, 0.65).from(anchor_origin.x)
	tween.tween_property($ColorRect, 'anchor_top', 0, 0.65).from(anchor_origin.y)
	tween.tween_property($ColorRect, 'anchor_right', 1, 0.65).from(anchor_origin.x)
	tween.tween_property($ColorRect, 'anchor_bottom', 1, 0.65).from(anchor_origin.y)
	tween.tween_property($ColorRect, 'modulate', Color.BLACK, 0.65).from(GREEN)
	
	$ColorRect.visible = true
	$VBoxContainer.visible = true

func _on_retry_pressed():
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	
	tween.tween_property($ColorRect, 'modulate:a', 0, 0.35)
	tween.tween_callback(func(): $ColorRect.visible = false)
	
	player.position = get_parent().get_current_level_retry_position()
	player.enabled = true
	
	show_current_level_name()
	
	$VBoxContainer.visible = false

func animate_end():
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	
	tween.tween_property($ColorRect, 'modulate', Color.BLACK, 5).from(TRANSPARENT)
	tween.parallel()
	tween.tween_property($VBoxContainer, 'modulate:a', 1, 5).from(0)
	tween.tween_callback(func(): player.set_physics_process(false))
	
	$ColorRect.visible = true
	
	var seconds = (Time.get_ticks_msec() - start_ticks_msec) / 1000
	var minutes = seconds / 60
	
	seconds -= minutes * 60
	
	$VBoxContainer/Message.text = '[center]You escaped the box by finding all 9 [color=#639bff]secrets[/color]! It only took you %02d:%02d. Thanks for playing my game <3[/center]' % [minutes, seconds]
	$VBoxContainer/Message.add_theme_font_size_override('normal_font_size', 50)
	
	$VBoxContainer/Retry.visible = false
	$VBoxContainer/Links.visible = true
	$VBoxContainer.visible = true
