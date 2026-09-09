extends CanvasLayer


const ORDER_PANEL_SCENE = preload("res://Scenes/UI/OrderPanel.tscn")


@onready var orders_container: VBoxContainer = $Orders


func _ready() -> void:
	OrderManager.order_created.connect(_on_order_created)
	OrderManager.order_completed.connect(_on_order_completed)
	
	for order in OrderManager.get_pending_orders():
		add_order_panel(order)


func _on_order_created(order: CustomerOrder) -> void:
	add_order_panel(order)


func add_order_panel(order: CustomerOrder) -> void:
	var panel := ORDER_PANEL_SCENE.instantiate()
	
	orders_container.add_child(panel)
	
	panel.setup_order(order)


func _on_order_completed(order: CustomerOrder) -> void:
	for panel in orders_container.get_children():
		if panel.order == order:
			panel.queue_free()
			break
