

; *********************************************************************************************************************
; **                                                                                                                 **
; **    **                 ******         *********            ***            ************        **                 **
; **     **    **         **    **       **********       *************      **************        **   ***          **
; **      ******         **      **      **               *************      **          **         ******           **
; **      ***            **      **      **********            ***           **************         **               **
; **      **             **      **      **********            ***           **************         **               **
; **      **             **      **              **            ***           **                     **               **
; **      **              **    **       **********            *****          ************          **               **
; **      **               ******        *********              *****          **********           **               **
; **                                                                                                                 **
; *********************************************************************************************************************


assume cs:mycode

mydata segment
	CHOOSE      db  "Please select the following features" ,0dh, 0ah, '$'               ; Please select the following features
	FUN1        db  "1: addition info" ,0dh, 0ah, '$'                                   ; 1: addition info
	FUN2        db  "2: delete info " ,0dh, 0ah, '$'                                    ; 2: delete info
	FUN3        db  "3: modify info" ,0dh, 0ah, '$'                                     ; 3: modify info
	FUN4        db  "4: enquiry info" ,0dh, 0ah, '$'                                    ; 4: enquiry info
	FUN5        db  "5: show info" ,0dh, 0ah, '$'                                       ; 5: show info
	FUN6        db  "6: save info" ,0dh, 0ah, '$'                                       ; 6: save info
	FUN7        db  "7: exit process" ,0dh, 0ah,0dh, 0ah, '$'                           ; 7: exit process
	
	ADDTIPS1    db  "please enter name:" ,0dh, 0ah,'$'                                  ;请输入姓名
	ADDTIPS2    db  "please enter telephone number:" ,0dh, 0ah,'$'                      ;请输入电话
	ADDTIPS3    db  0dh, 0ah, "Information added successfully" ,0dh, 0ah,'$'            ;信息添加成功
	DELTIPS1    db  "Please enter the information you want to delete:" ,0dh, 0ah,'$'    ;请输入要删除的姓名
	DELTIPS2    db  "The name was not found" ,0dh, 0ah,'$'                              ;未找到该姓名
	DELTIPS3    db  0dh, 0ah, "The Information deleted successfully" ,0dh, 0ah,'$'      ;信息成功删除
	MODIFYTIPS1 db  "Please enter the name you want to modify" ,0dh, 0ah,'$'            ;请输入要修改的名字
	MODIFYTIPS2 db  0dh, 0ah, "The information modified successfully" ,0dh, 0ah,'$'     ;信息修改成功
	CHECKTIPS1  db  "Please enter the name you are looking for" ,0dh, 0ah,'$'           ;输入查找的名字
	SAVETIPS1   db  "File saved successfully" ,0dh, 0ah,'$'                             ;保存文件成功
	INPUTERROR  db  "input error" ,0dh, 0ah, 0dh, 0ah,'$'                               ;错误提示
	
	LINE        db  0dh, 0ah,'$'                                                        ;回车换行
	SYMBOL      db  "------------" ,0dh, 0ah, '$'                                       ;-------------
	
	FILENAME   db  "test.bin", 0h                                                       ;文件名
	FILENUM     db   0h, 0h                                                             ;文件代号
	
	PARAMNAME   db  50, 0ffh                                                            ;输入缓冲区-姓名
    BUFFNAME    db  50 dup('$')
	PARAMPHONE  db  50, 0ffh                                                            ;输入缓冲区-电话
    BUFFPHONE   db  50 dup('$')
	
	ROSTER      db  5000 dup('$')                                                       ;缓冲区-保存所有通讯录信息
	TOTAL       db  1 dup(0)                                                            ;全局变量-保存信息个数
	
mydata ends

mystack segment stack
	db 1000 dup(0)
mystack ends


;/*****************************************************************************************************/
mycode segment
	
	;读文件
	READFILE:
		push bp
		mov bp,sp
		
	
		;打开文件
		mov dx,offset FILENAME
		mov al,0
		mov ah,3dh
		int 21h
		
		;将返回的文件号写进内存
		mov bx,offset FILENUM
		mov ds:[bx],ax
		
		;读取5001字节信息		
		mov si,offset FILENUM
		mov bx,ds:[si]
		mov dx,offset ROSTER
		mov cx,5001
		mov ah,3fh
		int 21h
		
		;关闭文件
		mov bx,offset FILENUM
		mov dx,ds:[bx]
		mov bx,dx
		mov ah,3eh
		int 21h
		
		pop bp

		ret

