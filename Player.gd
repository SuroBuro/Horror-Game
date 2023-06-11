extends KinematicBody


export var gravity = -40
export var speed = 70
export var friction = 60
export var mouse_sensitivity = 0.1
export var jump_impulse = 30

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
		$Camera.rotation.x = clamp($Camera.rotation.x, deg2rad(-75), deg2rad(75))
		
		

func _physics_process(delta):
	var direction = Vector3.ZERO

	if Input.is_action_pressed("right"):
		direction.x += 1
	if Input.is_action_pressed("left"):
		direction.x -= 1
	if Input.is_action_pressed("backward"):
		direction.z += 1
	if Input.is_action_pressed("forward"):
		direction.z -= 1

	if direction != Vector3.ZERO:
		direction = direction.normalized()
		

	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	velocity = move_and_slide(velocity, Vector3.UP)
	
func apply_gravity(delta):
		velocity.y += gravity * delta
		velocity.y = clamp(velocity.y, gravity, jump_impulse)
		
