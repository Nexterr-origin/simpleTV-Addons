-- расширение дополнения httptimeshift - itvuz (10/8/25)
-- Copyright © 2017-2025 Nexterr, NEKTO666 | https://github.com/Nexterr-origin/simpleTV-Addons
	function httpTimeshift_itvuz(eventType, eventParams)
		if eventType == 'StartProcessing' then
			if not eventParams.params
				or not eventParams.params.address
			then
			 return
			end
			if not (eventParams.params.address:match('itv%.uz')
				and m_simpleTV.User
				and m_simpleTV.User.itvuz
				and m_simpleTV.User.itvuz.url_archive)
			then
			 return
			end
			
			if eventParams.queryType == 'Start' or eventParams.queryType == 'GetRecordAddress' then
				if eventParams.params.offset > 0 then
					local offset = math.floor(os.time() - (eventParams.params.offset / 1000))
					local url = m_simpleTV.User.itvuz.url_archive
					url = url:gsub('{START_AT}', offset):gsub('{SECONDS}', 0)
					eventParams.params.address = url
				end
			 return true
			end
		 return true
		end
	end
	httpTimeshift.addEventExecutor('httpTimeshift_itvuz')
