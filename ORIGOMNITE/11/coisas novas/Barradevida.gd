extends ProgressBar

@export var player: Player

func _ready():
	player.healthchanged.connect(update)
	update()
	
func update():
	value = player.currenthealth * 100 / player.maxhealth
