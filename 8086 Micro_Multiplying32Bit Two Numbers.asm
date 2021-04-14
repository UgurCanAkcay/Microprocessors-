
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt
;FND port address (7-segment Display)
CODE SEGMENT
ASSUME CS:CODE, DS:CODE
ORG 0
start:
  MOV WORD PTR [100h], 0FE98h; 32 bitlikçcarpanin bulundugu alt(9.satir) ve ust (10.satir) 16 biti bu iki satirdir 
  MOV WORD PTR [102h], 0FE98h 
  MOV WORD PTR [104h], 0FE98h; 32 bitlik carpilanin bulundugu alt(12.satir) ve ust(13.satir) 16 biti bu iki satidir
  MOV WORD PTR [106h], 0FE98h 
     
  MOV AX,[100h] ;Carpanin alt(15.satir) ve ust(16.satir) 16 biti bellekteki-cagirma
  MOV BX,[102h] 
  MOV CX,[104h] ;Carpilanin alt(18.satir) ve ust(19.satir) 16 biti bellekteki-cagirma
  MOV DX,[106h]  
     
  MOV WORD PTR [10Eh],0000h ;Carpma isleminin sonucunda 16 biti bellekteki konumlari bu 4 satirdir (108-10E= Bitdegerligine gore)
  MOV WORD PTR [10Ch],0000h
  MOV WORD PTR [10Ah],0000h
  MOV WORD PTR [108h],0000h  
                                                  
  MOV BYTE PTR [110h],20h ;Dongu degiskeni 32 kez donmesi icin

tekrar:

  MOV WORD PTR [111h],AX    ;111h=AX
  AND WORD PTR [111h],0001h ;111h'in LSB biti haricindeki bitlerini sifirla
  XOR WORD PTR [111h],0001h ;Carpan'in en anlamsiz biti lojik 1 mi?  
  JZ topla_kaydir           ;Evet ise Carpim sonucunu Carpilan ile topla ve bir bit saga kaydir
  
  CLC         
     
devam:

  RCR WORD PTR [10Eh],1 ;Carpim sonucunun 16 bitini 1 bit saga kaydirma islemi(37,38,39,40.satirlar)
  RCR WORD PTR [10Ch],1 
  RCR WORD PTR [10Ah],1 
  RCR WORD PTR [108h],1 

  SHR BX,1 ;Carpanin ust 16 bitini bir bit saga kaydir(ROL/ROR/SHR)
  RCR AX,1 ;Carpanin alt 16 bitini bir bit saga kaydir 
     
  DEC BYTE PTR [110h]   ;dongu degiskenini bir azalt         
  CMP BYTE PTR [110h],0 ;dongu degiskeni sifir mi?
  JNZ tekrar            ;Eger sifir degil ise ayni islemleri tekrarla
  JMP son               ;Carpim sonucunu goster


topla_kaydir: 

  ADD WORD PTR [10Ch],CX ;10C=10C+CX Alt
  ADC WORD PTR [10Eh],DX ;10E=10E+DX Ust bitten gelen eldeyi ilave etme
  JMP devam     
            
son:      

  HLT 
  
ret




