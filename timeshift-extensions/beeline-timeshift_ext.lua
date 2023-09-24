-- расширение дополнения httptimeshift - beeline (18/11/22)
-- Copyright © 2017-2022 Nexterr | https://github.com/Nexterr-origin/simpleTV-Addons
	function httpTimeshift_beeline(eventType, eventParams)
		if eventType == 'StartProcessing' then
			if not eventParams.params
				or not eventParams.params.address
			then
			 return
			end
			if not eventParams.params.address:match('video%.beeline%.tv') -- beeline
			then
			 return
			end
			if eventParams.queryType == 'Start' or eventParams.queryType == 'GetRecordAddress' then
				if eventParams.params.offset > 0 then
					local starttime = os.time() - (eventParams.params.offset / 1000)
					local stoptime = starttime + 3600 * 5 - 60
					if stoptime > os.time() then
						stoptime = os.time() - 60
					end
					local ts = '?starttime=' .. math.floor(starttime) .. '&stoptime=' .. math.floor(stoptime)
					eventParams.params.address = eventParams.params.address:gsub('%.mpd', '.mpd' .. ts)
				end
			 return true
			end
		 return true
		end
	end
	httpTimeshift.addEventExecutor('httpTimeshift_beeline')