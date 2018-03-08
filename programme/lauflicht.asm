Init:	LC R0 #0
	LC R1 #1
	LC R31 #1
Loop:	LC R2 #255
	JMP Sleep
Shift:	SLL R31 R1 R31
	BEQ R31 R0 Init
	JMP Loop
Sleep:	BEQ R2 R0 Shift
	SUBU R2 R1 R2
	LC R3 #32
Inner:	BEQ R3 R0 End
	SUBU R3 R1 R3
	JMP Inner
End:	JMP Sleep


