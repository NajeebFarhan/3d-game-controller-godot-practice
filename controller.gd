extends CharacterBody3D

@export var speed = 5.0
@export var jump_velocity = 4.5

@export var sensitivity = 1.0
@export var zoom_sensitivity = 0.3
@export var max_zoom = 8
@export var min_zoom = 3

	
func view_orientation(x, y):
	var camera = $CameraOrigin
	var strength_x = deg_to_rad(x * sensitivity)
	var strength_y = deg_to_rad(y * sensitivity)
		
	rotate_y(strength_x)
		
	camera.rotate_x(strength_y)
	camera.rotation.x = clamp(camera.rotation.x, -PI/6, PI/6)

	
func zoom():
	var springarm = $CameraOrigin/SpringArm3D
	if Input.is_action_pressed("zoom_in"):
		springarm.spring_length -= zoom_sensitivity
	if Input.is_action_pressed("zoom_out"):
		springarm.spring_length += zoom_sensitivity
	
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
	zoom()
	
	jump()
		
	var direction = transform.basis * Vector3(
		input_vector.x, 0, input_vector.y
	).normalized()
	
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	
	move_and_slide()
