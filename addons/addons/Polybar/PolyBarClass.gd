@tool
extends Node2D
class_name PolyBarClass
@export var BarName:String = "HP":
	set(v):
		BarName = v
		value_change()
@export_enum("BOTH", "RIGHT", "LEFT") var bar_grove_dir = "BOTH":
	set(v):
		bar_grove_dir = v
		reset()
		value_change()
@export_enum("Box", "Diamond") var bar_type = "Box":
	set(v):
		bar_type = v
		if bar_type == "Box":
			init_poly = box_poly
		elif bar_type == "Diamond":
			init_poly = diamod_poly

@onready var bar_top: Polygon2D
@onready var line_top: Line2D
@onready var bar_under: Polygon2D
@onready var line_under: Line2D
@onready var text_label: Label

@onready var bars_and_lines:Array[Node]
@export var init_poly:Array[Vector2] = \
	[Vector2(-4,-4),Vector2(-4,4),Vector2(4,4),
	Vector2(4,-4),Vector2(-4,-4)]:
		set(v):
			init_poly = v
			for i in bars_and_lines:
				i.set("polygon",init_poly)
				i.set("points",init_poly)
			value_change()

@onready var diamod_poly:Array[Vector2] = \
	[Vector2(-0.01, -4), Vector2(-4, 0), Vector2(-0.01, 4), Vector2(0.01, 4), 
	Vector2(4, 0), Vector2(0.01, -4), Vector2(-0.01, -4)]
@onready var box_poly:Array[Vector2] = \
	[Vector2(-4,-4),Vector2(-4,4),Vector2(4,4),Vector2(4,-4),Vector2(-4,-4)]

@export_range(1.0, 100.0, 0.5,"or_greater") var value:float = 50.0:
	set(v):
		value = v
		value_change()
@export_range(1.0, 100.0, 0.5,"or_greater") var max_value:float = 100.0:
	set(v):
		max_value = v
		value_change()

@export_range(10.0, 300.0, 0.5,"or_greater") var bar_len:float = 100.0:
	set(v):
		bar_len = v
		value_change()

@export var colors:Array[Color] = [Color.html("ff4d4d"),Color.html("592d2d"),Color.html("80262632"),Color.html("592d2d32")]:
	set(v):
		if is_node_ready():
			colors = v
			bars_and_lines = [bar_top,line_top,bar_under,line_under]
			for i in bars_and_lines.size():
				bars_and_lines[i].set("color",colors[i])
				bars_and_lines[i].set("default_color",colors[i])
@export var Custom_Line:PackedScene = preload("res://addons/Polybar/custom_scn/line.tscn")
@export var Custom_Label:PackedScene = preload("res://addons/Polybar/custom_scn/label.tscn")


func _ready() -> void:
	bars_and_lines = [bar_top,line_top,bar_under,line_under]
	create_poly_and_line()
	value = value
	max_value = max_value
	

func create_poly_and_line():
	#if Engine.is_editor_hint():
	clear_old()
	create_new()
	colors = colors

func clear_old():
	for i in get_children():
		i.queue_free()
		remove_child(i)
		bars_and_lines = []

func create_new():
	bar_top = Polygon2D.new()
	line_top = Custom_Line.instantiate()
	bar_under = Polygon2D.new()
	line_under = Custom_Line.instantiate()
	text_label = Custom_Label.instantiate()
	bars_and_lines = [bar_top,line_top,bar_under,line_under]
	add_child(bar_under)
	add_child(line_under)
	add_child(bar_top)
	add_child(line_top)
	for i in bars_and_lines:
		i.set("polygon",init_poly)
		i.set("points",init_poly)
		i.set_owner(get_tree().get_edited_scene_root())
	add_child(text_label)
	text_label.set_owner(get_tree().get_edited_scene_root())
	text_label.position = Vector2(-text_label.size.x,-text_label.size.y/2)

func value_change():
	if is_node_ready():
		set_points(value,0)
		set_points(value,1)
		set_points(max_value,2)
		set_points(max_value,3)
		display_tip()

func reset():
	for i in bars_and_lines:
		i.set("polygon",init_poly)
		i.set("points",init_poly)

func set_points(p_value:float,index:int):
	var p_node = bars_and_lines[index]
	var p_array = p_node.get("polygon")
	if p_array == null:
		p_array = p_node.get("points")
	var p_len = (p_value / max_value) * bar_len
	for i in p_array.size():
		if p_array[i].x < 0 and bar_grove_dir != "RIGHT":
			if Engine.is_editor_hint():
				p_array[i].x = init_poly[i].x - p_len
			else :
				p_array[i].x = lerp(p_array[i].x, init_poly[i].x - p_len,0.1)
		elif p_array[i].x > 0 and bar_grove_dir != "LEFT":
			if Engine.is_editor_hint():
				p_array[i].x = init_poly[i].x + p_len
			else :
				p_array[i].x = lerp(p_array[i].x, init_poly[i].x + p_len,0.1)
	p_node.set("polygon",p_array)
	p_node.set("points",p_array)

func display_tip():
	var p_str:String = "%s %s / %s " % [BarName,int(value),int(max_value)]
	text_label.text = p_str
	if bar_grove_dir == "LEFT":
		text_label.position = Vector2(-text_label.size.x,-text_label.size.y/2)
	elif bar_grove_dir == "RIGHT":
		text_label.position = Vector2(0,-text_label.size.y/2)
	else :
		text_label.position = Vector2(-text_label.size.x/2,-text_label.size.y/2)
