@tool
extends EditorPlugin

func _enter_tree() -> void:
	if Engine.is_editor_hint():
		print_rich("[color=green][b]Enabled PolyBar[/b][/color]")

func _exit_tree() -> void:
	if Engine.is_editor_hint():
		print_rich("[color=red][b]Disabled PolyBar[/b][/color]")
