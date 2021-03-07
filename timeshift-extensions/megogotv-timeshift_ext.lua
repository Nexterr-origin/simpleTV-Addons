-- расширение дополнения httptimeshift - megogoTV (21/10/20)
-- Copyright © 2017-2020 Nexterr | https://github.com/Nexterr-origin/simpleTV-Addons 
	function httpTimeshift_megogotv(eventType, eventParams)
		if eventType == 'StartProcessing' then
			if not eventParams.params
				or not eventParams.params.address
			then
			 return
			end
			if not eventParams.params.address:match('vcdn%.biz.-/type%.live') then
			 return
			end
			if eventParams.queryType == 'Start' then
				if eventParams.params.offset > 0 then
					local offset = math.floor(eventParams.params.offset / 1000)
					local adr = eventParams.params.address:gsub('/ts/%d+/type%.live', '/type%.live')
					adr = adr:gsub('/type%.live', '/ts/' .. offset .. '/type.live')
					eventParams.params.address = adr
				end
			 return true
			end
			if eventParams.queryType == 'GetRecordAddress' then
				local offset = math.floor(eventParams.params.offset / 1000)
				local adr = eventParams.params.address:gsub('/ts/%d+/type%.live', '/type%.live')
				adr = adr:gsub('/type%.live', '/ts/' .. offset .. '/type.live')
				eventParams.params.address = adr
			 return true
			end
		 return true
		end
	end
	httpTimeshift.addEventExecutor('httpTimeshift_megogotv')
