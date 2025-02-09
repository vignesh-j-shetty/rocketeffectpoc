extends Sprite2D

var shader_material: ShaderMaterial
var fast_lite_noise: FastNoiseLite

var flame_height: float = 1.0
var smoke_speed: float = 1.8
var noise_freq = 0.0268
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shader_material = self.material as ShaderMaterial
	var noise_texture = NoiseTexture2D.new()
	fast_lite_noise = FastNoiseLite.new()
	fast_lite_noise.frequency = noise_freq
	noise_texture.noise = fast_lite_noise
	await noise_texture.changed
	shader_material.set_shader_parameter("noise_tex1", noise_texture)
	set_process_input(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var flicker = randf() * 0.09 - 0.25
	var dynamic_height = flame_height + flicker
	dynamic_height =  clamp(dynamic_height, 0.5, 1.4)
	shader_material.set_shader_parameter("flame_height", dynamic_height)
	shader_material.set_shader_parameter("effect_speed", smoke_speed)
	process_input()
	fast_lite_noise.frequency = noise_freq
	
func process_input() -> void:
	if Input.is_action_pressed("ui_up"):
		control_flame(1)
	elif Input.is_action_pressed("ui_down"):
		control_flame(-1)
		
func control_flame(dir):
	flame_height =  clamp(flame_height + (0.05 * dir), 0.5, 1.9)
	smoke_speed = clamp(smoke_speed + (0.05 * dir), 1.8, 2.2)
	if flame_height < 0.9:
		noise_freq = 0.0
	noise_freq = clamp(noise_freq + (0.005 * dir), 0.02, 0.08)
