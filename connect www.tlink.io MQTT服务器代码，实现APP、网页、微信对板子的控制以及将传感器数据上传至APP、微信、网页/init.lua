--init.lua
--官网:www.difiot.com
--开发板购买地址https://item.taobao.com/item.htm?spm=686.1000925.0.0.0nB7tJ&id=532760164723
if true then  --change to if true 
    g_mac=nil   
    print("----Set up WiFi, please Waiting...")
    wifi.setmode(wifi.STATION)
	--下面设置你的WIFI名字和密码，请根据您的实际情况修改----
	WIFI_NAME = "★★★★★"
	WIFI_PASSWORD = "★★★★★"
	--------------------------------------------------------
    wifi.sta.config(WIFI_NAME,WIFI_PASSWORD)
    wifi.sta.connect()
    cnt = 0
    tmr.alarm(1, 1000, tmr.ALARM_AUTO, function() 
        if (wifi.sta.getip() == nil) and (cnt < 20) then 
            print("----IP unavaiable, Waiting...")
            cnt = cnt + 1 
        else 
            tmr.stop(1)
            if (cnt < 20) then print("Got IP:"..wifi.sta.getip())
                MAC=wifi.sta.getmac()
                mac=string.gsub(MAC,":","")
                g_mac = mac
				print("MAC:"..MAC)
				print("mac:"..mac)
				--dofile("dht11.lua")
				dofile("ioWR.lua")
				dofile("mqtt.lua")
				dofile("processdata.lua")
                --dofile("mqtt.lua")    --这里设置自动执行的程序。
                --dofile("uart.lua")    --这里设置自动执行的程序。        
            else 
                print("----No Wifi Connected.")    
            end
        end 
     end)
else
    print("\n")
    print("Please check 'init.lua' first")
end