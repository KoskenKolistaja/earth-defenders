extends Control















func pause_space():
	$Space.process_mode = Node.PROCESS_MODE_DISABLED

func unpause_space():
	$Space.process_mode = Node.PROCESS_MODE_INHERIT
