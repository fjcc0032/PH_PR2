# BootLoaderFran

### Introducción
Este proyecto es un BootLoader simple escrito en ensamblador que se ejecuta al iniciar un sistema basado en BIOS. Su propósito principal es manejar la entrada del teclado y mostrar información en la pantalla. Se carga en memoria y utiliza interrupciones de la BIOS para interactuar con la pantalla y el teclado. <br>
Este código es un ejemplo básico de cómo se puede implementar un sistema de entrada y salida en un entorno de bajo nivel.

### Funcionalidades
El BootLoader se compone de varias implementaciones que añaden:
- Visualización del indicador del sistema ($).
- Manejo del teclado aceptando palabras completas.
- Comandos aceptados:
  - Enter: mueve el cursor a una nueva línea.
  - Backspace: borra el carácter anterior (hasta el símbolo del sistema, sin borrar este).
  - CTRL + B: Limpia la pantalla (mostrando el símbolo del sistema posteriormente).
  - CTRL + A: Apaga el sistema (muestra un mensaje de apagado hasta que se pulse una tecla y no permite realizar ninguna acción).

### Funcionamiento
Para ver el desempeño del BootLoader hay que seguir estos pasos:
- Abrimos una terminal y nos dirigimos a la carpeta donde tenemos el BootLoader descargado.
- Ejecutamos el script de Bash que compila y ejecuta el BootLoader:
```
./script.sh
```
Con esto, ya podemos probar las funcionalidades antes descritas.