;/*****************************************************************************************************/
	;写文件
	WRITEFILE:
		push bp
		mov bp,sp
		sub sp,10h
		push cx
		push dx
		push bx
		
		;打开文件
		mov dx,offset FILENAME
		mov al,1
		mov ah,3dh
		int 21h
		
		;将返回的文件号写进内存
		mov bx,offset FILENUM
		mov ds:[bx],ax
		
		;获取文件号
		mov bx,ax
		
		;写入5001字节到文件
		mov dx,offset ROSTER
		mov cx,5001
		mov ah,40h
		int 21h
		
		;关闭文件
		mov bx,offset FILENUM
		mov dx,ds:[bx]
		mov bx,dx
		mov ah,3eh
		int 21h
		
		;打印成功提示
		mov ah,09h
		mov dx,offset SAVETIPS1
		int 21h
		
		pop bx
		pop dx
		pop cx
		add sp,10h
		pop bp		
		ret

;/*****************************************************************************************************/	
	;打印提示信息
	SHOW:
		push bp
		mov bp,sp
	
		mov ah,09h
		mov dx,offset LINE
		int 21h
		
		mov ah,09h
		mov dx,offset CHOOSE
		int 21h
		
		mov ah,09h
		mov dx,offset FUN1
		int 21h
		
		mov ah,09h
		mov dx,offset FUN2
		int 21h 
		
		mov ah,09h
		mov dx,offset FUN3
		int 21h 
		
		mov ah,09h
		mov dx,offset FUN4
		int 21h 
		
		mov ah,09h
		mov dx,offset FUN5
		int 21h 
		
		mov ah,09h
		mov dx,offset FUN6
		int 21h 
		
		mov ah,09h
		mov dx,offset FUN7
		int 21h 
		
		pop bp
		ret
		
	
;/*****************************************************************************************************/	
	INPUT:
		push bp
		mov bp,sp
		sub sp,10h
		
		mov ah, 01h
        int 21h
		
		;将 al 先保存
		mov ss:[bp - 2], ax
		
		;输入换行
		mov dl, 0dh
        mov ah, 02h
        int 21h
		mov dl, 0ah
        mov ah, 02h
        int 21h
		
		;取出al
		mov ax,ss:[bp - 2]
		
		add sp,10h
		pop bp
		
		ret
		
;/*****************************************************************************************************/
	MODIFYNAMEPHONE:;有一个参数传进来
		push bp
		mov bp,sp
		sub sp,10h
		
		
		;在缓冲区输入新的信息
		call SETBUFF
		
		mov ax,ss:[bp + 4]
		;将缓冲区的信息写入ax行
		push ax
		call WRITE
		
		add sp,10h
		pop bp
		retn 2
	
;/*****************************************************************************************************/
	ADDITION:;添加信息
		push bp
		mov bp,sp
		sub sp,10h
		
		;输入数据
		call SETBUFF
		
		;将缓冲区数据写入数据区
		mov bx,offset TOTAL		
		mov ah,0
		mov al,ds:[bx]
		
		;传参
		push ax
		call WRITE
		
		;打印添加成功的提示
		mov ah,09h
		mov dx,offset ADDTIPS3
		int 21h
		
		;将TOTAL个数加一
		mov bx,offset TOTAL	
		mov al,ds:[bx]
		inc al
		mov ds:[bx],al
		
		add sp,10h
		pop bp
		ret
		
		
