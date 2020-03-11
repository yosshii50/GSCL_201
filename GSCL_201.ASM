;�O���t�B�b�N�X�N���[���v���O���� Ver-2.01
;[GSCL_201] INT41h

cseg	SEGMENT
	ASSUME	CS:cseg,DS:cseg
	ORG	00100h

m_prg:	JMP	s_prg
;========================================================================�풓��
	DB	0," SILIA Graphix Scrool Ver-2.01 "
z_prg:	DB	02Eh,0FFh,02Eh
	DW	OFFSET z_int
z_iv:	PUSHF
	CALL	g_prg
	CALL	i_prg
	POPF
	IRET
i_prg:	PUSH	AX
	PUSH	BX
	PUSH	CX
	PUSH	ES
	MOV	AH,002h
	MOV	CX,00002h
	PUSH	CS
	POP	ES
	MOV	BX,OFFSET z_iv
	INT	01Ch
	POP	ES
	POP	CX
	POP	BX
	POP	AX
	RET
g_prg:	PUSH	AX
	PUSH	DX
	MOV	DX,CS:[g_dat]
	ADD	DX,40
	MOV	CS:[g_dat],DX
	IN	AL,0A0h
	TEST	AL,004h
	JNE	g_j02
	POP	DX
	POP	DX
	RET
g_j02:	IN	AL,0A0h
	TEST	AL,020h
	JE	g_j02
	MOV	AL,070h
	OUT	0A2h,AL
	MOV	AL,DL
	OUT	0A0h,AL
	MOV	AL,DH
	OUT	0A0h,AL
	MOV	AL,0
	OUT	0A0h,AL
	MOV	AL,0
	OUT	0A0h,AL
	POP	DX
	POP	AX
	RET
g_dat	DW	0
z_int	DW	0	;PI
	DW	0	;CS
i_int	DW	0	;PI
	DW	0	;CS
;======================================================================��풓��
s_prg:	MOV	DX,OFFSET s_mes1
	MOV	AH,009h
	INT	021h
	MOV	AL,041h				;Get Interrupt Vector
	MOV	AH,035h				;
	INT	021h				;
	MOV	AL,DS:[080h]			;�I�v�V�����`�F�b�N
	OR	AL,AL
	JNE	s_j02
	MOV	DX,OFFSET s_mes5		;�I�v�V���������G���[
	MOV	AH,009h
	INT	021h
	MOV	DX,OFFSET s_mes7
	MOV	AH,009h
	INT	021h
	MOV	AX,04C01h
	INT	021h
s_j02:	MOV	BX,00081h			;�I�v�V�����m�F
s_l02:	MOV	AL,DS:[BX]
	CMP	AL,00Dh
	JE	s_j03
	OR	AL,020h
	CMP	AL,'s'
	JNZ	s_p1s
	JMP	s_p1
s_p1s:	CMP	AL,'r'
	JNZ	s_p2s
	JMP	s_p2
s_p2s:	INC	BX
	JMP	s_l02
s_j03:	MOV	DX,OFFSET s_mes6		;�I�v�V�����G���[
	MOV	AH,009h
	INT	021h
	MOV	AX,04C01h
	INT	021h
;----------------------------------------------------------------------�풓�J�n
s_p1:	MOV	AL,041h
	CALL	zc_prg
	OR	AX,AX
	JNZ	s_p1j1
	MOV	DX,OFFSET s_mes3		;�Q�d�풓�G���[
	MOV	AH,009h
	INT	021h
	MOV	AX,04C01h
	INT	021h
s_p1j1:	MOV	DX,OFFSET z_prg			;�풓����
	MOV	AL,041h
	CALL	sv_prg
	MOV	CS:[z_int],DX
	MOV	CS:[z_int+2],AX
	
	
	MOV	AX,03507h
	INT	021h
	MOV	AX,ES
	MOV	CS:[i_int],BX
	MOV	CS:[i_int+2],AX
	
	
	MOV	DX,OFFSET s_mes8
	MOV	AH,009h
	INT	021h
	CALL	i_prg
	MOV	CL,004h
	MOV	DX,OFFSET s_prg
	SHR	DX,CL
	INC	DX
	MOV	AX,03100h
	INT	021h
;----------------------------------------------------------------------�풓����
s_p2:	MOV	AL,041h
	CALL	zc_prg
	OR	AX,AX
	JZ	s_p2j1
	MOV	DX,OFFSET s_mes2		;���풓�G���[
	MOV	AH,009h
	INT	021h
	MOV	AX,04C01h
	INT	021h
s_p2j1:	MOV	AL,041h
	MOV	AH,035h
	INT	021h
	MOV	DS:[BX-2],WORD PTR 00000h
	MOV	AX,ES:[z_int+2]
	MOV	DS,AX
	MOV	DX,ES:[z_int]
	MOV	AL,041h
	CALL	sv_prg
	
	
	MOV	AX,ES:[i_int+2]
	MOV	CS:[i_int+2],AX
	MOV	AX,ES:[i_int]
	MOV	ES:[i_int],AX
	
	
	MOV	AH,049h				;Free Allocated Memory
	INT	021h
	MOV	AX,ES:[02Ch]
	MOV	ES,AX
	MOV	AH,049h
	INT	021h
	PUSH	CS
	POP	DS
	MOV	DX,OFFSET s_mes9
	MOV	AH,009h
	INT	021h
s_p2j2:	IN	AL,0A0h
	TEST	AL,004h
	JE	s_p2j2
	MOV	AL,070h
	OUT	0A2h,AL
	MOV	AL,0
	OUT	0A0h,AL
	OUT	0A0h,AL
	OUT	0A0h,AL
	OUT	0A0h,AL
	MOV	AH,002h
	MOV	CX,00001h
	PUSH	CS
	POP	ES
	MOV	BX,OFFSET s_eps
	INT	01Ch
s_p2l1:	MOV	AL,CS:[s_eck]
	CMP	AL,000h
	JE	s_p2l1
	
	
	MOV	AX,CS:[i_int+2]
	MOV	DS,AX
	MOV	DX,ES:[i_int]
	MOV	AX,02507h
	INT	021h
	
	
	MOV	AX,04C00h
	INT	021h
s_eps:	MOV	CS:[s_eck],BYTE PTR 1
	IRET
s_eck	DB	0
;----------------------------------------------------------------------�f�[�^��
s_mes1	DB	01Bh,"[m"
	DB	00Dh,00Ah,"Graphic Scrool Program Ver-2.01 / Program By "
	DB	01Bh,"[36m","SILIA-SOFTWARE",01Bh,"[m"
	DB	" 1994/3/26"
	DB	00Dh,00Ah,'$'
s_mes2	DB	00Dh,00Ah,"�@�풓����Ă��܂���B",00Dh,00Ah,'$'
s_mes3	DB	00Dh,00Ah,"�@���ɏ풓����Ă��܂��B",00Dh,00Ah,'$'
s_mes5	DB	00Dh,00Ah,"�@�I�v�V�������w�肵�ĉ������B",00Dh,00Ah,'$'
s_mes6	DB	00Dh,00Ah,"�@�I�v�V�������F���o���܂���B",00Dh,00Ah
s_mes7	DB	"�@�@/S �풓�J�n",00Dh,00Ah
	DB	"�@�@/R �풓����",00Dh,00Ah,'$'
s_mes8	DB	"Set Interrupt Vector INT41h",00Dh,00Ah,'$'
s_mes9	DB	"Reset Interrupt Vector INT41h",00Dh,00Ah,'$'


;�L�[�v�v���Z�X�A�풓�m�F���[�`��
;
;In  [AL]=�풓�v���Z�X���荞�݃R�[�h
;    [DS]=���s�v���Z�X�`�F�b�N�R�[�h�Z�O�����g
;
;Out [AX]=0 ���ɏ풓����Ă���
;         1 �풓����Ă��Ȃ�
;
;/(in [AL][DS] out [AX])////////////////////////////// KEEPP-CHECK Ver-1.01 //
zc_prg:	PUSH	BX
	PUSH	SI
	PUSH	ES
	MOV	AH,035h				;Get Interrupt Vector
	INT	021h				;
	MOV	SI,BX				;�풓�m�F
zc_l:	DEC	BX
	DEC	SI
	MOV	AL,DS:[SI]
	OR	AL,AL				;(000h)�R�[�h�܂Ń`�F�b�N
	JE	zc_j				;�풓�� Set0
	CMP	ES:[BX],AL
	JE	zc_l
	MOV	AL,001h				;��풓�� Set1
zc_j:	MOV	AH,000h
	POP	ES
	POP	SI
	POP	BX
	RET


;���荞�݃Z�b�g���[�`��
;
;In  [AL]   =�Z�b�g���銄�荞�݃R�[�h
;    [DS:DX]=�Z�b�g���銄�荞�ݏ������[�`��
;
;Out [AX:DX]=�����荞�݃��[�`��
;
;/(in [AL][DS:DX] out [AX:DX])////////////////////// Set Int Vector Ver-1.00 //
sv_prg:	PUSH	ES
	PUSH	BX
	CLI
	PUSH	AX
	MOV	AH,035h				;Get Interrupt Vector
	INT	021h
	POP	AX
	MOV	AH,025h				;Set Interrupt Vector
	INT	021h
	STI
	MOV	AX,ES
	MOV	DX,BX
	POP	BX
	POP	ES
	RET


cseg	ENDS
	END	m_prg
