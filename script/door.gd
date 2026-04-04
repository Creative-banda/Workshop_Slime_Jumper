extends Area2D

@export var isLocked : bool = false
@export var required_batteries : int = 3

@onready var door_open: Sprite2D = $DoorOpen
@onready var doorlocked: Sprite2D = $Doorlocked
@onready var label: Label = $Label


func _ready() -> void:
	update_visual()

func update_visual():
	door_open.visible = not isLocked
	doorlocked.visible = isLocked

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		if body.batteries >= required_batteries:
			print("Level Complete")
