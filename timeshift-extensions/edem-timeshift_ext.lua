-- расширение дополнения httptimeshift - edem (29/11/21)
-- Copyright © 2017-2021 Nexterr | https://github.com/Nexterr-origin/simpleTV-Addons
	function httpTimeshift_edem(eventType, eventParams)
		if eventType == 'StartProcessing' then
			if not eventParams.params
				or not eventParams.params.address
			then
			 return
			end
			if not (eventParams.params.address:match('//[^.]+%.[^.]+%.[^/]+/iptv/[%u%d]+/%d+/index%.m3u8')
				and (eventParams.params.rawM3UString:match('tvg%-rec=')
					or eventParams.params.rawM3UString:match('catchup%-days=')))
			then
			 return
			end
			if eventParams.queryType == 'GetLengthByAddress'
				or eventParams.queryType == 'TestAddress'
				or eventParams.queryType == 'IsRecordAble'
				or eventParams.queryType == 'Start'
				or eventParams.queryType == 'GetRecordAddress'
			then
				eventParams.params.rawM3UString = eventParams.params.rawM3UString .. ' catchup="append" catchup-source="?utc=${start}&lutc=${timestamp}"'
			 return true
			end
		 return true
		end
	end
	httpTimeshift.addEventExecutor('httpTimeshift_edem')