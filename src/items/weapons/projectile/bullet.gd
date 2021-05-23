extends Area2D

export (int) var speed = 50 setget set_speed, get_speed
export (int) var attack_power = 1 setget set_attack_power, get_attack_power
var directionx = 1 setget set_directionx, get_directionx
var directiony = 0 setget set_directiony, get_directiony
export (bool) var pass_through : = true

#func _ready():
#	$AudioStreamPlayer2D.play()

func _process(delta):
	var velocity = Vector2()
	velocity.x += directionx
	velocity.y += directiony
	velocity = velocity * speed
	
	position += velocity * delta

# setters and getters

func set_speed(new_value):
	speed = new_value

func get_speed():
	return speed

func set_attack_power(new_value):
	attack_power = new_value

func get_attack_power():
	return attack_power

func set_directionx(new_value):
	directionx = new_value

func get_directionx():
	return directionx

func set_directiony(new_value):
	directiony = new_value

func get_directiony():
	return directiony


func _on_Area2D_body_entered(body):
	if pass_through:
		if body is StaticBody2D:
			queue_free()
