-- расширение дополнения httptimeshift - bluepoint (18/21/21)
-- Copyright © 2017-2021 Nexterr | https://github.com/Nexterr-origin/simpleTV-Addons
	function httpTimeshift_bluepoint(eventType, eventParams)
		if eventType == 'StartProcessing' then
			if not eventParams.params
				or not eventParams.params.address
			then
			 return
			end
			if not ((eventParams.params.address:match('bluepointtv') or eventParams.params.address:match('//98%.158%.107%.'))
				and m_simpleTV.User
				and m_simpleTV.User.bluepoint
				and m_simpleTV.User.bluepoint.url_archive)
			then
			 return
			end
			if eventParams.queryType == 'Start' then
				if eventParams.params.offset > 0 then
					eventParams.params.address = m_simpleTV.User.bluepoint.url_archive
				end
			 return true
			end
			if eventParams.queryType == 'GetRecordAddress' then
				eventParams.params.address = m_simpleTV.User.bluepoint.url_archive
			 return true
			end
		 return true
		end
	end
	httpTimeshift.addEventExecutor('httpTimeshift_bluepoint')
