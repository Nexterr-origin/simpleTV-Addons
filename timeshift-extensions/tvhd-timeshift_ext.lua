-- расширение дополнения httptimeshift "tv+hd" http://www.tvplusonline.ru (24/3/21)
-- Copyright © 2017-2021 Nexterr | https://github.com/Nexterr-origin/simpleTV-Addons
	function httpTimeshift_tvhd(eventType, eventParams)
		if eventType == 'StartProcessing' then
			if not eventParams.params
				or not eventParams.params.address
			then
			 return
			end
			if not eventParams.params.address:match('tvplusonline')
				and not eventParams.params.address:match('tvplusstreaming')
			then
			 return
			end
			if eventParams.queryType == 'Start' or eventParams.queryType == 'GetRecordAddress' then
				if eventParams.params.offset > 0 then
					local function tvhd_url_archive()
						local url
						local offset = math.floor(eventParams.params.offset / 1000)
						if not eventParams.params.address:match('token=') then
							local id = eventParams.params.address:match('https?://[^/]+/([^/]+)')
								if not id then return end
							local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; rv:86.0) Gecko/20100101 Firefox/86.0')
								if not session then return end
							m_simpleTV.Http.SetTimeout(session, 8000)
							url = string.format(decode64('aHR0cHM6Ly93d3cudHZwbHVzb25saW5lLnJ1L2dldHNpZ25lZGR2ci5waHA/ZHVyYXRpb249NjAwJnN0cmVhbT0lcyZ0aW1lPSVz'), id, os.time() - offset)
							local rc, answer = m_simpleTV.Http.Request(session, {url = url})
							m_simpleTV.Http.Close(session)
								if rc ~= 200 then return end
							url = answer:gsub('%c', '')
						else
							url = eventParams.params.address
						end
					 return url:gsub('^(.+/).-(%..-)$', '%1timeshift_rel-' .. offset .. '%2')
					end
					eventParams.params.address = tvhd_url_archive() or eventParams.params.address
				end
			 return true
			end
		 return true
		end
	end
	httpTimeshift.addEventExecutor('httpTimeshift_tvhd')
