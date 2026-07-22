extends CharacterBody2D

var main

@onready var timer = $AttackTimer

@onready var weapon = $Weapon

var face

func _ready() -> void:
	main = get_tree().current_scene
	weapon.visible = false
	timer.timeout

func _on_weapon_body_entered(body: Node2D) -> void:
	if body.has_method("die"): body.die()


func _on_timer_timeout() -> void:
	weapon.visible = true
	var closest_mob = main.MobSpawner.get_node(main.current_active_mob).position
	face = (closest_mob-position).normalized()
	if closest_mob.y-position.y < -1:
		weapon.position.x = 0.0
		weapon.position.y = -30.0
		weapon.rotation_degrees = 90.0
	else:
		weapon.position.y = 0.0
		weapon.rotation_degrees = 0.0
	if face.x == 1:
		weapon.position.x = 25.0
	else:
		weapon.position.x = -25.0

	await get_tree().create_timer(0.3).timeout
	weapon.visible = false
	timer.start()
