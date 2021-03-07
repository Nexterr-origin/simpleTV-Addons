-- расширение дополнения httptimeshift limeHD (21/10/20)
-- Copyright © 2017-2020 Nexterr | https://github.com/Nexterr-origin/simpleTV-Addons 
	function httpTimeshift_limehd(eventType, eventParams)
		if eventType == 'StartProcessing' then
			if not eventParams.params
				or not eventParams.params.address
			then
			 return
			end
			if not ((eventParams.params.address:match('limehd%.')
				or eventParams.params.address:match('iptv2022'))
				and m_simpleTV.User
				and m_simpleTV.User.infolink)
			then
			 return
			end
			if eventParams.queryType == 'GetLengthByAddress'
				or eventParams.queryType == 'TestAddress'
				or eventParams.queryType == 'IsRecordAble'
			then
				eventParams.params.rawM3UString = m_simpleTV.User.infolink.catchup
			 return true
			end
			if eventParams.queryType == 'Start' then
				eventParams.params.rawM3UString = m_simpleTV.User.infolink.catchup
				if eventParams.params.offset > 0 then
					eventParams.params.address = m_simpleTV.User.infolink.url_archive
				end
			 return true
			end
			if eventParams.queryType == 'GetRecordAddress' then
				eventParams.params.address = m_simpleTV.User.infolink.url_archive
				eventParams.params.rawM3UString = m_simpleTV.User.infolink.catchup
			 return true
			end
		 return true
		end
	end
	httpTimeshift.addEventExecutor('httpTimeshift_limehd')
