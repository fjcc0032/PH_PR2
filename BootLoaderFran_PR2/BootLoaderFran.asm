BITS_DE_RELLENO_FLOPPY equ 510		            ; Define el tamaño de relleno para un sector de disco (510 bytes)
FIRMA_BOOTLOADER equ 0xAA55		            ; Define la firma del bootloader (0xAA55) que se espera al final del sector

POS_CARGA_BIOS_SO equ 7C00h		            ; Define la posición de carga del BIOS en la memoria (0x7C00)

BIOS_VIDEO equ 10h			            ; Interrupción del BIOS para funciones de video
	BIOS_VIDEO_MODO equ 03h                     ; Modo de video 03h (80x25 texto en color)
	BIOS_VIDEO_POS_CURSOR equ 02h               ; Función para mover el cursor

BIOS_TECLADO equ 16h                                ; Interrupción del BIOS para funciones de teclado

teclado:                                            ; Etiqueta para el inicio del manejo del teclado
	CALL limpiarPantalla                        ; Llama a la rutina para limpiar la pantalla
        CALL indicadorSistema                       ; Llama a la rutina para mostrar el indicador del sistema
        JMP tecladoBucle                            ; Salta al bucle principal de manejo del teclado

tecladoBucle:					    ; Etiqueta para el bucle de manejo del teclado
        MOV AH, 0h                                  ; Prepara AH para la función de leer un carácter del teclado
        INT BIOS_TECLADO                            ; Llama a la interrupción de la BIOS para leer un carácter

        CMP AL, 0Dh                                 ; Compara el carácter leído con el código de Enter
        JZ nuevaLinea                               ; Si es Enter, salta a la etiqueta 'nuevaLinea'

        CMP AL, 08h                                 ; Compara el carácter leído con el código de Backspace
        JZ posBorrado                               ; Si es Backspace, salta a la etiqueta 'posBorrado'

        CMP AL, 02h                                 ; Compara el carácter leído con el código de CTRL + B
        JZ limpiarPantallaYMostrarSimbolo           ; Si es CTRL + B, salta a la etiqueta 'limpiarPantallaYMostrarSimbolo'

        CMP AL, 01h                                 ; Compara el carácter leído con el código de CTRL + A
        JZ sistemaApagado                           ; Si es CTRL + A, salta a la etiqueta 'sistemaApagado'

        CALL mostrarPorPantalla                     ; Llama a la rutina para mostrar el carácter en pantalla
        CALL actualizaCursor                        ; Llama a la rutina para actualizar la posición del cursor
        JMP tecladoBucle                            ; Vuelve al inicio del bucle de manejo del teclado

nuevaLinea:                                         ; Etiqueta para manejar el Enter
        CALL consigueInfoCursor                     ; Llama a la rutina para obtener la posición actual del cursor
        MOV AH, BIOS_VIDEO_POS_CURSOR               ; Prepara AH para mover el cursor
        MOV DL, 0                                   ; Establece la columna del cursor a 0 (inicio de la línea)
        INC DH                                      ; Incrementa la fila del cursor
        INT BIOS_VIDEO                              ; Llama a la interrupción de la BIOS para mover el cursor
        CALL indicadorSistema                       ; Llama a la rutina para mostrar el indicador del sistema
        JMP tecladoBucle                            ; Vuelve al inicio del bucle de manejo del teclado

posBorrado:                                         ; Etiqueta para manejar el Backspace
        CALL consigueInfoCursor                     ; Llama a la rutina para obtener la posición actual del cursor
        CMP DL, 2                                   ; Compara la fila del cursor con 2
        JZ tecladoBucle                             ; Si está en la fila 2, vuelve al bucle (no hace nada)

        MOV AH, BIOS_VIDEO_POS_CURSOR               ; Prepara AH para mover el cursor
        DEC DL                                      ; Decrementa la columna del cursor
        INT BIOS_VIDEO                              ; Llama a la interrupción del BIOS para mover el cursor

        MOV AL, 32                                  ; Carga el código ASCII del espacio en AL
        CALL mostrarPorPantalla                     ; Llama a la rutina para mostrar un espacio en pantalla
        JMP tecladoBucle                            ; Vuelve al inicio del bucle de manejo del teclado

limpiarPantallaYMostrarSimbolo:                     ; Etiqueta para limpiar la pantalla y mostrar un símbolo
        CALL limpiarPantalla                        ; Llama a la rutina para limpiar la pantalla
        CALL indicadorSistema                       ; Llama a la rutina para mostrar el indicador del sistema
        JMP tecladoBucle                            ; Vuelve al inicio del bucle de manejo del teclado

