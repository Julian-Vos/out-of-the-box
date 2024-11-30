extends Area2D

func _on_area_entered(area):
	area.get_parent().enabled = false
	
	$'../../UI'.animate_win(global_position + Vector2(10.5, -50))
	
	$AudioStreamPlayer.play()
