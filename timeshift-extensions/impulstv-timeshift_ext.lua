-- расширение дополнения httptimeshift - impulsTV (21/10/20)
-- Copyright © 2017-2020 Nexterr | https://github.com/Nexterr-origin/simpleTV-Addons 
	function httpTimeshift_impulstv(eventType, eventParams)
		if eventType == 'StartProcessing' then
			if not eventParams.params
				or not eventParams.params.address
			then
			 return
			end
			if not (eventParams.params.address:match('microimpuls') -- impulsTV
				and m_simpleTV.User
				and m_simpleTV.User.impulstv
				and m_simpleTV.User.impulstv.cid_sid)
			then
			 return
			end
			if eventParams.queryType == 'Start' then
				if eventParams.params.offset > 0 then
					eventParams.params.address = impulstv_url_archive(eventParams.params.offset) or eventParams.params.address
				end
			 return true
			end
			if eventParams.queryType == 'GetRecordAddress' then
				eventParams.params.address = impulstv_url_archive(eventParams.params.offset) or eventParams.params.address
			 return true
			end
		 return true
		end
	end
	httpTimeshift.addEventExecutor('httpTimeshift_impulstv')