sistemaApagado:                                     ; Etiqueta para manejar el apagado del sistema
        CALL limpiarPantalla                        ; Llama a la rutina para limpiar la pantalla
        MOV AH, 0Eh                                 ; Prepara AH para la función de mostrar caracteres en modo texto
        MOV AL, 'S'                                 ; Carga el carácter 'S' en AL
        INT 10h                                     ; Llama a la interrupción de la BIOS para mostrar el carácter
        MOV AL, 'I'                                 ; Carga el carácter 'I' en AL
        INT 10h                                     ; Llama a la interrupción de la BIOS para mostrar el carácter
        MOV AL, 'S'                                 ; Carga el carácter 'S' en AL
        INT 10h                                     ; Llama a la interrupción de la BIOS para mostrar el carácter
        MOV AL, 'T'                                 ; Carga el carácter 'T' en AL
        INT 10h                                     ; Llama a la interrupción de la BIOS para mostrar el carácter
        MOV AL, 'E'                                 ; Carga el carácter 'E' en AL
        INT 10h                                     ; Llama a la interrupción de la BIOS para mostrar el carácter
        MOV AL, 'M'                                 ; Carga el carácter 'M' en AL
        INT 10h                                     ; Llama a la interrupción de la BIOS para mostrar el carácter
        MOV AL, 'A'                                 ; Carga el carácter 'A' en AL
        INT 10h                                     ; Llama a la interrupción de la BIOS para mostrar el carácter
        MOV AL, ' '                                 ; Carga un espacio en AL
        INT 10h                                     ; Llama a la interrupción de la BIOS para mostrar el carácter
        MOV AL, 'A'                                 ; Carga el carácter 'A' en AL
        INT 10h                                     ; Llama a la interrupción de la BIOS para mostrar el carácter
        MOV AL, 'P'                                 ; Carga el carácter 'P' en AL
        INT 10h                                     ; Llama a la interrupción de la BIOS para mostrar el carácter
        MOV AL, 'A'                                 ; Carga el carácter 'A' en AL
        INT 10h                                     ; Llama a la interrupción de la BIOS para mostrar el carácter
        MOV AL, 'G'                                 ; Carga el carácter 'G' en AL
        INT 10h                                     ; Llama a la interrupción de la BIOS para mostrar el carácter
        MOV AL, 'A'                                 ; Carga el carácter 'A' en AL
        INT 10h                                     ; Llama a la interrupción de la BIOS para mostrar el carácter
        MOV AL, 'D'                                 ; Carga el carácter 'D' en AL
        INT 10h                                     ; Llama a la interrupción de la BIOS para mostrar el carácter
        MOV AL, 'O'                                 ; Carga el carácter 'O' en AL
        INT 10h                                     ; Llama a la interrupción de la BIOS para mostrar el carácter

        MOV AH, 00h                                 ; Prepara AH para esperar una entrada del teclado
        INT BIOS_TECLADO                            ; Llama a la interrupción de la BIOS para esperar una tecla

        HLT                                         ; Detiene la CPU

limpiarPantalla:                                    ; Etiqueta para limpiar la pantalla
        MOV AH, 00h                                 ; Prepara AH para la función de establecer el modo de video
        MOV AL, BIOS_VIDEO_MODO                     ; Carga el modo de video en AL
        INT BIOS_VIDEO                              ; Llama a la interrupción de la BIOS para establecer el modo de video
        RET                                         ; Vuelve a la llamada de la rutina

indicadorSistema:                                   ; Etiqueta para mostrar el indicador del sistema (en este caso, $)
        MOV AL, 36                                  ; Carga el carácter $ en AL
        CALL mostrarPorPantalla                     ; Llama a la rutina para mostrar el carácter en pantalla
        CALL consigueInfoCursor                     ; Llama a la rutina para obtener la posición actual del cursor
        MOV AH, 02h                                 ; Prepara AH para mover el cursor
        MOV DL, 2                                   ; Establece la columna del cursor a 2
        INT BIOS_VIDEO                              ; Llama a la interrupción de la BIOS para mover el cursor
        RET                                         ; Vuelve a la llamada de la rutina

consigueInfoCursor:                                 ; Etiqueta para obtener la información del cursor
        MOV AH, 03h                                 ; Prepara AH para la función de obtener la posición del cursor
        INT BIOS_VIDEO                              ; Llama a la interrupción de la BIOS para obtener la posición del cursor
        RET                                         ; Vuelve a la llamada de la rutina

mostrarPorPantalla:                                 ; Etiqueta para mostrar un carácter en pantalla
        MOV AH, 0Ah                                 ; Prepara AH para la función de mostrar un carácter
        MOV CX, 1                                   ; Establece el número de caracteres a mostrar en 1
        INT BIOS_VIDEO                              ; Llama a la interrupción de la BIOS para mostrar el carácter
        RET                                         ; Vuelve a la llamada de la rutina

actualizaCursor:                                    ; Etiqueta para actualizar la posición del cursor
        CALL consigueInfoCursor                     ; Llama a la rutina para obtener la posición actual del cursor
        MOV AH, BIOS_VIDEO_POS_CURSOR               ; Prepara AH para mover el cursor
        INC DL                                      ; Incrementa la columna del cursor
        INT BIOS_VIDEO                              ; Llama a la interrupción de la BIOS para mover el cursor
        RET                                         ; Vuelve a la llamada de la rutina

times BITS_DE_RELLENO_FLOPPY - ($ - $$) db 0	    ; Rellena el resto del sector hasta 510 bytes con ceros
dw FIRMA_BOOTLOADER                            	    ; Escribe la firma del bootloader al final del sector
