--processdata.lua
--官网:www.difiot.com
--开发板购买地址https://item.taobao.com/item.htm?spm=686.1000925.0.0.0nB7tJ&id=532760164723
function processdata(JsonData)
	--local JsonData = '{"sensorDatas":[{"sensorsId":200016264,"switcher":0}]}'
	JsonData = string.gsub(JsonData,"%[","")
	JsonData = string.gsub(JsonData,'%]',"")
	--print("--JsonData:"..JsonData)
	local data = cjson.decode(JsonData)
	--print(data["sensorDatas"]["sensorsId"])
	--print(data["sensorDatas"]["switcher"])
	
	----★★以下sensorsId数据来源于www.tlink.io，请根据自己的实际情况修改★★----
	if(data["sensorDatas"]["sensorsId"] == LEDR_ID)
	then
		LEDR_ACTION(data["sensorDatas"]["switcher"])
	end
	
	if(data["sensorDatas"]["sensorsId"] == LEDG_ID)
	then
		LEDG_ACTION(data["sensorDatas"]["switcher"])
	end
	
	if(data["sensorDatas"]["sensorsId"] == LEDB_ID)
	then
		LEDB_ACTION(data["sensorDatas"]["switcher"])
	end
	
	if(data["sensorDatas"]["sensorsId"] == RELAY_ID)
	then
		RELAY_ACTION(data["sensorDatas"]["switcher"])
	end
	
	if(data["sensorDatas"]["sensorsId"] == BEEP_ID)
	then
		BEEP_ACTION(data["sensorDatas"]["switcher"])
	end
	-----------------------------------------------------------------------------
end