;/*****************************************************************************************************/
	DEL:;删除信息
		;打印提示
		push bp
		mov bp,sp
		sub sp,10h
		
		mov ah,09h
		mov dx,offset DELTIPS1
		int 21h
		
		;输入姓名
		mov ah, 0ah
        mov dx, offset PARAMNAME
        int 21h
		
		;输出姓名
		mov bx, offset PARAMNAME
        mov al, [bx+1]
        mov ah, 0
        mov si, ax
        mov bx, offset BUFFNAME
        mov byte ptr [bx+si], 24h
		mov ah,09h
		mov dx,offset BUFFNAME
		int 21h
		
		;打印换行
		mov ah,09h
		mov dx,offset LINE
		int 21h
		
		call FIND
		cmp ax,101
		jne DELINFO
		;没找到要删的信息
		;打印错误提示
		mov ah,09h
		mov dx,offset DELTIPS2
		int 21h
		
		add sp,10h
		pop bp
		ret
		
		DELINFO:;开始删除信息
		push ax
		call MOVE
		
		;打印删除成功的提示
		mov ah,09h
		mov dx,offset DELTIPS3
		int 21h
		
		;将信息个数减1
		mov bx,offset TOTAL
		mov al,ds:[bx]
		sub al,1
		mov ds:[bx],al
		
		add sp,10h
		pop bp
		ret

;/*****************************************************************************************************/
	MODIFY:
		push bp
		mov bp,sp
		sub sp,10h		
		
		;打印提示
		mov ah,09h
		mov dx,offset MODIFYTIPS1
		int 21h
		
		;输入姓名
		mov ah, 0ah
        mov dx, offset PARAMNAME
        int 21h
		
		;输出姓名
		mov bx, offset PARAMNAME
        mov al, [bx+1]
        mov ah, 0
        mov si, ax
        mov bx, offset BUFFNAME
        mov byte ptr [bx+si], 24h
		mov ah,09h
		mov dx,offset BUFFNAME
		int 21h
		
		;打印换行
		mov ah,09h
		mov dx,offset LINE
		int 21h
		
		call FIND
		cmp ax,101
		jne MODIFYINFO
		;没找到要修改的信息
		;打印错误提示
		mov ah,09h
		mov dx,offset DELTIPS2
		int 21h
		
		add sp,10h
		pop bp
		ret
		
		
		MODIFYINFO:;开始修改信息
		push ax
		call MODIFYNAMEPHONE
		
		;打印修改成功的提示
		mov ah,09h
		mov dx,offset MODIFYTIPS2
		int 21h
		
		add sp,10h
		pop bp
		ret
		
;/*****************************************************************************************************/
	CHECK:
		push bp
		mov bp,sp
		sub sp,10h
		
		;打印提示
		mov ah,09h
		mov dx,offset CHECKTIPS1
		int 21h
		
		;输入姓名
		mov ah, 0ah
        mov dx, offset PARAMNAME
        int 21h
		
		;输出姓名
		mov bx, offset PARAMNAME
        mov al, [bx+1]
        mov ah, 0
        mov si, ax
        mov bx, offset BUFFNAME
        mov byte ptr [bx+si], 24h
		mov ah,09h
		mov dx,offset BUFFNAME
		int 21h
		
		;打印换行
		mov ah,09h
		mov dx,offset LINE
		int 21h
		
		call FIND
		cmp ax,101
		jne CHECKINFO
		;没找到要删的信息
		;打印错误提示
		mov ah,09h
		mov dx,offset DELTIPS2
		int 21h
		
		add sp,10h
		pop bp
		ret
		
		
		CHECKINFO:;开始删除信息	
		;打印出查到的信息
		push ax
		call PRINTINFO
		
		add sp,10h
		pop bp
		ret

		
