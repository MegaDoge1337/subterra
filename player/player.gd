extends CharacterBody3D

@export_range(0.01, 1.0, 0.01) var mouse_sensitivity: float = 0.15;  # градусы на пиксель

@export var move_speed: float = 4.0      # м/с

# Высота прыжка считается по формуле h = v² / (2·g): обратная формула: v = sqrt(2·g·h)
@export var jump_velocity: float = 4.5   # м/с

@onready var camera_pivot: Node3D = %PlayerCameraPivot;

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE;
		return
	
	if (event is InputEventMouseButton and 
		event.is_pressed() and
		Input.mouse_mode != Input.MOUSE_MODE_CAPTURED):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED;
		return
	
	if (event is InputEventMouseMotion and
		Input.mouse_mode == Input.MOUSE_MODE_CAPTURED):
		var motion := event as InputEventMouseMotion;
		rotate_y(-deg_to_rad(motion.screen_relative.x * mouse_sensitivity));
		var pitch : float = camera_pivot.rotation.x - deg_to_rad(motion.screen_relative.y * mouse_sensitivity);
		camera_pivot.rotation.x = clampf(pitch, deg_to_rad(-89.999), deg_to_rad(89.999));
		return

func _physics_process(delta: float) -> void:
	# гравитация
	if not is_on_floor():
		velocity += get_gravity() * delta;
	
	if Input.is_action_just_pressed("jump"):
		velocity.y = jump_velocity;
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back");
	var direction = transform.basis * Vector3(input_dir.x, 0, input_dir.y);
	velocity.x = direction.x * move_speed;
	velocity.z = direction.z * move_speed;
	
	move_and_slide();
