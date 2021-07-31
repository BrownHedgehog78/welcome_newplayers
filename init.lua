local welcome_msg = minetest.settings:get("welcome_newplayers.msg") or "Welcome to the server!"

minetest.register_chatcommand("welcome_msg", {
	description = "Edit welcome message",
	privs = {server = true},
	func = function(name)
		local formspec = {
			"formspec_version[4]" ..
			"size[9,5]" ..
			"label[2.1,0.6;Welcome Messages Editor]" ..
			"label[2.4,1.7;Edit Welcome Message]" ..
			"field[0.2,2;8.5,0.8;welcome_msg_field;;]" ..
			"button[4.7,3.7;3,0.9;save_button;Save]" ..
			"button_exit[0.7,3.7;3,0.9;cancel_button_exit;Cancel]"
		}
		minetest.show_formspec(name, "welcome_newplayers:editor", table.concat(formspec, ""))
	end
})

minetest.register_on_newplayer(function(player)
	local name = player:get_player_name()
	minetest.after(2.5, function()
		minetest.chat_send_player(name, minetest.colorize("#4bd12a", welcome_msg))
	end)
end)

minetest.register_on_player_receive_fields(function(player, formname, fields)
	local name = player:get_player_name()
	if formname == "welcome_newplayers:editor" then
		if not fields.save_button then
			return
		end

		if fields.welcome_msg_field == ""  then
			minetest.chat_send_player(name, "Nothing to edit, the field is empty")
		else
			minetest.settings:set("welcome_newplayers.msg", fields.welcome_msg_field)
			minetest.chat_send_player(name, "Edited welcome message! (The server will need restart)")
		end
	end
end)
