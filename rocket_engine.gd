extends Sprite2D

var shader_material: ShaderMaterial
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shader_material = self.material as ShaderMaterial


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var h = lerp(1.45, 1.6, randf())
	shader_material.set_shader_parameter("flame_height", h)
