-- расширение дополнения httptimeshift "starnetmd" https://www.starnet.md (12/4/21)
-- Copyright © 2017-2021 Nexterr | https://github.com/Nexterr-origin/simpleTV-Addons
	function httpTimeshift_starnetmd(eventType, eventParams)
		if eventType == 'StartProcessing' then
			if not eventParams.params
				or not eventParams.params.address
			then
			 return
			end
			if not eventParams.params.address:match('stb%.md') then return end
			if eventParams.queryType == 'Start' or eventParams.queryType == 'GetRecordAddress' then
				if eventParams.params.offset > 0 then
					local offset = math.floor(eventParams.params.offset / 1000)
					eventParams.params.address = eventParams.params.address:gsub('/%a+%.m3u8', '/timeshift_rel-' .. offset .. '.m3u8')
				end
			 return true
			end
		 return true
		end
	end
	httpTimeshift.addEventExecutor('httpTimeshift_starnetmd')