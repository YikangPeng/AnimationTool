fn KEY con axiscon keyvalue =
(
	
	addNewKey con currentTime
	conkeys = con.keys
					
	keyindex = getKeyIndex axiscon currentTime
	conkeys[keyindex].value = keyvalue
	conkeys[keyindex].inTangentType = #linear
	conkeys[keyindex].outTangentType = #linear
	
)

rollout AlignRotation "AlignRotation" width:162 height:300
(
	
	dropDownList 'ddl1' "Keys Type" pos:[21,4] width:112 height:41 items:#("Every Frame", "Keys Frame","Time Silder","Agent Keys Frame") selection:1 align:#left
	
	spinner 'pos_starttime' "" pos:[33,377] width:95 height:16 range:[0,1000,0] type:#integer scale:1 align:#left
	label 'lbl1' "PositionStartTime" pos:[19,361] width:78 height:15 align:#left
	label 'lbl2' "PositionEndTime" pos:[21,398] width:75 height:16 align:#left
	spinner 'pos_endtime' "" pos:[33,415] width:96 height:16 range:[0,1000,0] type:#integer scale:1 align:#left			
	button 'btn1' "对齐位移" pos:[27,460] width:101 height:50 align:#left
	
	pickbutton 'chooseit' "用于传递位移的物体" pos:[24,220] width:110 height:30
	--pickbutton 'chooseit2' "代表旋转的物体" pos:[24,260] width:110 height:30
	
	
	spinner 'rot_starttime' "" pos:[33,77] width:95 height:16 range:[0,1000,0] type:#integer scale:1 align:#left
	label 'lbl3' "RotationStartTime" pos:[19,61] width:78 height:15 align:#left
	label 'lbl4' "RotationEndTime" pos:[21,98] width:75 height:16 align:#left
	spinner 'rot_endtime' "" pos:[33,115] width:96 height:16 range:[0,1000,0] type:#integer scale:1 align:#left	
	button 'btn2' "对齐旋转" pos:[27,160] width:101 height:50 align:#left
	
	on AlignRotation open do
	(
		pos_starttime.value = animationrange.start
		pos_endtime.value = animationrange.end
		
		rot_starttime.value = animationrange.start
		rot_endtime.value = animationrange.end
				
	)
	
	on chooseit picked obj do
	(
		chooseit.text = obj.name
		chooseit.object = obj
	)
	
	on chooseit2 picked obj do
	(
		chooseit2.text = obj.name
		chooseit2.object = obj
	)
	
	on btn1 pressed  do
	(
		start = pos_starttime.value
		end = pos_endtime.value
		
		source = $'Bip001'
		target = $'Root'
		
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
				
				KEY target[3][1][1] target.pos.controller.X_Position.controller position.x		
				
				KEY target[3][1][2] target.pos.controller.Y_Position.controller position.y		
				
			)
					
					
		)

		if (classOf source == Biped_Object) then
		(
			
			biped.convertToFootSteps source.controller keyPerFrame:true flattenToZ:false
			
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
	
	
	on btn2 pressed do
	(
		
		bip001Node =  $'Bip001'
		Root =  $'Root'
		
		starttime = rot_starttime.value
		endtime = rot_endtime.value
		
		biped.convertToFootSteps bip001Node.controller keyPerFrame:true flattenToZ:false
		
		deleteKeys chooseit.object.rotation.controller #allKeys		
		
		if (ddl1.selection == 1) do
		(
			
			sliderTime = starttime
			key = addNewKey chooseit.object.rotation.controller.z_rotation.controller currentTime			
			key.value = 0
			key.inTangentType = #linear
			key.outTangentType = #linear
			
			RootRot = 0
			LastRot = 0
			
			for i = (animationrange.start + 1) to animationrange.end do
			(
				
				sliderTime = i - 1
				StartEuler = quatToEuler bip001Node.transform.rotation
				
				sliderTime = i
				EndEuler = quatToEuler bip001Node.transform.rotation
				
				SubAngle = EndEuler.z - StartEuler.z
				
				if (SubAngle > 180) then
				(
					SubAngle = SubAngle - 360
				)

				SubAngle = -SubAngle
				
				rotmat = rotateZMatrix SubAngle
				
				format "当前Bip001节点的Transform为 %\n" SubAngle
				
				test = bip001Node.transform * rotmat					
				
				biped.setTransform bip001Node #rotation test.rotation true
				biped.setTransform bip001Node #pos test.position true				
				
				
				RootRot = SubAngle - LastRot
				
				LastRot = SubAngle
				
				sliderTime = i
				key = addNewKey chooseit.object.rotation.controller.z_rotation.controller currentTime				
				key.value = -SubAngle
				key.inTangentType = #linear
				key.outTangentType = #linear
				
			)
			
			
			deleteKeys Root.rotation.controller #allKeys	
			Root[3][2][3].controller = copy chooseit.object[3][2][3].controller
			--format "controller %\n" chooseit.object[3][2].controller
			--format "controller %\n" chooseit.object[3][3].controller
			--format "controller %\n" chooseit.object[3][2][2].controller
				
			
		)
		
		if (ddl1.selection == 3) do
		(
		
			sliderTime = starttime

			StartEuler = quatToEuler bip001Node.transform.rotation

			InitialTransform = bip001Node.transform

			sliderTime = endtime

			EndEuler = quatToEuler bip001Node.transform.rotation

			SubAngle = EndEuler.z - StartEuler.z
			--format "Bip001节点的Test为 %\n" EndEuler.z
			--format "Bip001节点的Test为 %\n" StartEuler.z

			if (SubAngle > 180) then
			(
				SubAngle = SubAngle - 360
			)

			SubAngle = -SubAngle

			Alltime = endtime - starttime
			Step = SubAngle / Alltime
			

			for i = animationrange.start to animationrange.end do
			(
							
				
				
				sliderTime = i
				
				currentstep =  i
				if (currentstep<starttime) then
				(
					currentstep = starttime
				)
				
				if (currentstep>endtime) then
				(
					currentstep = endtime
				)
			
				rotmat = rotateZMatrix (Step*(currentstep - starttime))
				--currentRot = bip001Node.transform.rotation
				--format "当前Bip001节点的Transform为 %\n" (quatToEuler currentRot)
				--target = currentRot * rotmat
				--format "Bip001节点的Transform为 %\n" (quatToEuler target)
				test = bip001Node.transform * rotmat
				--format "Bip001节点的Test为 %\n" (quatToEuler test.rotation)
				--format "Bip001节点的Transform为 %\n" (quatToEuler InitialRot)
					
				
				biped.setTransform bip001Node #rotation test.rotation true
				biped.setTransform bip001Node #pos test.position true
				
			)

			deleteKeys Root.rotation.controller #allKeys

			sliderTime = starttime
			key = addNewKey Root.rotation.controller.z_rotation.controller currentTime
			key.value = 0
			key.inTangentType = #linear
			key.outTangentType = #linear

			sliderTime = endtime
			key = addNewKey Root.rotation.controller.z_rotation.controller currentTime
			key.value = -SubAngle
			key.inTangentType = #linear
			key.outTangentType = #linear
		)
		
		

		
	)
	
)

createDialog AlignRotation 160 660

format "************对齐旋转测试*********** \n"


--转移旋转到Root


