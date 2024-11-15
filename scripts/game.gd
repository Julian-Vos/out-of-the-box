extends Node

var current_level = 1

func get_current_level_position():
	return get_node('Level%d' % current_level).position

func get_current_level_retry_position():
	return get_node('Level%d/Retry' % current_level).global_position
