extends Area2D

@onready var ui = $'../../UI'

func _on_area_entered(area):
	area.get_parent().enabled = false
	
	if !ui.get_node('ColorRect').visible:
		ui.animate_win(global_position + Vector2(10.5, -50))
		
		$AudioStreamPlayer.play()
