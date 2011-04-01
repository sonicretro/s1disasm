; ---------------------------------------------------------------------------
; Scrap Brain Zone palette cycling script
; ---------------------------------------------------------------------------

mSBZp:	macro
	dc.b \1, \2
	dc.w \3, \4
	endm

; duration in frames, number of colours, palette address, RAM address

Pal_SBZCycList1:
	dc.w ((end_SBZCycList1-Pal_SBZCycList1-2)/6)-1
	mSBZp	7,8,Pal_SBZCyc1,$FB50
	mSBZp	$D,8,Pal_SBZCyc2,$FB52
	mSBZp	$E,8,Pal_SBZCyc3,$FB6E
	mSBZp	$B,8,Pal_SBZCyc5,$FB70
	mSBZp	7,8,Pal_SBZCyc6,$FB72
	mSBZp	$1C,$10,Pal_SBZCyc7,$FB7E
	mSBZp	3,3,Pal_SBZCyc8,$FB78
	mSBZp	3,3,Pal_SBZCyc8+2,$FB7A
	mSBZp	3,3,Pal_SBZCyc8+4,$FB7C
end_SBZCycList1:
	even

Pal_SBZCycList2:
	dc.w ((end_SBZCycList2-Pal_SBZCycList2-2)/6)-1
	mSBZp	7,8,Pal_SBZCyc1,$FB50
	mSBZp	$D,8,Pal_SBZCyc2,$FB52
	mSBZp	9,8,Pal_SBZCyc9,$FB70
	mSBZp	7,8,Pal_SBZCyc6,$FB72
	mSBZp	3,3,Pal_SBZCyc8,$FB78
	mSBZp	3,3,Pal_SBZCyc8+2,$FB7A
	mSBZp	3,3,Pal_SBZCyc8+4,$FB7C
end_SBZCycList2:
	even