extends CharacterBody2D

@onready var bullet_spawn = $BulletSpawn
@export var max_health = 3
var health = max_health
@export var bullet_scene: PackedScene
@export var move_speed = 10.0
var shoot_timer = 0.0
@export var shoot_cooldown = 0.2
var typingUI : Node  # or remove type completely

func _ready():
	var ui_node = get_tree().get_root().get_node("root/TypingUI")
	if ui_node:
		typingUI = ui_node as CanvasLayer
		print("✅ TypingUI dynamically found:", typingUI)
	else:
		print("❌ Could not find TypingUI")


func _process(delta):
	if Input.is_action_pressed("aim_mode"):
		var dir = get_global_mouse_position() - global_position
		if dir.y > 0:
			rotation = dir.angle() + deg_to_rad(-90)
	else:
		rotation = 0.0
		var target = get_global_mouse_position()
		global_position = global_position.lerp(target, move_speed * delta)
		var screen_width = get_viewport().get_visible_rect().size.x
		global_position.x = clamp(global_position.x, screen_width * (2.0 / 3.0), screen_width)

	# Shoot bullets
	shoot_timer -= delta
	if typingUI and Input.is_action_pressed("shoot") and shoot_timer <= 0 and typingUI.typed_letters > 0:
		var bullet = bullet_scene.instantiate()
		bullet.global_position = bullet_spawn.global_position
		bullet.rotation = rotation
		get_tree().current_scene.add_child(bullet)
		typingUI.update_ammo_counter(typingUI.typed_letters)  # or `ammo` if you're tracking it there

		shoot_timer = shoot_cooldown
		typingUI.use_ammo_letter()
		print("🔫 Shot! Typed letters left:", typingUI.typed_letters)
