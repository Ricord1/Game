extends Node3D

var a = 10
var b = 24
var recovery = false
var rand = RandomNumberGenerator.new()
func _ready():
	pass 
func _process(delta):
	usethermometer()

func usethermometer():
	if Input.is_action_just_pressed("use") and !recovery:
		recovery = true
		$Sprite3D/SubViewport/Label.text = str(rand.randi_range(a, b)) + "°C"
		if !$AudioStreamPlayer3D.playing:
			$AudioStreamPlayer3D.play()
		await get_tree(). create_timer(5).timeout
		$Sprite3D/SubViewport/Label.text = "ОЖИД."
		recovery = false



	
	


func _on_area_3d_body_entered(body):
		a = 45
		b = 64
