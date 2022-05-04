-- расширение дополнения httptimeshift - tvoetv (4/5/22)
-- Copyright © 2017-2022 Nexterr | https://github.com/Nexterr-origin/simpleTV-Addons
	function httpTimeshift_tvoetv(eventType, eventParams)
		if eventType == 'StartProcessing' then
			if not eventParams.params
				or not eventParams.params.address
				or not eventParams.params.rawM3UString
			then
			 return
			end
			if not eventParams.params.address:match('onlineott%.tv') -- tvoetv
				and not eventParams.params.address:match('%.wisp%.cat')
				and not eventParams.params.rawM3UString:match('catchup')
			then
			 return
			end
			if eventParams.queryType == 'Start' or eventParams.queryType == 'GetRecordAddress' then
				if eventParams.params.offset > 0 then
					local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0) AppleWebKit/538.1 (KHTML, like Gecko) SmartUP TV/1.0.1 Safari/538.1', nil, true)
						if not session then return end
					m_simpleTV.Http.SetTimeout(session, 5000)
					m_simpleTV.Http.SetRedirectAllow(session, false)
					m_simpleTV.Http.Request(session, {url = eventParams.params.address})
					local raw = m_simpleTV.Http.GetRawHeader(session)
					m_simpleTV.Http.Close(session)
						if not raw then return end
					local url = raw:match('Location: (.-)\n')
						if not url then return end
					local tt = 	math.floor(os.time() - (eventParams.params.offset / 1000))
					eventParams.params.address = url:gsub('/video[^%.]-', '/video-' .. tt .. '-120')
				end
			 return true
			end
		 return true
		end
	end
	httpTimeshift.addEventExecutor('httpTimeshift_tvoetv')