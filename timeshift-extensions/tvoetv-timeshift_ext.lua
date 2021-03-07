-- расширение дополнения httptimeshift - tvoetv (21/10/20)
-- Copyright © 2017-2020 Nexterr | https://github.com/Nexterr-origin/simpleTV-Addons 
	function httpTimeshift_tvoetv(eventType, eventParams)
		if eventType == 'StartProcessing' then
			if not eventParams.params
				or not eventParams.params.address
				or not eventParams.params.rawM3UString
			then
			 return
			end
			if not eventParams.params.address:match('onlineott%.tv.-(&cid=%d)') -- tvoetv
				and not eventParams.params.rawM3UString:match('catchup')
			then
			 return
			end
			if eventParams.queryType == 'Start' or eventParams.queryType == 'GetRecordAddress' then
				if eventParams.params.offset > 0 then
					local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0) AppleWebKit/538.1 (KHTML, like Gecko) SmartUP TV/1.0.1 Safari/538.1')
						if not session then return end
					m_simpleTV.Http.SetTimeout(session, 2000)
					local url = 'http://ott.onlineott.tv'
					local headers =	'X-Requested-With: XMLHttpRequest'
						local function getToken()
							if not m_simpleTV.User.tvoetv.login then
								local ret, login, pass
								local error_text, pm = pcall(require, 'pm')
								if package.loaded.pm then
									ret, login, pass = pm.GetTestPassword('tvoetv', 'ТВОЄ ТВ', true)
								end
									if not login or not pass or login == '' or pass == '' then return end
								m_simpleTV.User.tvoetv.login = login
								m_simpleTV.User.tvoetv.pass = pass
							end
							local n = {8, 4, 4, 4, 12}
							local duid = {}
								for i = 1, 5 do
									local d = {}
										for z = 1, n[i] do
											d[z] = {}
											d[z] = string.format('%x', math.random(0, 15))
										end
									duid[i] = {}
									duid[i] = table.concat(d)
								end
							duid = table.concat(duid, '-')
							local b = 'platform=smartup&lid=ru&duid=' .. duid
							local body = b
							local rc, answer = m_simpleTV.Http.Request(session, {url = url .. '/auth', method = 'post', headers = headers, body = body})
								if rc ~= 200 then return end
							local aid = answer:match('"aid":"(%x+)')
								if not aid then return end
							body = b .. '&signin[login]=' .. m_simpleTV.User.tvoetv.login
									.. '&signin[key]=' .. m_simpleTV.User.tvoetv.pass
									.. '&aid=' .. aid
							rc, answer = m_simpleTV.Http.Request(session, {url = url .. '/auth', method = 'post', headers = headers, body = body})
								if rc ~= 200 then return end
						 return answer:match('"token":"([^"]+)'), b
						end
					if not m_simpleTV.User then
						m_simpleTV.User = {}
					end
					if not m_simpleTV.User.tvoetv then
						m_simpleTV.User.tvoetv = {}
					end
					local token, b = getToken()
						if not token then
							m_simpleTV.User.tvoetv = nil
							m_simpleTV.Http.Close(session)
						 return
						end
					local body = b
								.. '&token=' .. token
								.. '&module=tv&cid=' .. (eventParams.params.address:match('&cid=(%d+)') or 0)
								.. '&time=' .. math.floor(os.time() - (eventParams.params.offset / 1000))
					local rc, answer = m_simpleTV.Http.Request(session, {url = url .. '/tv/archive', method = 'post', headers = headers, body = body})
					m_simpleTV.Http.Close(session)
						if rc ~= 200 then return end
					local url = answer:match('"url":"([^"]+)')
						if not url then return end
					url = url:gsub('\\/', '/')
						if eventParams.queryType == 'GetRecordAddress' then
							local days = eventParams.params.rawM3UString:match('catchup%-days="(%d+)')
							eventParams.params.address = url:gsub('/video%-.-%?', '/video.m3u8?')
							eventParams.params.rawM3UString = 'catchup="flussonic" catchup-days="' .. days .. '"'
						 return true
						end
					eventParams.params.address = url
				end
			 return true
			end
		 return true
		end
	end
	httpTimeshift.addEventExecutor('httpTimeshift_tvoetv')
