-- расширение дополнения httptimeshift limeHD (5/1/23)
-- Copyright © 2017-2023 Nexterr | https://github.com/Nexterr-origin/simpleTV-Addons
	function httpTimeshift_limehd(eventType, eventParams)
		if eventType == 'StartProcessing' then
			if not eventParams.params
				or not eventParams.params.address
			then
			 return
			end
			if not ((eventParams.params.address:match('limehd%.')
				or eventParams.params.address:match('iptv2022%.'))
				and m_simpleTV.User
				and m_simpleTV.User.infolink
				and m_simpleTV.User.infolink.url_archive)
			then
			 return
			end
			if eventParams.queryType == 'Start'
				or eventParams.queryType == 'GetRecordAddress'
			then
				if eventParams.params.offset > 0 then
					local starttime = math.floor(os.time() - (eventParams.params.offset / 1000))
					local len = os.time() - starttime
					eventParams.params.address = m_simpleTV.User.infolink.url_archive .. '/index-' .. starttime .. '-' .. len .. '.m3u8'
				end
			 return true
			end
		 return true
		end
	end
	httpTimeshift.addEventExecutor('httpTimeshift_limehd')
