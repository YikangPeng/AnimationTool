--有负数帧会无法转换IK动画
rollout ExportAnimationData "Untitled" width:162 height:300
(
	spinner 'spinner_starttime' "" pos:[33,77] width:95 height:16 range:[0,1000,0] type:#integer scale:1 align:#left
	label 'lbl1' "StartTime" pos:[19,61] width:78 height:15 align:#left
	label 'lbl2' "EndTime" pos:[21,98] width:75 height:16 align:#left
	spinner 'spinner_endtime' "" pos:[33,115] width:96 height:16 range:[0,1000,0] type:#integer scale:1 align:#left
	checkbox 'check_x' "Remove_X" pos:[24,163] width:85 height:27 checked:true align:#left
	checkbox 'check_y' "Remove_Y" pos:[24,183] width:85 height:27 checked:true align:#left
	checkbox 'check_z' "Remove_Z" pos:[24,203] width:85 height:27 checked:false align:#left
	checkbox 'clear_x' "SetX_To_0" pos:[114,163] width:105 height:27 checked:false align:#left
	checkbox 'clear_y' "SetY_To_0" pos:[114,183] width:105 height:27 checked:false align:#left
	checkbox 'clear_z' "SetZ_To_0" pos:[114,203] width:105 height:27 checked:false align:#left
	button 'btn1' "Generate" pos:[27,230] width:101 height:50 align:#left
	label 'lbl3' "Select Root Joint First" pos:[25,10] width:108 height:24 align:#left
	editText 'pathtext' "SavePath" pos:[16,34] width:180 height:20 align:#left
	on ExportAnimationData open do
	(
		spinner_starttime.value = animationrange.start
		spinner_endtime.value = animationrange.end
		
		pathtext.text = maxFilePath
	)

	on btn1 pressed  do
	(
		filename = maxFileName
		filepath = maxFilePath
		--FbxSavePath = maxFilePath + maxFileName + "root.fbx"
		--Txt = maxFilePath + maxFileName + "root.txt"
		FbxSavePath = pathtext.text + maxFileName + "root.fbx"
		Txt = pathtext.text + maxFileName + "root.txt"
		outputFile = createFile Txt
		sliderTime = 0f
		obj = selection as array
		oriposition = [0,0,0]

		start = spinner_starttime.value
		end = spinner_endtime.value

		for o in obj do
		(
	
			sliderTime = start
	
			for i = start to end do
			(
	 			
				--if i == start
				--do oriposition = o.pos

				firstname = o[3][1].name
				
				
				--遍历bip骨骼并setFreeKey
				--if (firstname == "Vertical" or firstname == "垂直") do
				--(
					
					--bipObj = o[3].controller
				
					--nn = biped.maxNumNodes bipObj
					--nl = biped.maxNumLinks bipObj
					--for i = 1 to nn do
					--(
					--	anode = biped.getNode bipObj i
					--	if anode != undefined do
					--	(
							--format "% :\t%\n" i anode.name
					--		biped.setFreeKey anode
					--		for j = 1 to nl do
					--		(
					--			alink = biped.getNode bipObj i link:j
					--			if alink != undefined do
					--			(
									--format "% : % \t%\n" i j alink.name
					--				biped.setFreeKey alink
					--			)
					--		)
					--	)
					--)
				--)
				
				
			
				if (firstname == "Vertical" or firstname == "垂直") then
				(
					xyz = o[3].value
					
					if (i < end) then
					(
						sliderTime += 1
					
						nextpos = o[3].value.row4
					
						sliderTime -= 1
					)
					else
					(
						nextpos = o[3].value.row4
					)
					
					movedistance = nextpos - xyz.row4
					
					if check_x.checked == false do
					(	
						
						movedistance.x = 0
					)
					
					if check_y.checked == false do
					(	
						
						movedistance.y = 0
					)
					
					if check_z.checked == false do
					(	
						
						movedistance.z = 0
					)
					
					--(biped.getKey o.controller.horizontal.controller currentTime).x
					
					format "%,%,%,%,%,%,%,%\n" currentTime o.name xyz.row4.x xyz.row4.y xyz.row4.z movedistance.x movedistance.y movedistance.z  to:outputFile
				)
				else
				(
					
					if (i < end) then
					(
						sliderTime += 1
					
						nextpos = o.pos
					
						sliderTime -= 1
					)
					else
					(
						nextpos = o.pos
					)
					
					movedistance = nextpos - o.pos
					
					if check_x.checked == false do
					(	
						
						movedistance.x = 0
					)
					
					if check_y.checked == false do
					(	
						
						movedistance.y = 0
					)
					
					if check_z.checked == false do
					(	
						
						movedistance.z = 0
					)
					
					
					
					
					format "%,%,%,%,%,%,%,%\n" currentTime o.name o.pos.x o.pos.y o.pos.z movedistance.x movedistance.y movedistance.z to:outputFile
				)	
				sliderTime += 1
			)
	
	
			sliderTime = start
			
			firstname = o[3][1].name
			
			orixyz = o[3].value.row4
			
			
			
		
			
  	   
			if check_x.checked == true do
			(
				if (firstname == "Vertical" or firstname == "垂直") then
				(
					
					
					
					deletesubanim = o[3][2]
					deletecontorller = deletesubanim.controller
					deletesubanimkeys = deletesubanim.controller.keys
									
					
					--deleteKeys deletesubanimkeys #allKeys
					
				)
				else
				(
					deleteKeys o.pos.x_position.controller #allKeys
					
				)
			)
			
			if check_y.checked == true do
			(
				if (firstname == "Vertical" or firstname == "垂直") then
				(
					
					
					
					deletesubanim = o[3][2]
					deletecontorller = deletesubanim.controller
					deletesubanimkeys = deletesubanim.controller.keys
					
					--deleteKeys deletesubanimkeys #allKeys
					
				)
				else
				(
					
					deleteKeys o.pos.y_position.controller #allKeys
				)
			)
			
			
			
			
			
			
			if (firstname == "Vertical" or firstname == "垂直") do
			(
				biped.convertToFootSteps o.controller keyPerFrame:true flattenToZ:false
				
				if (check_x.checked == true or check_y.checked == true or check_z.checked == true) do
				(
					for i = start to end do
					(
						setxyz = o[3].value.row4
					
						if check_x.checked == true do
						(	
							setxyz.x = orixyz.x
							if clear_x.checked == true do
								setxyz.x = 0
						)
						if check_y.checked == true do
						(
							setxyz.y = orixyz.y
							if clear_y.checked == true do
								setxyz.y = 0
						)
						
						if check_z.checked == true do
						(
							setxyz.z = orixyz.z
							if clear_z.checked == true do
								setxyz.z = 0
						)
				
				
						biped.setTransform o #pos setxyz true
						
						sliderTime += 1
					)
				)
				
			)
			
			sliderTime = start	
	
	
		)

		exportFile FbxSavePath #noPrompt selectedOnly:false using:FBXEXP

		close outputFile	
	


	)
)



createDialog ExportAnimationData 220 300