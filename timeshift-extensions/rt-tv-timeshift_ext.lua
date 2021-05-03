-- расширение дополнения httptimeshift: "RT" (3/05/21)
-- Copyright © 2017-2020 Nexterr | https://github.com/Nexterr-origin/simpleTV-Addons https://github.com/Nexterr
-- ##
	function httpTimeshift_rt(eventType, eventParams)
		if eventType == 'StartProcessing' then
			if not eventParams.params
				or not eventParams.params.address
			then
			 return
			end
			if not (eventParams.params.address:match('rt%.ru/hls/CH_')
				or eventParams.params.address:match('ngenix%.net[:%d]*/hls/CH_')
				or eventParams.params.address:match('ngenix%.net/mdrm/CH_'))
			then
			 return
			end
			if eventParams.queryType == 'GetLengthByAddress'
				or eventParams.queryType == 'TestAddress'
				or eventParams.queryType == 'IsRecordAble'
			then
				eventParams.params.rawM3UString = 'catchup="append" catchup-days="3"'
			 return true
			end
			if eventParams.queryType == 'Start' then
				eventParams.params.address = eventParams.params.address:gsub('%?.-$', '')
				eventParams.params.rawM3UString = 'catchup="append" catchup-days="3" catchup-source="?offset=-${offset}"'
			 return true
			end
			if eventParams.queryType == 'GetRecordAddress' then
				eventParams.params.address = eventParams.params.address:gsub('%?.-$', '')
				eventParams.params.rawM3UString = 'catchup="append" catchup-days="3" catchup-record-source="?utcstart=${start}&utcend=${end}"'
			 return true
			end
		 return true
		end
	end
	httpTimeshift.addEventExecutor('httpTimeshift_rt')