--mqtt.lua
--官网:www.difiot.com
--开发板购买地址https://item.taobao.com/item.htm?spm=686.1000925.0.0.0nB7tJ&id=532760164723
----★★以下数据来源于www.tlink.io，请根据自己的实际情况修改★★----
topicToServer = "55UH3OB06NZGA65L"	--此topic用于向服务器发送的信息，该信息可通过服务器发送给APP、微信、网页
----★★以下是板子上的执行器，如灯、蜂鸣器、继电器等执行部件★★----
LEDR_ID = 200016263
LEDG_ID = 200017098
LEDB_ID = 200017104
RELAY_ID = 200017107
BEEP_ID = 200017484
--------------------------------------------------------------------
topicLEDR = topicToServer.."/"..LEDR_ID		--此topic用于订阅服务器发来的信息（板载红色LED）
topicLEDG = topicToServer.."/"..LEDG_ID		--此topic用于订阅服务器发来的信息（板载绿色LED）
topicLEDB = topicToServer.."/"..LEDB_ID		--此topic用于订阅服务器发来的信息（板载蓝色LED）
topicRELAY = topicToServer.."/"..RELAY_ID	--此topic用于订阅服务器发来的信息（板载继电器）
topicBEEP = topicToServer.."/"..BEEP_ID		--此topic用于订阅服务器发来的信息（板载蜂鸣器）
----★★以下是板子上的传感器，如按键、温度、湿度、红外接近、光敏等★★----
TEMP_ID = 200017493
HUMI_ID = 200017485
PHOTOR_ID = 200017486
IRSW_ID = 200017487
KEY_ID = 200017488
----★★默认连接tlink MQTT服务器，可根据自己实际情况修改★★----
MQTT_ADDR = "link.tlink.io"
MQTT_PORT = 1883
----★★去官网www.tlink.io注册获取，根据自己实际情况修改★★----
TLINK_USERNAME = "★★★★★"
TLINK_PASSWORD = "★★★★★"
----★★修改下面的时间可调节传感器数据上传周期，1000表示1000ms★★----
DATA2SERVER_PERIOD = 1000
--------------------------------------------------------------------
print("Pub topic:"..topicToServer)
print("Sub topicLEDR:"..topicLEDR)
print("Sub topicLEDG:"..topicLEDG)
print("Sub topicLEDB:"..topicLEDB)
print("Sub topicRELAY:"..topicRELAY)
print("Sub topicRELAY:"..topicBEEP)

----★★产生clientID，勿动★★----
math.randomseed(tmr.now()) 
clientid = math.random()*100000000000000
clientID = clientid..g_mac
--print("clientID1:"..clientID)
srand=""
for i=1, 6 do  
	rand = math.random(26)
	srand=srand..string.sub(clientID,rand,rand)
	--print(rand..":"..srand)
end
clientID = clientID..srand
print("clientID:"..clientID)
----------------------------------

----------------------------------------------------------------
m = mqtt.Client(clientID, 180, TLINK_USERNAME, TLINK_PASSWORD)
     
m:on("connect", function(client) 
	print ("----DiFi MQTT Server Connected2") 
end)
----------------------------------------------------------------

m:on("offline", function(client) 
	print ("----DiFi MQTT Server Offline") 
end)

m:on("message", function(client, topic, data) 
  if data ~= nil then
	LEDB_ONBOARD_ACTION(0)
    print("--Receive "..data.." from "..topic)
	LEDB_ONBOARD_ACTION(1)
	processdata(data)
  end
end)

while (m:connect(MQTT_ADDR, MQTT_PORT, 0, 1,
		function(client) 
			print("----Tlink MQTT Server Connected1") 
			subscribe() 
		end, 
		function(client, reason) 
			print("Failed reason: "..reason) 
		end) == false ) 
	do 
		print("False")
end

function subscribe()
	INIT_LEDBEEPRELAY()
	--tmr.delay(2000000)
	--[[
	m:subscribe({topicLEDR=0,topicLEDG=0,topicLEDB=0,topicRELAY=0},function(client) 
		print("Subscribe topicLEDR "..topicLEDR.." success") 
	end)
	--]]--
	----[[
    m:subscribe(topicLEDR, 0, function(client) 
		print("Subscribe topicLEDR "..topicLEDR.." success") 
	end)
	m:subscribe(topicLEDG, 0, function(client) 
		print("Subscribe topicLEDG "..topicLEDG.." success") 
	end)
	m:subscribe(topicLEDB, 0, function(client) 
		print("Subscribe topicLEDB "..topicLEDB.." success") 
	end)
	m:subscribe(topicRELAY, 0, function(client) 
		print("Subscribe topicRELAY "..topicRELAY.." success") 
	end)
	m:subscribe(topicBEEP, 0, function(client) 
		print("Subscribe topicBEEP "..topicBEEP.." success") 
	end)
	--]]--
end

function publish_sensors_data()
	photor,temp,humi,irsw,key = read_sensors()
	--print("photor:"..photor)
	--print("temp:"..temp)
	--print("humi:"..humi)
	--print("irsw:"..irsw)
	--print("key:"..key)
	--sensors_data='{"sensorDatas":[{"sensorsId":200017493,"value":21.3},{"sensorsId":200017485,"value":40},{"sensorsId":200017486,"value":457},{"sensorsId":200017487,"value":1},{"sensorsId":200017488,"value":1}]}'
	sensors_DataA = {}
	
	arrayData = {}
	arrayData[1] = {}
	arrayData[1]["sensorsId"] = TEMP_ID
	arrayData[1]["value"] = temp
	
	arrayData[2] = {}
	arrayData[2]["sensorsId"] = HUMI_ID
	arrayData[2]["value"] = humi
	
	arrayData[3] = {}
	arrayData[3]["sensorsId"] = PHOTOR_ID
	arrayData[3]["value"] = photor
	
	arrayData[4] = {}
	arrayData[4]["sensorsId"] = IRSW_ID
	arrayData[4]["value"] = irsw
	
	arrayData[5] = {}
	arrayData[5]["sensorsId"] = KEY_ID
	arrayData[5]["value"] = key
	
	sensors_DataA["sensorDatas"] = arrayData;
	local sensors_JsonData = cjson.encode(sensors_DataA)
	--print(sensors_JsonData)
	
	m:publish(topicToServer, sensors_JsonData, 1, 0, function(client) 
		print("Send:"..sensors_JsonData.."to "..topicToServer) 
	end)
end

tmr.register(0, DATA2SERVER_PERIOD, tmr.ALARM_AUTO, publish_sensors_data)
tmr.start(0)
----------------------------------------------------------------------