fn KEY con axiscon keyvalue =
(
	
	addNewKey con currentTime
	conkeys = con.keys
					
	keyindex = getKeyIndex axiscon currentTime
	conkeys[keyindex].value = keyvalue
	conkeys[keyindex].inTangentType = #linear
	conkeys[keyindex].outTangentType = #linear
	
)


rollout TransferKeys "TransferKeys" width:162 height:300
(
	label 'lbl1' "Select source first" pos:[34,9] width:93 height:20 align:#left
	label 'lbl2' "Then select target bone" pos:[17,25] width:124 height:23 align:#left
	dropDownList 'ddl1' "Keys Type" pos:[21,152] width:112 height:41 items:#("Every Frame", "Keys Frame","Time Silder","Agent Keys Frame") selection:1 align:#left
	checkbox 'check_x' "Transfer_X" pos:[21,188] width:110 height:29 checked:false align:#left
	checkbox 'check_y' "Transfer_Y" pos:[20,216] width:110 height:29 checked:true align:#left
	checkbox 'check_z' "Transfer_Z" pos:[21,244] width:110 height:29 checked:false align:#left
	checkbox 'keep_source' "KeepSource" pos:[21,274] width:110 height:29 checked:false align:#left
	
	spinner 'spinner_starttime' "" pos:[33,77] width:95 height:16 range:[0,1000,0] type:#integer scale:1 align:#left
	label 'lbl3' "StartTime" pos:[19,61] width:78 height:15 align:#left
	label 'lbl4' "EndTime" pos:[21,98] width:75 height:16 align:#left
	spinner 'spinner_endtime' "" pos:[33,115] width:96 height:16 range:[0,1000,0] type:#integer scale:1 align:#left
	
	pickbutton 'chooseit' "Select Agent" pos:[24,320] width:110 height:30

	listBox 'lbx3' "Agent Bone" pos:[20,370] width:105 height:5 align:#left
	
	button 'btn2' "Add" pos:[18,460] width:50 height:26 align:#left
	button 'btn3' "Remove" pos:[86,460] width:50 height:26 align:#left
	button 'btn4' "Calculate Agent With Agent Bone" pos:[27,500] width:101 height:28 align:#left
	
	button 'btn1' "Generate" pos:[27,550] width:101 height:50 align:#left
	
	
	on btn2 pressed do
	(
		--lbx3.items = append lbx3.items for o in selection collect o.name
			
		for o in selection do
		(
			lbx3.items = append lbx3.items o.name
		)
	)
	
	on btn3 pressed do
	(
		if lbx3.items.count > 0 and lbx3.selection > 0 do
			lbx3.items = deleteItem lbx3.items lbx3.selection
	)
	
	on btn4 pressed do
	(
						
		sourcekeys = chooseit.object.pos.controller.keys
			
			for k in sourcekeys do
			(
				sliderTime = k.time				
								
				position = [0,0,0]
				
				for i = 1 to lbx3.items.count do
				(
					
					agentbonetemp = getNodeByName lbx3.items[i]
					--print agentbonetemp[3].value.row4
					
					if (classOf agentbonetemp == Biped_Object) then
					(
						position = position + agentbonetemp[3].value.row4
					)
					else
					(
						position = position + agentbonetemp.pos
					)
					
				)
				position = position / lbx3.items.count
				
				if (k.time == sourcekeys[1].time) then
				(
					if (classOf selection[1] == Biped_Object) then
					(
						position = selection[1][3].value.row4
					)
					else
					(
						position = selection[1].pos
					)
				)
				
				if (k.time == sourcekeys[sourcekeys.count].time) then
				(
					
					if (classOf selection[1] == Biped_Object) then
					(
						position = selection[1][3].value.row4
					)
					else
					(
						position = selection[1].pos
					)
					
					print k.time
					print position

				)
					
				if (classOf target == Biped_Object) then
				(
					biped.setTransform target #pos position true
													
				)
				else
				(
					
					--animate on
					--(
					--	chooseit.object.pos = position
					--)
					
					if check_x.checked == true do
					(
						KEY chooseit.object[3][1][1] chooseit.object.pos.controller.X_Position.controller position.x
					)
						
					if check_y.checked == true do
					(
						KEY chooseit.object[3][1][2] chooseit.object.pos.controller.Y_Position.controller position.y
					)
						
					if check_z.checked == true do
					(
						KEY chooseit.object[3][1][3] chooseit.object.pos.controller.Z_Position.controller position.z
					)
					
					
					
					
					
				)
							
							
			)
		
	)
	
	
	
	on TransferKeys open do
	(
		spinner_starttime.value = animationrange.start
		spinner_endtime.value = animationrange.end
				
	)
	
	on chooseit picked obj do
	(
		chooseit.text = obj.name
		chooseit.object = obj
	)
	
	on btn1 pressed  do
	(
		
		start = spinner_starttime.value
		end = spinner_endtime.value
		
		source = selection[1]
		target = selection[2]
		
		sourcename = source[3][1].name
		targetname = target[3][1].name
		
		--Delete all Keys
		deleteKeys target.position.controller #allKeys
		
		if (ddl1.selection == 1) do
		(
			
			
			
			if (classOf source == Biped_Object) then
			(
						
				
				for i = start to end do
				(
					sliderTime = i
					
					if (classOf source == Biped_Object) then
					(
						position = source[3].value.row4								
															
					)
					else
					(
						position = source.pos
					)
					
					if (classOf target == Biped_Object) then
					(
						biped.setTransform target #pos position true
													
					)
					else
					(
						if check_x.checked == true do
						(
							KEY target[3][1][1] target.pos.controller.X_Position.controller position.x
						)
						
						if check_y.checked == true do
						(
							KEY target[3][1][2] target.pos.controller.Y_Position.controller position.y
						)
						
						if check_z.checked == true do
						(
							KEY target[3][1][3] target.pos.controller.Z_Position.controller position.z
						)
					)
							
							
				)
						
			)
			
			
		)
		
		
		
		if (ddl1.selection == 2) do
		(
			
			
			
			if (classOf source == Biped_Object) then
			(
				
				sourcekeys = source[3][2].controller.keys
				
				--print source[3].controller
				--print source[3][1]
				--print source[3][1].controller
				--print source.controller
				--print source[3][1].controller.keys				
				
				for k in sourcekeys do
				(
					sliderTime = k.time
					
					if (classOf source == Biped_Object) then
					(
						position = source[3].value.row4								
															
					)
					else
					(
						position = source.pos
					)
					
					if (classOf target == Biped_Object) then
					(
						biped.setTransform target #pos position true
													
					)
					else
					(
						if check_x.checked == true do
						(
							KEY target[3][1][1] target.pos.controller.X_Position.controller position.x
						)
						
						if check_y.checked == true do
						(
							KEY target[3][1][2] target.pos.controller.Y_Position.controller position.y
						)
						
						if check_z.checked == true do
						(
							KEY target[3][1][3] target.pos.controller.Z_Position.controller position.z
						)
					)
							
							
				)
						
			)
			
			
		)
		
		if (ddl1.selection == 3) do
		(
			
			sliderTime = start
			
			
			if (classOf source == Biped_Object) then
			(
				position = source[3].value.row4
				
				print "Start Pos"
				print source[3].value.row4
				
				--print source.controller
											
			)
			else
			(
				position = source.pos
			)
			
			if (classOf target == Biped_Object) then
			(
				biped.setTransform target #pos position true
											
			)
			else
			(
				
				--with animate on ( at time currentTime target.pos = position )
				
				--addNewKey target[3][1] currentTime
				--targetcontroller = target[3][1]
				--keyindex = getKeyIndex target.position.controller currentTime
				--targetkeys = targetcontroller.keys
				--targetkeys[keyindex + 1].value = position
				
				if check_x.checked == true do
				(	
					controllerX = target[3][1][1]
					addNewKey controllerX currentTime
					Xkeys = controllerX.keys
					
					keyindex = getKeyIndex target.pos.controller.X_Position.controller currentTime
					Xkeys[keyindex].value = position.x
					Xkeys[keyindex].inTangentType = #linear
					Xkeys[keyindex].outTangentType = #linear
				)
				
				if check_y.checked == true do
				(	
					controllerY = target[3][1][2]
					addNewKey controllerY currentTime
					Ykeys = controllerY.keys
					
					keyindex = getKeyIndex target.pos.controller.Y_Position.controller currentTime
					--print keyindex
					Ykeys[keyindex].value = position.y
					Ykeys[keyindex].inTangentType = #linear
					Ykeys[keyindex].outTangentType = #linear
				)
				if check_z.checked == true do
				(	
					controllerZ = target[3][1][3]
					addNewKey controllerZ currentTime
					Zkeys = controllerZ.keys
					
					keyindex = getKeyIndex target.pos.controller.Z_Position.controller currentTime
					Zkeys[keyindex].value = position.z
					Zkeys[keyindex].inTangentType = #linear
					Zkeys[keyindex].outTangentType = #linear
				)
				
				--k.value = position
				
				--print target[3][1][1].keys[1].inTangentType
			)
					
			
			
			sliderTime = end
			
			if (classOf source == Biped_Object) then
			(
				position = source[3].value.row4
				
				print "End Pos"
				print source[3].value.row4		
				
				--print source.controller
											
			)
			else
			(
				position = source.pos
			)
			
			if (classOf target == Biped_Object) then
			(
				biped.setTransform target #pos position true
											
			)
			else
			(
				
				--with animate on ( at time currentTime target.pos = position )
				
				--addNewKey target[3][1] currentTime
				--targetcontroller = target[3][1]
				--keyindex = getKeyIndex target.position.controller currentTime
				--targetkeys = targetcontroller.keys
				--targetkeys[keyindex + 1].value = position
				
				if check_x.checked == true do
				(	
					controllerX = target[3][1][1]
					addNewKey controllerX currentTime
					Xkeys = controllerX.keys
					
					keyindex = getKeyIndex target.pos.controller.X_Position.controller currentTime
					Xkeys[keyindex].value = position.x
					Xkeys[keyindex].inTangentType = #linear
					Xkeys[keyindex].outTangentType = #linear
				)
				
				if check_y.checked == true do
				(	
					controllerY = target[3][1][2]
					addNewKey controllerY currentTime
					Ykeys = controllerY.keys
					
					keyindex = getKeyIndex target.pos.controller.Y_Position.controller currentTime
					--print keyindex
					Ykeys[keyindex].value = position.y
					Ykeys[keyindex].inTangentType = #linear
					Ykeys[keyindex].outTangentType = #linear
				)
				if check_z.checked == true do
				(	
					controllerZ = target[3][1][3]
					addNewKey controllerZ currentTime
					Zkeys = controllerZ.keys
					
					keyindex = getKeyIndex target.pos.controller.Z_Position.controller currentTime
					Zkeys[keyindex].value = position.z
					Zkeys[keyindex].inTangentType = #linear
					Zkeys[keyindex].outTangentType = #linear
				)
				
				--k.value = position
				
				--print target[3][1][1].keys[1].inTangentType
			)
			
			
			
		)
		
		if (ddl1.selection == 4) do
		(
			sourcekeys = chooseit.object.pos.controller.keys
			
			for k in sourcekeys do
			(
				sliderTime = k.time
					
				if (classOf chooseit.object == Biped_Object) then
				(
					position = chooseit.object[3].value.row4								
															
				)
				else
				(
					position = chooseit.object.pos
				)
					
				if (classOf target == Biped_Object) then
				(
					biped.setTransform target #pos position true
													
				)
				else
				(
					if check_x.checked == true do
					(
						KEY target[3][1][1] target.pos.controller.X_Position.controller position.x
					)
						
					if check_y.checked == true do
					(
						KEY target[3][1][2] target.pos.controller.Y_Position.controller position.y
					)
						
					if check_z.checked == true do
					(
						KEY target[3][1][3] target.pos.controller.Z_Position.controller position.z
					)
				)
							
							
			)
		)
		
		
				
		
		--Step 2
				
		
		if keep_source.checked == false do
		(
			
			if (classOf source == Biped_Object) then
			(
				
				biped.convertToFootSteps source.controller keyPerFrame:true flattenToZ:false
				
			)
			else
			(
				--key every frame
				--transfer IK to FK
				for i = start to end do
				(
					sliderTime = i
					
					if check_x.checked == true do
					(
						con = source.pos.controller.X_Position.controller
						addNewKey con currentTime
					)
					if check_y.checked == true do
					(
						con = source.pos.controller.Y_Position.controller
						addNewKey con currentTime
					)
					if check_z.checked == true do
					(
						con = source.pos.controller.Z_Position.controller
						addNewKey con currentTime
					)
				)
				
			)
			
			for i = start to end do
			(
				
				sliderTime = i
				
				if (classOf source == Biped_Object) then
				(
					setxyz = source[3].value.row4
				)
				else
				(
					setxyz = source.pos
				)
				--print sliderTime
				--print setxyz
				
				setxyz = setxyz - target.pos
							
				--print i
				--print setxyz
				--print target.pos
				
				if (classOf source == Biped_Object) then
				(
					biped.setTransform source #pos setxyz true
					--print "test"
				)
				else
				(
					--with animate on ( at time currentTime reource.pos = setxyz )
					with animate on
					(
						--at time (currentTime source.pos.controller.x_Position = setxyz.x)
						--at time (currentTime source.pos.controller.y_Position = setxyz.y)
						--at time (currentTime source.pos.controller.z_Position = setxyz.z)
						at time currentTime source.pos = setxyz
					)
				)
				
			)
		)
		
	)
	
		
)







createDialog TransferKeys 160 660