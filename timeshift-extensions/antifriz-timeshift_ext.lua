-- расширение дополнения httptimeshift - antifriz (28/1/21)
-- Copyright © 2017-2021 Nexterr | https://github.com/Nexterr-origin/simpleTV-Addons 
	function httpTimeshift_antifriz(eventType, eventParams)
		if eventType == 'StartProcessing' then
			if not eventParams.params
				or not eventParams.params.address
			then
			 return
			end
			if not (eventParams.params.address:match('antifriz%.tv')
				and (eventParams.params.rawM3UString:match('tvg%-rec=')
					or eventParams.params.rawM3UString:match('catchup%-days=')))
			then
			 return
			end
			if     eventParams.queryType == 'GetLengthByAddress'
				or eventParams.queryType == 'TestAddress'
				or eventParams.queryType == 'IsRecordAble'
				or eventParams.queryType == 'Start'
			then
				eventParams.params.rawM3UString = 'catchup="shift" ' .. eventParams.params.rawM3UString
				eventParams.params.rawM3UString = eventParams.params.rawM3UString:gsub('catchup%-source=".-"', '')
			 return true
			end
			if eventParams.queryType == 'GetRecordAddress' then
				eventParams.params.rawM3UString = 'catchup="default" ' .. eventParams.params.rawM3UString:gsub('catchup%-source=', 'catchup-record-source=')
				eventParams.params.rawM3UString = eventParams.params.rawM3UString:gsub('{duration}', '{length}')
			 return true
			end
		 return true
		end
	end
	httpTimeshift.addEventExecutor('httpTimeshift_antifriz')