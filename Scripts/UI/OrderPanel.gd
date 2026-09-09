extends Control


var order: CustomerOrder


@onready var title: Label = $PanelContainer/VBoxContainer/Title
@onready var items: VBoxContainer = $PanelContainer/VBoxContainer/Items


func setup_order(new_order: CustomerOrder) -> void:
	order = new_order
	
	update_display()


func update_display() -> void:
	if order == null:
		return
	
	title.text = "Order"
	
	for child in items.get_children():
		child.queue_free()
	
	for item in order.items:
		var label := Label.new()
		
		label.text = "%s    $%.2f" % [
			item.item_name,
			item.price
		]
		
		items.add_child(label)
	
	var total_label := Label.new()
	total_label.text = "Total: $%.2f" % order.total
	
	items.add_child(total_label)
