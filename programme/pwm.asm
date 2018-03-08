	LC R0 #0
	LC R1 #1
	LC R28 #1
Loop:	ADDU R28 R1 R28
	LC R2 #255
Sleep:	BEQ R2 R0 Loop
	SUBU R2 R1 R2
	LC R3 #1
Inner:	BEQ R3 R0 End
	SUBU R3 R1 R3
	JMP Inner
End:	JMP Sleep



