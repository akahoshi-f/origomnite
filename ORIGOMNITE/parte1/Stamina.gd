extends ProgressBar

var fill_stylebox:StyleBoxFlat

const manabarfulana = preload("res://staminabarfulana.tres")

func _ready():
	fill_stylebox = get_theme_stylebox("fill")
	
func _on_value_changed(new_value):
	fill_stylebox.bg_color = manabarfulana.gradient.sample(1- (new_value / max_value))
	
	
