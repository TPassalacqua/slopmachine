extends Node2D

const SYMBOLS = [
	preload("res://assets/mango.jpg"),
	preload("res://assets/cherries.jpg"),
	preload("res://assets/watermelon.png")
]

var reels = []
var spinning = false

func _ready():
	reels = [
		$Reels/Reel1,
		$Reels/Reel2,
		$Reels/Reel3
	]
	$SpinButton.pressed.connect(_on_spin_pressed)
	_set_initial_symbols()
	
func _set_initial_symbols():
	for reel in reels:
		var random_texture = SYMBOLS[randi() % SYMBOLS.size()]
		reel.texture = random_texture

func _on_spin_pressed():
	print("Spin button pressed")
	if spinning:
		return
	spinning = true
	$ResultLabel.text = "Spinning..."
	await _spin_reels()
	_check_results()
	spinning = false

func _spin_reels():
	for i in range(3):
		await _spin_single_reel(reels[i], 0.5 + i * 0.2)

func _spin_single_reel(reel: Sprite2D, duration: float) -> void:
	var elapsed = 0.0
	var speed = 0.05
	
	while elapsed < duration:
		reel.texture = SYMBOLS[randi() % SYMBOLS.size()]
		await get_tree().create_timer(0.1).timeout
		elapsed += speed
		speed += 0.01

func _check_results():
	var textures = reels.map(func(r): return r.texture)
	var all_match = textures[0] == textures[1] and textures[1] == textures[2]

	if all_match:
		$ResultLabel.text = "Jackpot!"
	elif textures[0] == textures[1] or textures[1] == textures[2] or textures[0] == textures[2]:
		$ResultLabel.text = "Two of a kind!"
	else:
		$ResultLabel.text = "Try again!"
