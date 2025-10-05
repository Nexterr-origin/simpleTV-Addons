-- расширение дополнения httptimeshift - tricolor (5/10/25)
-- Copyright © 2017-2025 Nexterr, NEKTO666 | https://github.com/Nexterr-origin/simpleTV-Addons
	function httpTimeshift_tricolor(eventType, eventParams)
		if eventType == 'StartProcessing' then
			if not eventParams.params
				or not eventParams.params.address
			then
			 return
			end
			if not (eventParams.params.address:match('tricolor%.tv')
				and m_simpleTV.User
				and m_simpleTV.User.tricolor
				and m_simpleTV.User.tricolor.url_archive)
			then
			 return
			end
			local function DateFormat(temp)
				local newdate = os.date("!%d/%m/%YT%H:%M:%S", temp)
				return newdate
			end
			if eventParams.queryType == 'Start' then
				if eventParams.params.offset > 0 then
					local currentTime = os.time()
					local startTime = DateFormat((currentTime - (eventParams.params.offset / 1000)))
					local endTime = DateFormat(currentTime)
					local url = m_simpleTV.User.tricolor.url_archive
					url = url .. '&startTime=' .. startTime .. '&endTime=' .. endTime
					eventParams.params.address = url
				end
			 return true
			end
			if eventParams.queryType == 'GetRecordAddress'
				or eventParams.queryType == 'IsRecordAble'
			then
				local progid = eventParams.params.epgId
				local prog = m_simpleTV.EPG.GetProgrammeById(progid)
				local progstart = DateFormat(prog.Start)
				local progend = DateFormat(prog.End)
				local url = m_simpleTV.User.tricolor.url_archive
				url = url .. '&startTime=' .. progstart .. '&endTime=' ..  progend
				eventParams.params.address = url
			 return true
			 end
		 return true
		end
	end
	httpTimeshift.addEventExecutor('httpTimeshift_tricolor')
