# Patches

Cada patch arregla una incompatibilidad concreta entre el source upstream y
nuestro entorno (Ubuntu 26.04 / GCC 15 / musl static / etc.).

Se aplican DESPUES de extraer cada tarball y ANTES de correr `./configure` o
`make`. Están implementados como scripts ejecutables (en vez de .patch files)
porque la mayoría son `sed` sobre una sola línea — más robustos a cambios de
whitespace que un diff unificado.

Orden sugerido:

| # | Script | Aplica a | Sintoma que arregla |
|---|---|---|---|
| 01 | `01-busybox-lxdialog-gcc15.sh` | busybox 1.36 | `menuconfig` falla con "ncurses not found" por K&R + shell quoting |
| 02 | `02-busybox-sha-hwaccel-off.sh` | busybox 1.36 .config | `read-only segment has dynamic relocations` al linkar static-musl |
| 03 | `03-bash-strtoimax.sh` | bash 5.2 | `multiple definition of strtoimax` entre libsh.a y musl |
| 04 | `04-tcc-libtcc1-udivmoddi4.sh` | tcc 0.9.27 | `undefined symbol __udivmoddi4` al linkar programas |

Cada script recibe como UNICO argumento el directorio del source extraído.
Ej:

```bash
./patches/01-busybox-lxdialog-gcc15.sh /tmp/build/busybox-1.36.1
```
