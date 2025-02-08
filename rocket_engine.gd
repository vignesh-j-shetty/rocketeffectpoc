extends Sprite2D

var shader_material: ShaderMaterial

var flame_height: float = 1.0
const HEIGHT_MIN: float = 0.5
const HEIGHT_MAX: float = 1.4
const HEIGHT_STEP: float = 0.05

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shader_material = self.material as ShaderMaterial


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var flicker = randf() * 0.09 - 0.25
	var dynamic_height = clamp(flame_height + flicker, HEIGHT_MIN, HEIGHT_MAX)
	shader_material.set_shader_parameter("flame_height", dynamic_height)
	_process_input()
	
func _process_input() -> void:
	if Input.is_action_pressed("ui_up"):
		flame_height = clamp(flame_height + HEIGHT_STEP, HEIGHT_MIN, HEIGHT_MAX)
	elif Input.is_action_pressed("ui_down"):
		flame_height = clamp(flame_height - HEIGHT_STEP, HEIGHT_MIN, HEIGHT_MAX)
