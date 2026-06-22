extends Node

var game_slot := 0

# Player variables
var player_name := ""
var money := 0
var popularity := 0

# Shop variables
var shop_name := ""
var menu_ids: Array = []
var menu: Array[ArticleData]
# World variables
var month := 0
var day_index := 0
var num_day := 0
var year := 0

func load_to_data(data: Dictionary):
	player_name = data["player"]["name"]
	money = data["player"]["money"]
	popularity = data["player"]["popularity"]

	shop_name = data["coffee_shop"]["name"]
	menu_ids = data["coffee_shop"]["menu_ids"]

	day_index = data["world"]["day_index"]
	num_day = data["world"]["num_day"]
	month = data["world"]["month"]
	year = data["world"]["year"]
