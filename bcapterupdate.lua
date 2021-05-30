require 'lib.moonloader'

local dlstatus = require ('moonloader').download_status
local sv = 2
local sv_t = '1.50'
local script_path = thisScript().path
local script_url = 'https://raw.githubusercontent.com/Ste1eeeven/bcapterupdates/main/bcapterupdate.lua'
local inicfg = require 'inicfg'
local update_path = getWorkingDirectory()..'/update.ini'
local update_url = 'https://raw.githubusercontent.com/Ste1eeeven/bcapterupdates/main/update.ini'
 
update_state = false

function main()
	repeat wait(0) until isSampAvailable()
	while not isSampAvailable() do wait(0) end
	_, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
	nick_name = sampGetPlayerNickname(id)

	sampRegisterChatCommand('update', cmd_update)
	sampAddChatMessage('loaded', -1)
	
	downloadUrlToFile(update_url, update_path,function(id, status)
		if status == dlstatus.STATUS_ENDDOWNLOADDATA then
			updateini =  inicfg.load(nil, update_path)
			if tonumber(updateini.info.vers) > sv then
				sampAddChatMessage('Update is: true. Version: '.. updateini.info.vers_text, -1)
				update_state = true
			end
		end
	end)
	while true do
		wait(0)
		
		if update_state then
			downloadUrlToFile(script_url, script_path,function(id, status)
				if status == dlstatus.STATUS_ENDDOWNLOADDATA then
					sampAddChatMessage("Update loaded: true", -1)
					thisScript():reload()
				end
			end)
			break
		end
	
	end
end

function cmd_update(arg)
	sampShowDialog(2228, 'Autoupdate v1.5', 'text', 'close', '', 0)
end