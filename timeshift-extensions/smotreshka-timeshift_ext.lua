-- расширение дополнения httptimeshift - Смотрёшка (21/10/20)
-- Copyright © 2017-2020 Nexterr | https://github.com/Nexterr-origin/simpleTV-Addons 
	function httpTimeshift_smotreshka(eventType, eventParams)
		if eventType == 'StartProcessing' then
			if not eventParams.params
				or not eventParams.params.address
			then
			 return
			end
			if not eventParams.params.address:match('lfstrm%.tv')
			then
			 return
			end
			if eventParams.queryType == 'Start' then
				if eventParams.params.offset > 0 then
					eventParams.params.address = eventParams.params.address:gsub('%-live', '-dvr')
				end
			 return true
			end
			if eventParams.queryType == 'GetRecordAddress' then
				eventParams.params.address = eventParams.params.address:gsub('%-live', '-dvr')
			 return true
			end
		 return true
		end
	end
	httpTimeshift.addEventExecutor('httpTimeshift_smotreshka')
