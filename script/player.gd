extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -500.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var isHurt: bool = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		if not isHurt:
			change_animation("jump")

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if is_on_floor() and (not isHurt):
		if velocity.x != 0:
			change_animation("walk")
		else:
			change_animation("idle")
	
	if not isHurt:
		var direction := Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * SPEED
			animated_sprite_2d.flip_h = direction < 0
		else:
			velocity.x = move_toward(velocity.x, 0, 10)
	else:
		velocity.x = move_toward(velocity.x, 0, 10)
		
	move_and_slide()

func change_animation(animation):
	if animated_sprite_2d.animation != animation:
		animated_sprite_2d.play(animation)
