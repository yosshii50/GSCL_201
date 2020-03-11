;グラフィックスクロールプログラム Ver-2.01
;[GSCL_201] INT41h

cseg	SEGMENT
	ASSUME	CS:cseg,DS:cseg
	ORG	00100h

m_prg:	JMP	s_prg
;========================================================================常駐部
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
;======================================================================非常駐部
s_prg:	MOV	DX,OFFSET s_mes1
	MOV	AH,009h
	INT	021h
	MOV	AL,041h				;Get Interrupt Vector
	MOV	AH,035h				;
	INT	021h				;
	MOV	AL,DS:[080h]			;オプションチェック
	OR	AL,AL
	JNE	s_j02
	MOV	DX,OFFSET s_mes5		;オプション無しエラー
	MOV	AH,009h
	INT	021h
	MOV	DX,OFFSET s_mes7
	MOV	AH,009h
	INT	021h
	MOV	AX,04C01h
	INT	021h
s_j02:	MOV	BX,00081h			;オプション確認
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
s_j03:	MOV	DX,OFFSET s_mes6		;オプションエラー
	MOV	AH,009h
	INT	021h
	MOV	AX,04C01h
	INT	021h
;----------------------------------------------------------------------常駐開始
s_p1:	MOV	AL,041h
	CALL	zc_prg
	OR	AX,AX
	JNZ	s_p1j1
	MOV	DX,OFFSET s_mes3		;２重常駐エラー
	MOV	AH,009h
	INT	021h
	MOV	AX,04C01h
	INT	021h
s_p1j1:	MOV	DX,OFFSET z_prg			;常駐処理
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
;----------------------------------------------------------------------常駐解除
s_p2:	MOV	AL,041h
	CALL	zc_prg
	OR	AX,AX
	JZ	s_p2j1
	MOV	DX,OFFSET s_mes2		;未常駐エラー
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
;----------------------------------------------------------------------データ部
s_mes1	DB	01Bh,"[m"
	DB	00Dh,00Ah,"Graphic Scrool Program Ver-2.01 / Program By "
	DB	01Bh,"[36m","SILIA-SOFTWARE",01Bh,"[m"
	DB	" 1994/3/26"
	DB	00Dh,00Ah,'$'
s_mes2	DB	00Dh,00Ah,"　常駐されていません。",00Dh,00Ah,'$'
s_mes3	DB	00Dh,00Ah,"　既に常駐されています。",00Dh,00Ah,'$'
s_mes5	DB	00Dh,00Ah,"　オプションを指定して下さい。",00Dh,00Ah,'$'
s_mes6	DB	00Dh,00Ah,"　オプションが認識出来ません。",00Dh,00Ah
s_mes7	DB	"　　/S 常駐開始",00Dh,00Ah
	DB	"　　/R 常駐解除",00Dh,00Ah,'$'
s_mes8	DB	"Set Interrupt Vector INT41h",00Dh,00Ah,'$'
s_mes9	DB	"Reset Interrupt Vector INT41h",00Dh,00Ah,'$'


;キーププロセス、常駐確認ルーチン
;
;In  [AL]=常駐プロセス割り込みコード
;    [DS]=実行プロセスチェックコードセグメント
;
;Out [AX]=0 既に常駐されている
;         1 常駐されていない
;
;/(in [AL][DS] out [AX])////////////////////////////// KEEPP-CHECK Ver-1.01 //
zc_prg:	PUSH	BX
	PUSH	SI
	PUSH	ES
	MOV	AH,035h				;Get Interrupt Vector
	INT	021h				;
	MOV	SI,BX				;常駐確認
zc_l:	DEC	BX
	DEC	SI
	MOV	AL,DS:[SI]
	OR	AL,AL				;(000h)コードまでチェック
	JE	zc_j				;常駐時 Set0
	CMP	ES:[BX],AL
	JE	zc_l
	MOV	AL,001h				;非常駐時 Set1
zc_j:	MOV	AH,000h
	POP	ES
	POP	SI
	POP	BX
	RET


;割り込みセットルーチン
;
;In  [AL]   =セットする割り込みコード
;    [DS:DX]=セットする割り込み処理ルーチン
;
;Out [AX:DX]=元割り込みルーチン
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