extends KinematicBody


export var acceleration = 20
export var gravity = -40
export var speed = 70
export var friction = 60
export var mouse_sensitivity = 0.1
export var jump_impulse = 30

var velocity = Vector3.ZERO
var direction = Vector3()

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
	
	direction = Vector3()

	if Input.is_action_pressed("right"):
		direction += transform.basis.x
	if Input.is_action_pressed("left"):
		direction -= transform.basis.x
	if Input.is_action_pressed("backward"):
		direction += transform.basis.z
	if Input.is_action_pressed("forward"):
		direction -= transform.basis.z

	if direction != Vector3():
		$Camera/AnimationPlayer.play("Head_bob")
		
	velocity = velocity.linear_interpolate(direction*speed , acceleration *delta )
	velocity = move_and_slide(velocity, Vector3.UP)
	
	
	
	
	apply_gravity(delta)
	
func apply_gravity(delta):
		velocity.y += gravity * delta
		velocity.y = clamp(velocity.y, gravity, jump_impulse)
		


