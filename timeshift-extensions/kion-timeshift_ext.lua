-- расширение дополнения httptimeshift "kion" https://kion.ru (5/12/25)
-- Copyright © 2017-2025 Nexterr, NEKTO666 | https://github.com/Nexterr-origin/simpleTV-Addons
	function httpTimeshift_kion(eventType, eventParams)
		if eventType == 'StartProcessing' then
			if not eventParams.params
				or not eventParams.params.address
			then
			 return
			end
			if not eventParams.params.address:match('%.mts%.ru') then return end
			local function DateFormat(temp)
				local temp = temp - 10800
				local newdate = os.date("%Y%m%d%H%M00", temp)
				return newdate
			end
			if eventParams.queryType == 'Start' then
				if eventParams.params.offset > 0 then
					local startTime = DateFormat((os.time() - (eventParams.params.offset / 1000)))
					local endTime = DateFormat(os.time())
					local playseek = '?playseek=' .. startTime .. '-' .. endTime .. '&timezone=UTC'
					eventParams.params.address = eventParams.params.address:gsub('%.mpd', '.mpd' .. playseek)
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
				local playseek = '?playseek=' .. progstart .. '-' .. progend .. '&timezone=UTC'
				eventParams.params.address = eventParams.params.address:gsub('%.mpd', '.mpd' .. playseek)
			 return true
			 end
		 return true
		end
	end
	httpTimeshift.addEventExecutor('httpTimeshift_kion')