;/*****************************************************************************************************/
	FIND:;查找与缓冲区的姓名相匹配的信息的 位置，并在ax中返回，101表示没找到
		push bp
		mov bp,sp
		sub sp,10h
	
		mov bx,offset TOTAL
		mov dh,ds:[bx];将信息个数放在dh中
		
		mov bx,offset PARAMNAME
		mov dl,ds:[bx + 1];将缓冲区字符串长度放在dl中
		
		mov bx,offset BUFFNAME
		mov di,bx
		
		mov ch,0
		mov cl,dh
		mov ax,0
		FINDINFONUM:
			mov ss:[bp - 2],cx
			
			mov bx,offset ROSTER
			mov ss:[bp - 4],ax
			mov si,bx
			mov ah,100
			mul ah
			add si,ax;si保存数据区的地址
			mov ax,ss:[bp - 4]
			
			mov cl,dl
			inc cl
			mov bx,0
			FINDBUFFSIZE:
				cmp cx,1
				je FINDBUFFSIZEEND;当检查到最后一个字符，则跳到此处
				;检查字符是否匹配
				mov ss:[bp - 4],ax
				mov al,ds:[bx + si]
				mov ah,ds:[bx + di]
				cmp al,ah
				mov ax,ss:[bp - 4]
				jne FINDINFONUMEND;不相等则跳出
				inc bx
				
				loop FINDBUFFSIZE
				
				FINDBUFFSIZEEND:;此处检查最后一个字符是不是$
				mov ss:[bp - 4],ax
				mov al,ds:[bx + si]
				cmp al,24h
				mov ax,ss:[bp - 4]
				jne FINDINFONUMEND;最后一个字符不是$
				mov cx,ss:[bp - 2]
				
				add sp,10h
				pop bp
				ret;如果相等则是匹配，可以返回
				
		
			FINDINFONUMEND:;有不匹配的字符则跳到此处
			mov cx,ss:[bp - 2]
			inc ax
			loop FINDINFONUM
		
		mov ax,101
		
		add sp,10h
		pop bp
		ret
	
	
;/*****************************************************************************************************/
	MOVE:;从AX中的行数开始，将每一行向上移动一格，最后一行全部写$
		push bp
		mov bp,sp
		sub sp,10h
		
		push ax
		mov bx,offset TOTAL
		mov ah,ds:[bx]
		
		mov cl,ah
		mov ch,al
		sub cl,ch
		mov al,cl
		mov ah,100
		mul ah;计算需要移动多少个字节
		mov cx,ax
		
		pop ax
		mov ah,100
		mul ah;计算移动开始点的偏移
		mov bx,offset ROSTER
		mov di,bx
		add di,ax;移动的起点
		mov bx,0
		MOVELOOP:
			mov al,ds:[bx + di + 100]
			mov ds:[bx + di],al
			inc bx
			
			loop MOVELOOP
		
		add sp,10h
		pop bp
		retn 2
	
;/**********************************************************************/	
	
	WRITE:;将缓冲区中的信息，写入数据区AX行
		push bp
		mov bp,sp
		
		mov ax,ss:[bp + 4]
		
		;读出姓名长度,放在cx中
		mov bx,offset PARAMNAME
		mov ch,0
		mov cl,ds:[bx + 1]
		
		;计算出姓名的起始地址
		mov si, offset BUFFNAME
		mov bx, offset ROSTER
		mov di, bx
		mov dl, 100
		mul dl
		add di, ax
		
		;开始循环拷贝
		COPYNAME:
			mov dl, ds:[si]
			mov ds:[di], dl
			
			inc si
			inc di
			
			loop COPYNAME
			
			;在末尾写上$
			mov dl, 24h
			mov ds:[di], dl
			
		;读出电话长度,放在cx中
		mov bx,offset PARAMPHONE
		mov ch,0
		mov cl,ds:[bx + 1]
		
		;计算出电话的起始地址
		mov si, offset BUFFPHONE
		mov bx, offset ROSTER
		mov di, bx
		add di, ax
		add di, 50
		
		;开始循环拷贝
		COPYPHONE:
			mov dl, ds:[si]
			mov ds:[di], dl
			
			inc si
			inc di
			
			loop COPYPHONE
			
			;在末尾写上$
			mov dl, 24h
			mov ds:[di], dl
		
		pop bp
		retn 2
;/*****************************************************************************************************/	
	PRINTALL:;打印所有信息
		push bp
		mov bp,sp
		sub sp,10h
		
		mov ch,0
		mov bx,offset TOTAL
		mov cl,ds:[bx]
		cmp cx,0;cx等于0，则结束
		je  ENDPRINTALL
		
		mov ax,0
		PRINTEVERYLINE:
			push ax
			call PRINTINFO
			inc ax
			
			loop PRINTEVERYLINE
		ENDPRINTALL:
		
		add sp,10h
		pop bp
		ret
	
