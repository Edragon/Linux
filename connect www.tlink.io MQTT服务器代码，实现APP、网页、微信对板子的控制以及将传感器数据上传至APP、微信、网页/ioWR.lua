--ioWR.lua
--www.difiot.com
--https://item.taobao.com/item.htm?spm=686.1000925.0.0.0nB7tJ&id=532760164723
function INIT_LEDBEEPRELAY()
	LEDB_ONBOARD = 4
	LEDB = 5               
	LEDR = 6                
	LEDG = 7                
	BEEP = 8
	REALY = 0 
	gpio.mode(LEDB_ONBOARD, gpio.OUTPUT)
	gpio.mode(LEDB, gpio.OUTPUT)
	gpio.mode(LEDR, gpio.OUTPUT)
	gpio.mode(LEDG, gpio.OUTPUT)
	gpio.mode(BEEP, gpio.OUTPUT)
	gpio.mode(REALY, gpio.OUTPUT)
	gpio.write(LEDB_ONBOARD, gpio.LOW)
	gpio.write(LEDB, gpio.LOW)
	gpio.write(LEDR, gpio.LOW)
	gpio.write(LEDG, gpio.LOW)
	gpio.write(BEEP, gpio.LOW)
	gpio.write(REALY, gpio.HIGH)
	print("INIT:LED BEEP RELAY")
end
---------------------------------
function LEDB_ACTION(data)
	if(data == 1)
		then gpio.write(LEDB, gpio.HIGH)
			print("LEDB:ON")
	else
		gpio.write(LEDB, gpio.LOW)
		print("LEDB:OFF")
	end
end
---------------------------------
function LEDR_ACTION(data)
	if(data == 1)
		then gpio.write(LEDR, gpio.HIGH)
			print("LEDR:ON")
	else
		gpio.write(LEDR, gpio.LOW)
		print("LEDR:OFF")
	end
end
---------------------------------
function LEDG_ACTION(data)
	if(data == 1)
		then gpio.write(LEDG, gpio.HIGH)
			print("LEDG:ON")
	else
		gpio.write(LEDG, gpio.LOW)
		print("LEDG:OFF")
	end
end
---------------------------------
function BEEP_ACTION(data)
	if(data == 1)
		then gpio.write(BEEP, gpio.HIGH)
			print("BEEP:ON")
	else
		gpio.write(BEEP, gpio.LOW)
		print("BEEP:OFF")
	end
end
---------------------------------
function RELAY_ACTION(data)
	if(data == 1)
		then gpio.write(REALY, gpio.HIGH)
			print("REALY:ON")
	else
		gpio.write(REALY, gpio.LOW)
		print("REALY:OFF")
	end
end
---------------------------------
function LEDB_ONBOARD_ACTION(data)
	if(data == 1)
		then gpio.write(LEDB_ONBOARD, gpio.HIGH)
			print("LEDB_ONBOARD:ON")
	else
		gpio.write(LEDB_ONBOARD, gpio.LOW)
		print("LEDB_ONBOARD:OFF")
	end
end
---------------------------------
function READ_PhotoR()
	--光敏传感器ID：200017486
	adc.force_init_mode(adc.INIT_ADC)
	photor = adc.read(0)
	print("PhotoR:"..photor)
	return photor
end
---------------------------------
function READ_DHT()
	DHT = 1
	----------------------
	--温度传感器ID：200017493
	--湿度传感器ID：200017485
	status, temp, humi, temp_dec, humi_dec = dht.read(DHT)
	if status == dht.OK then
			print("DHT temp:"..temp..";".."humi:"..humi)
		elseif status == dht.ERROR_CHECKSUM then
			print( "----DHT Checksum error." )
		elseif status == dht.ERROR_TIMEOUT then
			print( "----DHT timed out." )
	end
	---------------------------
	tmr.delay(50000)--延时100ms
	return temp, humi
end
---------------------------------
function READ_IRSW()
	--接近传感器ID：200017491
	IRSW = 2
	--gpio.mode(IRSW, gpio.INPUT)
	irsw = gpio.read(IRSW)
	print("IRSW:"..irsw)
	return irsw
end

IRSW = 2
gpio.mode(IRSW,gpio.INT)
gpio.trig(IRSW, "down" or "up", function()
	publish_sensors_data()
	tmr.delay(100000)--延时100ms
	--print("IRSW down")
end)
---------------------------------
function READ_KEY()
	--按键传感器ID：200017492
	KEY = 3
	--gpio.mode(KEY, gpio.INPUT)
	key = gpio.read(KEY)
	print("KEY:"..key)
	return key
end

KEY = 3
gpio.mode(KEY,gpio.INT)
gpio.trig(KEY, "down" or "up", function()
	publish_sensors_data()
	tmr.delay(100000)--延时100ms
	--print("KEY Down")
end)
---------------------------------
function read_sensors()
	photor = READ_PhotoR()
	temp, humi = READ_DHT()
	irsw = READ_IRSW()
	key = READ_KEY()
	return photor,temp,humi,irsw,key
end

