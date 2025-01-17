extends CharacterBody3D

const SPEED = 3.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.005

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D
@onready var interact_ray_cast: RayCast3D = $Head/Camera3D/InteractRayCast
@onready var grab_node: Node3D = null 

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Handle grab
	if Input.is_action_pressed("grab"):
		var collider = interact_ray_cast.get_collider()
		if collider is RigidBody3D:
			grab_node = collider
	
	if Input.is_action_just_released("grab"):
		grab_node = null
			
	if grab_node != null:
		grab_node.global_position = camera.global_position
		grab_node.global_position += -camera.global_transform.basis.z * 2

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = 0.0
		velocity.z = 0.0

	move_and_slide()
