-- расширение дополнения httptimeshift - "title" (18/3/21)
-- Copyright © 2017-2021 Nexterr | https://github.com/Nexterr-origin/simpleTV-Addons
-- выводит на экране/панели 'Архив ...'
	function httpTimeshift_title(eventType, eventParams)
		if eventType == 'StartProcessing' then
			if not eventParams.params
				or not eventParams.params.address
			then
			 return
			end
			if eventParams.queryType == 'Start' then
				if eventParams.params.offset > 0 then
					m_simpleTV.Control.SetTitle('')
					local timeshift_date = os.date('%x %X', (os.time() - math.floor(eventParams.params.offset / 1000)))
					local month, day, year, hour, min, _ = timeshift_date:match('(%d+)/(%d+)/(%d+) (%d+):(%d+):(%d+)')
					if day and month and hour and min then
						day = string.format('%d', day)
						hour = string.format('%d', hour)
						month = tonumber(month)
						local t = {'января', 'февраля', 'марта', 'апреля', 'мая', 'июня', 'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря',}
						month = t[month]
						local str = string.format(' (Архив %s %s в %s:%s)', day, month, hour, min)
						local title = m_simpleTV.Control.GetTitle() .. str
						m_simpleTV.Control.SetTitle(title)
						m_simpleTV.OSD.ShowMessageT({text = title, showTime = 5000, id = 'channelName'})
					end
				end
			end
		end
	end
	httpTimeshift.addEventExecutor('httpTimeshift_title')
