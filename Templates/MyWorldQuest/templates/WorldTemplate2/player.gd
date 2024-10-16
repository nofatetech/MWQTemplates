extends CharacterBody2D

class_name Player

@export var is_current_player := false

@export var username: String = ""
#@export var id: int = 100
#@export var title: String = ""
@export var speed: float = 900
@export var accel: float = 10

signal hit
signal leave

func _ready():
	#$PanelSuperSign.modulate = Color("#ffffff", 0)
	pass

#func _physics_process(delta):
	#if is_current_player:
		#var direction: Vector2 = Input.get_vector("left", "right", "up", "down")
#
		#velocity.x = move_toward(velocity.x, speed * direction.x, accel)
		#velocity.y = move_toward(velocity.y, speed * direction.y, accel)
		#
		#move_and_slide()
	#pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if true: #is_current_player:
	if is_current_player:
		var motion = Vector2()
		velocity = Vector2.ZERO
		
		#moves faster when zoomed out
		var tcam: Camera2D = find_child("Camera2D")
		if tcam:
			speed = 900 * ( 1 / (tcam.zoom.x * 3) )
			pass
		
		if Input.is_action_pressed("up"):
			motion.y -= 1
			velocity.y -= speed
		if Input.is_action_pressed("down"):
			velocity.y += speed
			motion.y += 1
		if Input.is_action_pressed("left"):
			velocity.x -= speed
			motion.x -= 1
		if Input.is_action_pressed("right"):
			velocity.x += speed
			motion.x += 1
		
		#velocity = move_and_slide(velocity)
		var collision = move_and_collide(velocity * delta)
		if collision:
			print("I collided with ", collision.get_collider().name)
		
		#var direction: Vector2 = Input.get_vector("left", "right", "up", "down")
		#motion = Input.get_vector("left", "right", "up", "down")
		#velocity.x = move_toward(velocity.x, speed * direction.x, accel)
		#velocity.y = move_toward(velocity.y, speed * direction.y, accel)
		#move_and_slide()
		#position += velocity * delta
		
	pass


func set_data(rdata: Dictionary) -> void:
	$LabelPlayerUsername.text = rdata.get("username", "??")
	pass



#func _on_area_2d_body_entered(body):
	#hit.emit(body)
	#pass # Replace with function body.


func _on_area_2d_area_entered(area):
	hit.emit(area)
	pass # Replace with function body.


func _on_area_2d_area_exited(area):
	leave.emit(area)
	pass # Replace with function body.




#extends CharacterBody2D
#
#
#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0
#
#
#func _physics_process(delta: float) -> void:
	## Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
#
	#move_and_slide()
