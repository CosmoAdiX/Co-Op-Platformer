extends Node

#IMPORTS
const PLAYER = preload('uid://djomyauthjdyl')

var enet_peer :=ENetMultiplayerPeer.new()

var PORT = 9999
var IP_ADDRESS = '127.0.0.1'


# Basic snippet for basic setup of a server-client commuinication on a local network.
func start_server():
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	
func join_server():
	enet_peer.create_client(IP_ADDRESS, PORT)
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	multiplayer.connected_to_server.connect(on_connected_to_server)
	multiplayer.multiplayer_peer = enet_peer
	
func on_connected_to_server():
	add_player(multiplayer.get_unique_id())


func add_player(peer_id: int):
	if peer_id == 1:
		return
	
	var new_player = PLAYER.instantiate()
	new_player.name = str(peer_id)
	get_tree().current_scene.add_child(new_player, true)
	
func remove_player(peer_id: int):
	if peer_id == 1:
		leave_server()
	
	var players: Array[Node] = get_tree().get_nodes_in_group('Players')
	var players_to_remove = players.find_custom(func(item): return item.name == str(peer_id))
	if players_to_remove != -1:
		players[players_to_remove].queue_free()
	
func leave_server():
	multiplayer.multiplayer_peer.close()
	multiplayer.multiplayer_peer = null
	clean_up_signals()
	get_tree().reload_current_scene()
	
	
func clean_up_signals():
	print("===== CLEANED/DISCONNECTED ALL SIGNALS!!! =====")
	multiplayer.peer_connected.disconnect(add_player)
	multiplayer.peer_disconnected.disconnect(remove_player)
	multiplayer.connected_to_server.disconnect(on_connected_to_server)
