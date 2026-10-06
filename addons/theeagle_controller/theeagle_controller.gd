extends CharacterBody3D

@export_range(0.01, 1.0, 0.01) var mouse_sensitivity: float = 0.15;  # градусы на пиксель

@export var default_character_height : float = 1.8;
@export var default_move_speed: float = 4.0; # м/с
# Высота прыжка считается по формуле h = v² / (2·g): обратная формула: v = sqrt(2·g·h)
@export var jump_velocity: float = 4.5; # м/с
@export var freefly_speed: float = 10.0  # м/с
@export var sprint_speed: float = 7.0;

@export_group("camera_effects")
@export var fov_change_speed : float = 50.0;
@export var fov_sprint_increase : float = 5.0;

@export_group("crouch")
@export var crouch_character_height : float = 1.0;
@export var crouch_move_speed : float = 2.0;
@export var camera_crouch_speed : float = 6.0;

@onready var camera: Camera3D = %PlayerCamera;
@onready var camera_pivot: Node3D = %PlayerCameraPivot;
@onready var collider: CollisionShape3D = %PlayerCollider;
@onready var capsule: CapsuleShape3D = collider.shape as CapsuleShape3D
@onready var default_camera_fov : float = camera.fov;

var freeflying : bool = false;
var is_crouching : bool = false;
var is_sprinting : bool = false;

func get_current_move_speed() -> float:
	if (is_crouching and is_on_floor()):
		return crouch_move_speed;
	
	if is_sprinting:
		return sprint_speed;
	return default_move_speed;

func get_camera_target_height() -> float:
	if (is_crouching):
		var crouch_camera_target: float = crouch_character_height - 0.2;
		return crouch_camera_target;
	return default_character_height - 0.2;

func crouch() -> void:
	capsule.height = crouch_character_height;
	collider.position.y = crouch_character_height * 0.5;
	is_crouching = true;
	if (not is_on_floor()):
		shift_body_keep_camera(get_crouch_delta());
	
func uncrouch() -> void:
	capsule.height = default_character_height;
	collider.position.y = default_character_height * 0.5;
	is_crouching = false;
	if (not is_on_floor()):
		shift_body_keep_camera(-get_crouch_delta());

func can_uncrouch() -> bool:
	var test_direction: Vector3 = Vector3.UP if is_on_floor() else Vector3.DOWN;
	return not test_move(global_transform, test_direction * get_crouch_delta());

func shift_body_keep_camera(dy: float) -> void:
	global_position.y += dy;
	camera_pivot.position.y -= dy;

func get_crouch_delta() -> float:
	return default_character_height - crouch_character_height;

func handle_freefly(delta : float) -> void:
	var input_dir : Vector2 = get_input_dir();
	var move_dir : Vector3 = camera.global_basis * Vector3(input_dir.x, 0, input_dir.y);
	move_dir += Vector3.UP * Input.get_axis("crouch", "jump");
	move_dir = move_dir.normalized();
	global_position += move_dir * (freefly_speed * 3 if Input.is_action_pressed("sprint") else freefly_speed) * delta;

func get_input_dir() -> Vector2:
	return Input.get_vector("move_left", "move_right", "move_forward", "move_back");

func update_sprint_state() -> void:
	if not is_on_floor():
		return;
	
	if is_crouching:
		is_sprinting = false;
		return;
		
	is_sprinting = Input.is_action_pressed("sprint") and get_input_dir().y < 0;

func handle_camera_effects(delta : float) -> void:
	if is_sprinting:
		camera.fov = move_toward(camera.fov, default_camera_fov + fov_sprint_increase, fov_change_speed * delta);
		return;
	camera.fov = move_toward(camera.fov, default_camera_fov, fov_change_speed * delta);

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
	if freeflying:
		handle_freefly(delta);
		return;
	
	# гравитация
	if not is_on_floor():
		velocity += get_gravity() * delta;
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity;
	
	
	#crouching
	var crouch_pressed : bool = Input.is_action_pressed("crouch");
	if (crouch_pressed and not is_crouching):
		crouch();
	elif (not crouch_pressed and is_crouching and can_uncrouch()):
		uncrouch();
	var camera_target_height : float = get_camera_target_height();
	camera_pivot.position.y = move_toward(camera_pivot.position.y, camera_target_height, camera_crouch_speed * delta);
	
	update_sprint_state();
	
	var input_dir: Vector2 = get_input_dir();
	var move_dir: Vector3 = transform.basis * Vector3(input_dir.x, 0, input_dir.y);
	var move_speed: float = get_current_move_speed();
	velocity.x = move_dir.x * move_speed;
	velocity.z = move_dir.z * move_speed;
	handle_camera_effects(delta);
	move_and_slide();

func disable_freefly() -> void:
	freeflying = false;
	collider.disabled = false;
	velocity = Vector3.ZERO;

func enable_freefly() -> void:
	freeflying = true;
	collider.disabled = true;
	velocity = Vector3.ZERO;
	if (is_crouching):
		uncrouch();
		camera_pivot.position.y = get_camera_target_height();
