extends Node2D

const BACK_SCALE = 2.0

const STARTING_NUMBERS: Array = [
1,2,3,4,5,6,7,8,9,
1,2,3,4,5,6,7,8,9,
1,2,3,4,5,6,7,8,9,
1,2,3,4,5,6,7,8,9,
1,2,3,4,5,6,7,8,9,]

@onready var background2 = $Background2
@onready var aaa = $"Background2/Overcomplicated Effect"

@onready var gridNode = $Grid

var number = preload("res://Scenes/number_1.tscn")

var grid_width: int = 9
var grid_height: int = 5
var grid: Array[Array] = []

var player_position: Vector2

var highlighted: Array = []

func _ready() -> void:
	randomize()
	
	await create_grid()
	
	player_position = Vector2(4,2)




func _process(delta: float) -> void:
	aaa.rotation_degrees += 0.02
	var size = BACK_SCALE + (sin(aaa.rotation_degrees)/1.5)
	background2.scale = Vector2(size,size)

func _physics_process(delta: float) -> void:
	var prev_pos = player_position
	var direction: Vector2= Vector2.ZERO
	if Input.is_action_just_pressed("up"):
		direction.y = -1
	elif Input.is_action_just_pressed("down"):
		direction.y = 1
	elif Input.is_action_just_pressed("left"):
		direction.x = -1
	elif Input.is_action_just_pressed("right"):
		direction.x = 1
	player_position += direction
	if player_position.x < 0: player_position.x = 0
	elif player_position.x >= grid_width: player_position.x = grid_width-1
	if player_position.y < 0: player_position.y = 0
	elif player_position.y >= grid_height: player_position.y = grid_height-1
	var same: bool = false
	if highlighted.find(player_position) != -1:
		player_position = prev_pos
		same = true
	
	if Input.is_action_pressed("select"):
		if !same: highlighted.append(player_position)
	else:
		if highlighted.size()>  0:
			if grid[highlighted[0].x][highlighted[0].y] == 1: print("wounded, do nothing")
			elif highlighted.size() > 1:
				#print(highlighted.size())
				var base_damage = grid[highlighted[0].x][highlighted[0].y]
				var highest = base_damage
				var count = 0
				for nums in highlighted:
					count += 1
					#print("highest: ", highest)
					#print("grid: ", grid[nums.x][nums.y])
					if grid[nums.x][nums.y] == highest:
						highest = grid[nums.x][nums.y] - 1
						if highest == 0:
							if count == highlighted.size():
								print("wounded, attack for: ", base_damage) #maybe double if > than 3
								break
							else:
								print("wounded, do nothing")
								break
					else:
						print("wounded, do nothing")
						break
						
		highlighted = []
	
	
	for numbers in gridNode.get_children():
		if numbers.coordinates == player_position:
			if Input.is_action_pressed("select"): numbers.scale = Vector2(1.2,1.2)
			else: numbers.scale = Vector2(1.1,1.1)
			numbers.z_index = -1
			numbers.get_node("Sprite2D").z_index = -5
			numbers.modulate = Color.WEB_MAROON
			#print(true)
		elif highlighted.find(numbers.coordinates) != -1:
			numbers.scale = Vector2(1.1,1.1)
			numbers.z_index = -2
			numbers.get_node("Sprite2D").z_index = -6
			numbers.modulate = Color.RED
		else:
			numbers.scale = Vector2(1.0,1.0)
			numbers.z_index = 0
			numbers.get_node("Sprite2D").z_index = -4
			numbers.modulate = Color.WHITE


func create_grid():
	var everything = STARTING_NUMBERS.duplicate()
	for x in grid_width:
		var column: Array = []
		for y in grid_height:
			column.append(everything.pop_at(randi() % everything.size()))
		grid.append(column)
	grid[4][2] = 1
	for x in grid_width:
		for y in grid_height:
			var new_number = number.instantiate()
			new_number.get_node("Number").text = str(grid[x][y])
			new_number.coordinates = Vector2(x,y)
			new_number.position = Vector2((x*50)-((grid_width * 50)/2)+50, (y*50)-((grid_height * 50)/2))
			gridNode.add_child(new_number)
