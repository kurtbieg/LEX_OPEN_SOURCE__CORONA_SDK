-- For iPads
_G.isTall=false
_G.isWide=false
local os=system.getInfo("platformName")




if	os=="iPhone OS" then
	if system.getInfo("model") == "iPad" or system.getInfo("model") == "iPad Simulator" then
		if system.getInfo( "architectureInfo")=="iPad1,1" then
			
			_G.isWide=true
			_G.isTall=false
	        application = {
	                content = {
		
	                        width = 360,
	                		height = 480,
	                        scale = "zoomEven",
	                        audioPlayFrequency="22050",
	                        fps = 60,
							antialias = false,
 
	                        imageSuffix = {
	                            ["@2x"] = 2,
	                            ["@4x"] = 4,
	                        }
	                }
	        }
		else
			_G.isWide=true
			_G.isTall=false
	        application = {
	                content = {
		
	                        width = 360,
	                		height = 480,
	                        scale = "zoomEven",
	                        audioPlayFrequency="22050",
	                        fps = 60,
							antialias = false,
 
	                        imageSuffix = {
	                            ["@2x"] = 2,
	                            ["@4x"] = 4,
	                        }
	                }
	        }
		end
        
	-- For "tall" sizes (iPhone 5 and new iTouch)
	elseif display.pixelHeight > 960 then
			_G.isTall=true
			_G.isWide=false
	 		print("THIS IS A NEW IPHONE 5")
	        application = {
	                content = {
		
	                        width = 320,
	                        height = 568, 
	                        scale = "zoomEven",
	                        audioPlayFrequency="22050",
	                        fps = 60,
							antialias = false,
 
	                        imageSuffix = {
	                            ["@2x"] = 2,
	                            ["@4x"] = 4,
	
	                        }
	                }
	        }



 
	else -- For traditional sizes (iPhone 4S & below, old iTouch)
	 		print("THIS IS OLD SCHOOL")
			_G.isTall=false
			_G.isWide=false
			print(display.pixelHeight)
	        application = {
	                content = {
		
	                        width = 320,
	                        height = 480, 
	                        scale = "zoomEven",
	                        audioPlayFrequency="22050",
	                        fps = 60,
							antialias = false,
	                        imageSuffix = {
	                            ["@2x"] = 2,
	                            ["@4x"] = 4,
	                        }
	                },
						
	        }
	
                
	end
else
		print("I MADE IT THIS FAR")

		-- For "tall" sizes (iPhone 5 and new iTouch)
		if display.pixelHeight > 960 then
				_G.isTall=true
				_G.isWide=false
		 		print("THIS IS A NEW IPHONE 5")
		        application = {
		                content = {
			
		                        width = 320,
		                        height = 568, 
		                        scale = "letterbox",
		                        audioPlayFrequency="22050",
						        xAlign = "center",
						        yAlign = "center",
		                        fps = 60,
								antialias = false,
		 
		                        imageSuffix = {
		                            ["@2x"] = 2,
		                            ["@4x"] = 4,
		                        }
		                },		
		        }
		
		
		
		 
		else -- For traditional sizes (iPhone 4S & below, old iTouch)
				_G.isTall=false
				_G.isWide=false
				print(display.pixelHeight)
		        application = {
		                content = {
			
		                        width = 320,
		                        height = 480, 
		                        scale = "letterbox",
		                        audioPlayFrequency="22050",
		                        fps = 60,
								antialias = false,
		                        imageSuffix = {
		                            ["@2x"] = 2,
		                            ["@4x"] = 4,
								}
		                },

		        }
		end

end	





	

