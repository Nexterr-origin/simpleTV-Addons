-- расширение дополнения httptimeshift - persik (15/12/20)
-- Copyright © 2017-2020 Nexterr | https://github.com/Nexterr-origin/simpleTV-Addons 
	function httpTimeshift_persik(eventType, eventParams)
		if eventType == 'StartProcessing' then
			if not eventParams.params
				or not eventParams.params.address
				or not eventParams.params.rawM3UString
			then
			 return
			end
			if not eventParams.params.address:match('persik%.by') -- persik
			then
			 return
			end
			if eventParams.queryType == 'Start' then
				if eventParams.params.offset > 0 then
					local function persik_url_archive(url)
						local ch = url:match('/Ch%d+/')
						if not ch then
							local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; rv:85.0) Gecko/20100101 Firefox/85.0', nil, true)
								if not session then return end
							m_simpleTV.Http.SetTimeout(session, 5000)
							m_simpleTV.Http.SetRedirectAllow(session, false)
							m_simpleTV.Http.Request(session, {url = url, method = 'head'})
							url = m_simpleTV.Http.GetRawHeader(session)
							m_simpleTV.Http.Close(session)
								if not url then return end
							ch = url:match('/Ch%d+/')
								if not ch then return end
						end
					 return 'https://dvr.persik.by/dvr/live' .. ch .. 'dvr.m3u8?d=20800&s='
					end
					local adr = persik_url_archive(eventParams.params.address)
						if not adr then
						 return true
						end
					eventParams.params.address = adr .. math.floor(os.time() - eventParams.params.offset / 1000)
				end
			 return true
			end
		 return true
		end
	end
	httpTimeshift.addEventExecutor('httpTimeshift_persik')