;/*****************************************************************************************************/		
	PRINTINFO:;打印信息区第AL行的信息
		push bp
		mov bp,sp
		sub sp,10h
		push ax
		
		mov bl,al
		;打印--------
		mov ah,09h
		mov dx,offset SYMBOL
		int 21h
		
		;打印姓名
		mov dx,offset ROSTER
		mov al,bl
		mov bh,100;每行100字节
		mul bh
		add dx,ax
		mov ah,09h
		int 21h
		
		;打印换行
		mov ah,09h
		mov dx,offset LINE
		int 21h
		
		;打印电话
		mov dx,offset ROSTER
		mov al,bl
		mov bh,100;每行100字节
		mul bh
		add dx,ax
		add dx,50
		mov ah,09h
		int 21h
		
		;打印换行
		mov ah,09h
		mov dx,offset LINE
		int 21h
		
		;打印--------
		mov ah,09h
		mov dx,offset SYMBOL
		int 21h
		
		;打印换行
		mov ah,09h
		mov dx,offset LINE
		int 21h
		
		pop ax
		add sp,10h
		pop bp
		retn 2
	
	
;/*****************************************************************************************************/
	SETBUFF:;在缓冲区写入数据
		push bp
		mov bp,sp
		
		;打印提示
		mov ah,09h
		mov dx,offset ADDTIPS1
		int 21h
		
		SETBUFF_NAME:
		;输入姓名
		mov ah, 0ah
        mov dx, offset PARAMNAME
        int 21h
		
		;检查是否是空输入
		mov bx, offset PARAMNAME
        mov al, [bx+1]
		cmp al,0
		je SETBUFF_NAME
		
		;输出姓名
		mov bx, offset PARAMNAME
        mov al, [bx+1]
        mov ah, 0
        mov si, ax
        mov bx, offset BUFFNAME
        mov byte ptr [bx+si], 24h
		mov ah,09h
		mov dx,offset BUFFNAME
		int 21h
		
		;输出换行
		mov ah,09h
		mov dx,offset LINE
		int 21h
		
		;打印提示
		mov ah,09h
		mov dx,offset ADDTIPS2
		int 21h
		
		SETBUFF_PHONE:
		;输入电话
		mov ah, 0ah
        mov dx, offset PARAMPHONE
        int 21h
		
		;检查是否是空输入
		mov bx, offset PARAMPHONE
        mov al, [bx+1]
		cmp al,0
		je SETBUFF_PHONE
		
		;输出电话
		mov bx, offset PARAMPHONE
        mov al, [bx+1]
        mov ah, 0
        mov si, ax
        mov bx, offset BUFFPHONE
        mov byte ptr [bx+si], 24h
		mov ah,09h
		mov dx,offset BUFFPHONE
		int 21h
		
		;输出换行
		mov ah,09h
		mov dx,offset LINE
		int 21h
		
		pop bp
		ret
	
;/*****************************************************************************************************/
	start:
		mov ax,mydata
		mov ds,ax
		mov bx,0
		
		mov ax,mystack
		mov ss,ax
		mov sp,1000
		
	READINFO:;先读取文件中的信息到缓冲区
		call READFILE
		
	MAINPROCESS:;主程序开始
	
		call SHOW;提示信息
		call INPUT;输入指令
		
	FUNADD:;添加信息
		;对输入指令进行判断
		cmp al,31h
		jne FUNDEL
		call ADDITION
		jmp AGAINT
		
	FUNDEL:;删除信息
		cmp al,32h
		jne FUNMODIFY
		call DEL
		jmp AGAINT
		
	FUNMODIFY:;修改信息
		cmp al,33h
		jne FUNCHECK
		call MODIFY
		jmp AGAINT

	FUNCHECK:;查找信息
		cmp al,34h
		jne SHOWALL
		call CHECK
		jmp AGAINT
		
	SHOWALL:;显示所有信息
		cmp al,35h
		jne SAVEFILE
		call PRINTALL
		jmp AGAINT
		
	SAVEFILE:;保存文件
		cmp al,36h
		jne FUNEXIT
		call WRITEFILE
		jmp AGAINT
		
	FUNEXIT:;退出程序
		cmp al,37h
		je EXITPROCESS
		
		;打印错误提示
		mov ah,09h
		mov dx,offset INPUTERROR
		int 21h 
		
	AGAINT:;再次循环
		mov cx,1
		jmp MAINPROCESS
		
	EXITPROCESS:	
		mov ax,4c00h
		int 21h


mycode ends
end start




