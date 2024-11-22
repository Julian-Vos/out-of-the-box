extends CharacterBody2D

const ACCELERATION_PER_SECOND = 5000
const MAX_SPEED_PER_SECOND = 500
const GRAVITY_PER_SECOND = 3750
const COYOTE_MILLISECONDS = 75
const JUMP_STRENGTH = 1350

var enabled = true
var fell_at
var disable_one_way_collision_on_land = false

@onready var tile_map_layer = $'../TileMapLayer'

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
		if get_parent().current_level == 5 && enabled && Input.is_action_just_pressed('down'):
			var tile_data_left = tile_map_layer.get_cell_tile_data(tile_map_layer.local_to_map(position + Vector2(-40, 171)))
			var tile_data_center = tile_map_layer.get_cell_tile_data(tile_map_layer.local_to_map(position + Vector2(0, 171)))
			var tile_data_right = tile_map_layer.get_cell_tile_data(tile_map_layer.local_to_map(position + Vector2(40, 171)))
			
			if tile_data_left == null && tile_data_center == null && tile_data_right == null:
				tile_map_layer.tile_set.get_source(0).get_tile_data(Vector2.ZERO, 0).set_collision_polygon_one_way(0, 0, true)
				
				set_deferred('disable_one_way_collision_on_land', true)
				set_deferred('position', position + Vector2.DOWN)
		
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
		elif get_parent().current_level == 2 && velocity.y > -JUMP_STRENGTH / 4.0 && velocity.y < 0:
			velocity.y = -JUMP_STRENGTH / 4.0
	
	if move_and_slide() && disable_one_way_collision_on_land:
		disable_one_way_collision_on_land = false
		
		tile_map_layer.tile_set.get_source(0).get_tile_data(Vector2.ZERO, 0).set_collision_polygon_one_way(0, 0, false)

func _on_area_2d_body_entered(_body):
	var current_level_retry_position = get_parent().get_current_level_retry_position()
	
	$PlayerFragments.position = position - current_level_retry_position
	
	position = current_level_retry_position
	
	enabled = false
	
	$Sprite2D.visible = false
	$PlayerFragments.visible = true
	
	$PlayerFragments.animate(
		func():
			enabled = true
			
			$Sprite2D.visible = true
			$PlayerFragments.visible = false,
		velocity.length() / 500
	)
	
	velocity.x = 0
	velocity.y = 0
