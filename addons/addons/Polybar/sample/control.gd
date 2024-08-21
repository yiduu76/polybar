extends Control
@onready var poly_bar: PolyBarClass = $PolyBarClass


func _on_value_up_button_up() -> void:
	poly_bar.value += 10


func _on_value_down_button_up() -> void:
	poly_bar.value -= 10


func _on_max_value_up_button_up() -> void:
	poly_bar.max_value += 10


func _on_max_value_down_button_up() -> void:
	poly_bar.max_value -= 10
