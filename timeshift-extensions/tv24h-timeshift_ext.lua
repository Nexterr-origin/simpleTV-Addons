-- расширение дополнения httptimeshift - tv24h (18/11/22)
-- Copyright © 2017-2022 Nexterr | https://github.com/Nexterr-origin/simpleTV-Addons
	function httpTimeshift_tv24h(eventType, eventParams)
		if eventType == 'StartProcessing' then
			if not eventParams.params
				or not eventParams.params.address
			then
			 return
			end
			if not ((eventParams.params.address:match('24h%.tv')
							or eventParams.params.address:match('tv24h/%d'))
				and m_simpleTV.User
				and m_simpleTV.User.tv24h
				and m_simpleTV.User.tv24h.address)
			then
			 return
			end
			if eventParams.queryType == 'Start' or eventParams.queryType == 'GetRecordAddress' then
				if eventParams.params.offset > 0 then
					local function tv24h_url_archive()
						local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101 Firefox/102.0')
							if not session then return end
						m_simpleTV.Http.SetTimeout(session, 5000)
						local offset = math.floor(os.time() - (eventParams.params.offset / 1000))
						local url = m_simpleTV.User.tv24h.address .. '&ts=' .. offset
						local rc, answer = m_simpleTV.Http.Request(session, {url = url})
							if rc ~= 200 then return end
					 return answer:match('"hls_mbr":"([^"]+)') or answer:match('"hls":"([^"]+)')
					end
					local adr = tv24h_url_archive()
						if not adr then
						 return true
						end
					local qv = eventParams.params.address:match('$OPT:.+') or ''
					eventParams.params.address = adr .. qv
				end
			 return true
			end
		 return true
		end
	end
	httpTimeshift.addEventExecutor('httpTimeshift_tv24h')