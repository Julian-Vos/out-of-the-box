extends Area2D

func _on_area_entered(area):
	area.get_parent().enabled = false
	
	$'../../UI'.animate(global_position + Vector2(10.5, -50))
