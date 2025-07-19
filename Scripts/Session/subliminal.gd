extends Label

@export var list = [];
var time_since_change = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if list.is_empty():
		return
	time_since_change += delta;
	set_self_modulate(get_self_modulate() - Color8(0, 0, 0, 40));
	if time_since_change > 0.15:
		time_since_change = 0;
		get_node(".").text = list[randi() % list.size()];
		set_self_modulate(Color8(255, 255, 255, 255));
