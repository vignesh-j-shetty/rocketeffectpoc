extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for node in self.get_children():
		if node.name == "WorldEnvironment":
			continue
		if node.name != "RocketEngine":
			node.modulate =  Color(0.7, 0.7, 0.7)
			
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
