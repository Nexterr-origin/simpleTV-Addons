-- расширение дополнения httptimeshift - antifriztv (14/12/22)
-- Copyright © 2017-2022 Nexterr | https://github.com/Nexterr-origin/simpleTV-Addons
	function httpTimeshift_antifriztv(eventType, eventParams)
		if eventType == 'StartProcessing' then
			if not eventParams.params
				or not eventParams.params.address
			then
			 return
			end
			if not eventParams.params.address:match('%.af%-stream%.')
			then
			 return
			end
			if eventParams.queryType == 'GetLengthByAddress'
				or eventParams.queryType == 'TestAddress'
				or eventParams.queryType == 'IsRecordAble'
				or eventParams.queryType == 'Start'
			then
				eventParams.params.rawM3UString = eventParams.params.rawM3UString:gsub('catchup%-source="[^"]+', '')
				.. 'catchup="shift"'
			 return true
			end
			if eventParams.queryType == 'GetRecordAddress'
			then
				eventParams.params.rawM3UString = eventParams.params.rawM3UString:gsub('catchup%-source', 'catchup-record-source') .. ' catchup="default"'
			 return true
			end
		 return true
		end
	end
	httpTimeshift.addEventExecutor('httpTimeshift_antifriztv')