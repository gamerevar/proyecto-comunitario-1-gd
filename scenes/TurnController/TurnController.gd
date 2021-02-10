extends Node


enum Queue {
	SOLDIERS,
	ENEMIES,
}


var _unit_queues: Dictionary
var _current_queue: int
var _current_unit_index: int


func _ready() -> void:
	yield(get_tree().root, "ready")

	_unit_queues = {
		Queue.SOLDIERS: _get_soldiers(),
		Queue.ENEMIES: _get_enemies(),
	}
	_current_queue = Queue.SOLDIERS
	_current_unit_index = 0
	
	for queue in _unit_queues:
		for unit in _unit_queues[queue]:
			unit.connect("end_of_action", self, "_on_unit_end_of_action")
			unit.connect("death", self, "_on_unit_death")
	
	select_next_unit()


func select_next_unit() -> void:
	var unit: Unit = _get_next_unit()
	if unit:
		unit.select()


func _get_next_unit() -> Unit:
	var unit_index: int = _current_unit_index
	
	while _unit_queues[_current_queue][unit_index].action_points == 0:
		unit_index = _get_next_unit_index(unit_index)
		if unit_index == _current_unit_index:
			return _get_first_unit_in_next_queue()
	_current_unit_index = _get_next_unit_index(unit_index)
	
	return _unit_queues[_current_queue][unit_index]


func _get_next_unit_index(unit_index: int) -> int:
	return wrapi(unit_index + 1, 0, _unit_queues[_current_queue].size())


func _get_first_unit_in_next_queue() -> Unit:
	_move_to_next_queue()
	
	return _get_next_unit() if _unit_queues[_current_queue].size() > 0 else null


func _move_to_next_queue() -> void:
	_refill_action_points_in_queue(_current_queue)
	if _current_queue == Queue.SOLDIERS:
		_current_queue = Queue.ENEMIES
	else:
		_current_queue = Queue.SOLDIERS
	_current_unit_index = 0


func _refill_action_points_in_queue(queue: int) -> void:
	for unit in _unit_queues[queue]:
		unit.refill_action_points()


func _get_soldiers() -> Array:
	return get_tree().get_nodes_in_group("Soldiers")


func _get_enemies() -> Array:
	return get_tree().get_nodes_in_group("Enemies")


func _on_unit_end_of_action() -> void:
	select_next_unit()


func _on_unit_death(dead_unit: Unit) -> void:
	if dead_unit:
		var position: int = _unit_queues[Queue.SOLDIERS].find(dead_unit)
		var queue: int
		
		if position == -1:
			position = _unit_queues[Queue.ENEMIES].find(dead_unit)
			queue = Queue.ENEMIES
		else:
			queue = Queue.SOLDIERS
		
		if position != -1:
			_unit_queues[queue].remove(position)
