extends CharacterBody2D

@export var tileMap : TileMapLayer

const SPEED = 300.0
const JUMP_VELOCITY = -550.0
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var push_body: Area2D = $push_body
const PUSH_FORCE = 1200.0

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
	# Push any Rigid body
	for body in push_body.get_overlapping_bodies():
		if body is RigidBody2D:
			var dir = (body.global_position - global_position).normalized()
			body.apply_force(dir * PUSH_FORCE)
	move_and_slide()
	check_tile_damage()
	
	
func change_animation(animation):
	if animated_sprite_2d.animation != animation:
		animated_sprite_2d.play(animation)

func check_tile_damage():
	var local_pos := tileMap.to_local(global_position + Vector2(0, 5))
	var cell := tileMap.local_to_map(local_pos)
	var tile_data := tileMap.get_cell_tile_data(cell)

	if tile_data and tile_data.get_custom_data("damage") == 1:
		take_damage(1, tileMap.to_global(local_pos))

func take_damage(_damage, object_position):
	print("taking damage")
	if isHurt:
		return false
	
	animated_sprite_2d.play("knockback")
	isHurt = true
	# Apply the force
	if global_position.x > object_position.x:
		velocity = Vector2(500, JUMP_VELOCITY * 1.2)
	else:
		velocity = Vector2(-500, JUMP_VELOCITY * 1.2)


func _on_animated_sprite_2d_animation_finished() -> void:
	isHurt = false
