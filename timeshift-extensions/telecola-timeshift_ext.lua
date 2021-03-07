-- расширение дополнения httptimeshift - telecola (21/10/20)
-- Copyright © 2017-2020 Nexterr | https://github.com/Nexterr-origin/simpleTV-Addons 
	function httpTimeshift_telecola(eventType, eventParams)
		if eventType == 'StartProcessing' then
			if not eventParams.params
				or not eventParams.params.address
			then
			 return
			end
			if not (eventParams.params.address:match('telecola')
				and m_simpleTV.User
				and m_simpleTV.User.telecola
				and m_simpleTV.User.telecola.cid_sid)
			then
			 return
			end
			if eventParams.queryType == 'Start' then
				if eventParams.params.offset > 0 then
					eventParams.params.address = telecola(eventParams.params.offset) or eventParams.params.address
				end
			 return true
			end
		 return true
		end
	end
	httpTimeshift.addEventExecutor('httpTimeshift_telecola')
