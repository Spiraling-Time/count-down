extends Node2D

const SPAWN_DISTANCE = 590.0

@onready var MobSpawner = $MobSpawner

var number_of_mobs = 0
var Mob = preload("res://Scenes/mob.tscn")

func _ready() -> void:
	randomize()
	await spawn_mob()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("spawn"):
		await spawn_mob()

func spawn_mob():
	if number_of_mobs < 3:
		var new_mob = Mob.instantiate()
		if randi_range(0,1) == 0: new_mob.position = Vector2(-SPAWN_DISTANCE, 244.0)
		else: new_mob.position = Vector2(SPAWN_DISTANCE, 244.0)
		MobSpawner.add_child(new_mob)
		number_of_mobs += 1
