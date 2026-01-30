extends CharacterBody3D

@export var speed = 6.0
@export var jump_velocity = 6.0

@export var sensitivity = 1.0
@export var zoom_sensitivity = 0.3
@export var max_zoom = 8
@export var min_zoom = 3

@onready var camera = $CameraOrigin
@onready var springarm = $CameraOrigin/SpringArm3D
	
func view_orientation(x: float, y: float):
	var strength_x = deg_to_rad(x * sensitivity)
	var strength_y = deg_to_rad(y * sensitivity)
		
	camera.rotate_y(strength_x)
	camera.rotate_x(strength_y)
	camera.rotation.x = clamp(camera.rotation.x, -PI/6, PI/6)
	camera.rotation.z = 0

	
func zoom(zoom_in_strength: float, zoom_out_strength: float):
	springarm.spring_length -= zoom_sensitivity * zoom_in_strength
	springarm.spring_length += zoom_sensitivity * zoom_out_strength
	
	springarm.spring_length = clamp(
		springarm.spring_length, 
		min_zoom, 
		max_zoom,
	)
	

func jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		view_orientation(-event.relative.x, -event.relative.y)
		
	if event is InputEventMouseButton:
		var zoom_in = int(event.button_index == MouseButton.MOUSE_BUTTON_WHEEL_UP)
		var zoom_out = int(event.button_index == MouseButton.MOUSE_BUTTON_WHEEL_DOWN)
		zoom(zoom_in, zoom_out)
		
		
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	
	if not is_on_floor():
		velocity.y += get_gravity().y * delta	
		
	var input_vector = Input.get_vector(
		"move_left", 
		"move_right", 
		"move_forward", 
		"move_backward",
	)
	
	var joy_view_vector = Input.get_vector(
		"joy_right_x_neg", 
		"joy_right_x_pos",
		"joy_right_y_pos",
		"joy_right_y_neg",
	)
	
	
	view_orientation(-joy_view_vector.x, -joy_view_vector.y)
	zoom(
		Input.get_action_raw_strength("zoom_in"), 
		Input.get_action_raw_strength("zoom_out"),
	)
	
	jump()
		
	var input_dir = Vector3(input_vector.x, 0, input_vector.y)
		
	var cam_basis = camera.global_basis
	
	var move_dir = cam_basis * input_dir
	move_dir.y = 0
	
	if move_dir and is_on_floor():
		$Shape.rotation.y = -atan2(move_dir.x, -move_dir.z)
		
		velocity.x = move_dir.x * speed
		velocity.z = move_dir.z * speed
	elif is_on_floor():
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		
	move_and_slide()
