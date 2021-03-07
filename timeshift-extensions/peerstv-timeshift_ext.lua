-- расширение дополнения httptimeshift - peersTV (21/10/20)
-- Copyright © 2017-2020 Nexterr | https://github.com/Nexterr-origin/simpleTV-Addons 
	function httpTimeshift_peerstv(eventType, eventParams)
		if eventType == 'StartProcessing' then
			if not eventParams.params
				or not eventParams.params.address
			then
			 return
			end
			if not (eventParams.params.address:match('peers%.tv.-PARAMS=peers_tv')
				and m_simpleTV.User
				and m_simpleTV.User.peerstv
				and m_simpleTV.User.peerstv.url_archive)
			then
			 return
			end
			if eventParams.queryType == 'Start' then
				if eventParams.params.offset > 0 then
					eventParams.params.address = m_simpleTV.User.peerstv.url_archive
				end
			 return true
			end
			if eventParams.queryType == 'GetRecordAddress' then
				eventParams.params.address = m_simpleTV.User.peerstv.url_archive
			 return true
			end
		 return true
		end
	end
	httpTimeshift.addEventExecutor('httpTimeshift_peerstv')
