extends CharacterBody3D
@onready var staminebar = $Camera3D/GUI/ProgressBar
var stamine = 100
@export var  SPEED = 5.0
const JUMP_VELOCITY = 4.5
@export var sensivity = 0.3
var fov = false
var lerp_speed= 1
var run_cost = 180
var recovery = false


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
		
func _process(delta):
	staminebar.value = stamine
	if stamine < 1000:
		stamine += 180 * delta
		print(stamine) 
	if stamine < 0:
		recovery = true
		$Camera3D/AudioStreamPlayer3D3.play()
		await get_tree(). create_timer(5).timeout
		recovery = false
	if stamine > 1000:
		#animationplayer.play("self")
		#staminebar.self_modulate = 0
		staminebar.visible = false
	else:
		#staminebar.self_modulate = 100
		staminebar.visible = true
		#animationplayer.play("unself")

func _input(event):
	if event is InputEventMouseMotion:
		$Camera3D.rotation_degrees.x -= event.relative.y * sensivity
		$Camera3D.rotation_degrees.x = clamp($Camera3D.rotation_degrees.x, -90, 90)
		rotation_degrees.y -= event.relative.x * sensivity

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if not recovery:
		if Input.is_action_pressed("RUN") and stamine > -10:
			$Camera3D.fov +=1
			$Camera3D.fov = clamp($Camera3D.fov,85,110)
			SPEED = 7.0
			if stamine > 0:
				stamine -= 5
				print(stamine)
			if $"Root Scene2/AnimationPlayer2".is_playing():
				$"Root Scene2/AnimationPlayer2".play("mixamo_com (2)")
	if  Input.is_action_just_released("RUN") or recovery:
		$Camera3D.fov = 85
		SPEED = 5.0
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("a", "d", "w", "s")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		if !$Camera3D/AudioStreamPlayer3D2.playing and is_on_floor():
			$Camera3D/AudioStreamPlayer3D2.play()
		$"Root Scene2/AnimationPlayer2".play("mixamo_com")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()





