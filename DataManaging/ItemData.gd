extends Node

var missile_launcher = preload("res://Entities/Weapons/missile_launcher.tscn")
var rocket_launcher = preload("res://Entities/Weapons/rocket_launcher.tscn")
var vacuum_gun = preload("res://Entities/Weapons/vacuum_gun.tscn")
var blaster = preload("res://Entities/Weapons/blaster.tscn")
var rifle = preload("res://Entities/Weapons/rifle.tscn")


var weapons = {
	"missile_launcher" : missile_launcher,
	"rocket_launcher" : rocket_launcher,
	"vacuum_gun" : vacuum_gun,
	"blaster" : blaster,
	"rifle" : rifle
}



var repair_station = preload("res://Entities/Buildings/repair_station.tscn")
var geo_repair_station = preload("res://Entities/Buildings/geo_repair_station.tscn")
var technology_institute = preload("res://Entities/Buildings/technology_institute.tscn")
var bank = preload("res://Entities/Buildings/bank.tscn")
var shield_generator = preload("res://Entities/Buildings/shield_generator.tscn")

var facilities = {
	"repair_station" : repair_station,
	"geo_repair_station" : geo_repair_station,
	"technology_institute" : technology_institute,
	"bank" : bank,
	"shield_generator" : shield_generator
}


var combat_ship = preload("res://Entities/Player/combat_ship.tscn")
var speeder = preload("res://Entities/Player/speeder.tscn")


var ships = {
	"combat_ship" : combat_ship,
	"speeder" : speeder
}



var item_prices = {
	"speeder" : 500,
	"combat_ship" : 500,
	"repair_station" : 1500,
	"geo_repair_station" : 5000,
	"shield_generator" : 1500,
	"technology_institute" : 1000,
	"bank" : 1000,
	"none" : 0,
}



var item_info = {
	"speeder" : "A lightweight, inexpensive ship built for speed and agility. It’s not designed for combat, but in desperate situations, it can be converted for defense or light skirmishes. Quick to build, quick to fly — the Speeder is perfect for anyone who values mobility over firepower.",
	"combat_ship" : "Once the pride of the fleet, this warship was never meant to return to service. Years of defense cuts left it outdated and worn, but with no new ships available, it’s been pressed back into duty—and it can still get the job done.",
	"repair_station" : "Repair station is an earth installation that uses ion ray technology to carry required supplies and energy to maintain any ship in the earths lower orbit. No landings needed!",
	"geo_repair_station" : "Geo repair station doesn't have anything to do with ships or the ongoing war with Martians. It is a vast set of infrastructure needed to patch up possible damage caused to a planet. It is expensive but it is much needed to protect the most valuable asset: Earth.",
	"shield_generator" : "Shield generator is an advanced technology used to protect earth. It provides regenerated protection",
	"technology_institute" : "Technology is essential when trying to defend against extraterrestial threats. The right advancements in weapon technology might be the key to change the tide of a battle or even a war. Technology institute grants you xp multipliers.",
	"bank" : "Investments might seem irrelevant during war but right economical decisions will help you outlast the enemy. Banks provide you with a steady flow of money.",
	"none" : "",
}
