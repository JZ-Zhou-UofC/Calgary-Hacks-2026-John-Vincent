extends CharacterBody2D

@export var speed := 300.0

@onready var body = $Body


func _physics_process(delta):

	var direction = Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)

	# movement
	velocity = direction * speed
	move_and_slide()

	# flip body left/right only
	update_facing(direction)


func update_facing(direction):

	if direction.x > 0:
		body.flip_h = false

	elif direction.x < 0:
		body.flip_h = true
