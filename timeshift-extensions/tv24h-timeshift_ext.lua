-- расширение дополнения httptimeshift - tv24h (28/12/20)
-- Copyright © 2017-2020 Nexterr | https://github.com/Nexterr-origin/simpleTV-Addons 
	function httpTimeshift_tv24h(eventType, eventParams)
		if eventType == 'StartProcessing' then
			if not eventParams.params
				or not eventParams.params.address
			then
			 return
			end
			if not (eventParams.params.address:match('24h%.tv') -- 24htv
				and m_simpleTV.User
				and m_simpleTV.User.tv24h
				and m_simpleTV.User.tv24h.address)
			then
			 return
			end
			if eventParams.queryType == 'Start' or eventParams.queryType == 'GetRecordAddress' then
				if eventParams.params.offset > 0 then
					local function tv24h_url_archive()
						local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; rv:85.0) Gecko/20100101 Firefox/85.0')
							if not session then return end
						m_simpleTV.Http.SetTimeout(session, 3000)
						local offset = math.floor(os.time() - (eventParams.params.offset / 1000))
						local url = m_simpleTV.User.tv24h.address .. '&ts=' .. offset
						local rc, answer = m_simpleTV.Http.Request(session, {url = url})
							if rc ~= 200 then return end
					 return answer:match('"hls":"([^"]+)')
					end
					local adr = tv24h_url_archive()
						if not adr then
						 return true
						end
					eventParams.params.address = adr
				end
			 return true
			end
		 return true
		end
	end
	httpTimeshift.addEventExecutor('httpTimeshift_tv24h')