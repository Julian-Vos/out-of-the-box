extends Area2D

func _on_area_entered(area):
	area.get_parent().enabled = false
	
	$'../UI'.animate(position + Vector2(10.5, -50))
