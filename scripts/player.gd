extends CharacterBody2D

const ACCELERATION_PER_SECOND = 5000
const MAX_SPEED_PER_SECOND = 500
const GRAVITY_PER_SECOND = 3750
const COYOTE_MILLISECONDS = 75
const JUMP_STRENGTH = 1350

var enabled = true
var fell_at

func _physics_process(delta):
	if enabled && Input.is_action_pressed('left'):
		velocity.x -= ACCELERATION_PER_SECOND * delta
	
	if enabled && Input.is_action_pressed('right'):
		velocity.x += ACCELERATION_PER_SECOND * delta
	
	if enabled && (Input.is_action_pressed('left') || Input.is_action_pressed('right')):
		velocity.x = clamp(velocity.x, -MAX_SPEED_PER_SECOND, MAX_SPEED_PER_SECOND)
	else:
		velocity.x -= min(ACCELERATION_PER_SECOND * delta, abs(velocity.x)) * sign(velocity.x)
	
	if is_on_floor():
		if fell_at != null:
			fell_at = null
			
			velocity.y = 0
	else:
		if fell_at == null:
			fell_at = Time.get_ticks_msec()
		
		velocity.y += GRAVITY_PER_SECOND * delta
	
	if enabled && Input.is_action_pressed('up'):
		if fell_at == null || Time.get_ticks_msec() - fell_at < COYOTE_MILLISECONDS:
			fell_at = 0
			
			velocity.y = -JUMP_STRENGTH
	
	move_and_slide()

func _on_area_2d_body_entered(_body):
	$PlayerFragments.position.x = position.x - -700
	$PlayerFragments.position.y = position.y - 4
	
	position.x = -700
	position.y = 4
	
	enabled = false
	
	$Sprite2D.visible = false
	$PlayerFragments.visible = true
	
	$PlayerFragments.animate(
		velocity.length() / 500,
		func():
			enabled = true
			
			$Sprite2D.visible = true
			$PlayerFragments.visible = false
	)
