extends CharacterBody2D

const SPEED = 100

var main
@onready var enemy = $"../../Enemy"

var target

func _ready() -> void:
	main = get_tree().current_scene

func _physics_process(delta: float) -> void:
	if !position.distance_to(enemy.position) <= SPEED/2:
		target = (enemy.position-position).normalized()
		velocity = SPEED*target
		move_and_slide()
	
func die():
	main.number_of_mobs -= 1
	queue_free()
