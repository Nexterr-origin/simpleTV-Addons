-- расширение дополнения httptimeshift - yandex (7/9/23)
-- Copyright © 2017-2023 Nexterr | https://github.com/Nexterr-origin/simpleTV-Addons
	function httpTimeshift_yandex(eventType, eventParams)
		if eventType == 'StartProcessing' then
			if not eventParams.params
				or not eventParams.params.address
			then
			 return
			end
			if not eventParams.params.address:match('strm%.yandex%.ru/.-PARAMS=yandex_tv') then return end
			if eventParams.queryType == 'Start' or eventParams.queryType == 'GetRecordAddress' then
				if eventParams.params.offset > 0 then
					local endY = os.time() - 200
					local startY = os.time() - (eventParams.params.offset / 1000)
					startY = math.floor(startY)
					if (endY - startY) > (6 * 3600) then
						endY = startY + (6 * 3600)
					end
					if (startY - endY) >= 0 then
						startY = startY - 200
					end
					eventParams.params.rawM3UString = eventParams.params.rawM3UString:gsub('catchup%-source="%?start=${start}"'
					, 'catchup-source="?start=' .. startY .. '&end=' .. endY ..'"')
				end
			 return true
			end
		 return true
		end
	end
	httpTimeshift.addEventExecutor('httpTimeshift_yandex')
