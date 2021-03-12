-- расширение дополнения httptimeshift "tv+hd" http://www.tvplusonline.ru (10/3/21)
-- Copyright © 2017-2021 Nexterr | https://github.com/Nexterr-origin/simpleTV-Addons
	function httpTimeshift_tvhd(eventType, eventParams)
		if eventType == 'StartProcessing' then
			if not eventParams.params
				or not eventParams.params.address
			then
			 return
			end
			if not (eventParams.params.address:match('tvplusonline')
				and m_simpleTV.User
				and m_simpleTV.User.tvhd
				and m_simpleTV.User.tvhd.address)
			then
			 return
			end
			if eventParams.queryType == 'Start' or eventParams.queryType == 'GetRecordAddress' then
				if eventParams.params.offset > 0 then
					local function tvhd_url_archive()
						local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; rv:86.0) Gecko/20100101 Firefox/86.0')
							if not session then return end
						m_simpleTV.Http.SetTimeout(session, 5000)
						local start = math.floor(os.time() - eventParams.params.offset / 1000)
						local url = string.format('https://www.tvplusonline.ru/getsigneddvr.php?duration=600&stream=%s&time=%s', m_simpleTV.User.tvhd.address, start)
						url = url:gsub('$OPT:.+', '')
						local rc, answer = m_simpleTV.Http.Request(session, {url = url})
							if rc ~= 200 then return end
						m_simpleTV.Http.Close(session)
						answer = answer:gsub('%c', '')
						answer = answer:gsub('^(.+/).-(%..-)$', '%1timeshift_rel-' .. math.floor(eventParams.params.offset / 1000) .. '%2')
					 return answer
					end
					local adr = tvhd_url_archive()
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
	httpTimeshift.addEventExecutor('httpTimeshift_tvhd')