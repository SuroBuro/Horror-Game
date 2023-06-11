extends Spatial

export var max_speed = 10
export var acceleration = 60
export var friction = 60
export var gravity = -40
export var jump_impulse = 30
export var mouse_sensitivity = 0.1

var velocity = Vector3.ZERO
 
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel") and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event.is_action_pressed("Use") and Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		$Camera.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		$Camera.rotation.x = clamp($Camera.rotation.x , deg2rad(-75), deg2rad(75))
	
	
	
func _physics_process(delta):
	var input_vector = get_input_vector()
	var direction = get_direction(input_vector)
	
	apply_gravity(delta)
	apply_movement(input_vector,direction,delta)
	pass;

func apply_friction(delta, direction):
	if direction == Vector3.ZERO :
		velocity = velocity.move_toward(Vector3.ZERO , friction * delta)
	

func get_input_vector():
	var input_vector = Vector3.ZERO
	input_vector.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vector.y = Input.get_action_strength("forward") - Input.get_action_strength("backward")
	return input_vector.normalized() if input_vector.length() > 1 else input_vector
	
func apply_movement(_input_vector, direction, delta):
	if direction != Vector3.ZERO:
		velocity.x = velocity.move_toward(direction * max_speed , acceleration * delta).x
		velocity.z = velocity.move_toward(direction * max_speed, acceleration * delta).z 
	
func get_direction(input_vector):
	var direction = (input_vector.x * transform.basis.x) + (input_vector.z * transform.basis.z)
	return direction
	
func apply_gravity(delta):
	velocity.y += gravity * delta
	velocity.y = clamp(velocity.y , gravity, jump_impulse)
	

