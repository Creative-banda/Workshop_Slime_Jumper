extends Node2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D


func trigger_explosion():
	sprite_2d.visible = false
	animated_sprite_2d.visible = true
	animated_sprite_2d.play("default")
	animation_player.play("explosion_expand")


func _on_body_overlap_body_entered(body: Node2D) -> void:
	if body.name == "player":
		animation_player.play("barrel_blink")


func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()


func _on_explosion_area_body_entered(body: Node2D) -> void:
	if body.name == "player":
		body.take_damage(1, global_position)
