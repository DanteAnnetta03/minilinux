# MiniLinux 2.0

Distro Linux minimalista, booteable como ISO (~14 MB), pensada para escribir
código y transferir archivos a una máquina moderna. Kernel 6.14 + BusyBox
1.36 + musl static.

Este repo contiene **todo lo que escribí a mano** para construir la distro:
configs del kernel y BusyBox, scripts de init, dotfiles, documentación de
arquitectura y guía paso a paso, y los parches para que los sources vírgenes
compilen bien bajo Ubuntu 26.04 / GCC 15.

**No incluye**: binarios, tarballs de sources, la toolchain cross, ni la ISO
final. Se bajan/generan según la guía.

## Estructura del repo

```
.
├── README.md              este archivo
├── docs/
│   ├── ARQUITECTURA.txt   diseño: por qué cada decisión
│   ├── GUIA.txt           paso a paso para reconstruir desde cero
│   ├── NOTAS.txt          diagnóstico del floppinux original (v1)
│   └── PENDING.txt        issues abiertos y workarounds
├── patches/               fixes aplicados a sources upstream (ver patches/README.md)
├── rootfs-overlay/        todos los archivos que van al rootfs del target
│   ├── etc/               configs del sistema (passwd, inittab, profile, etc.)
│   ├── root/              dotfiles de root (.bashrc, .bash_profile)
│   ├── home/mux/          dotfiles de mux + hello.c de ejemplo
│   ├── var/www/           página servida por httpd
│   └── usr/share/consolefonts/   fuente Monocraft 7×16 PSF
├── iso/
│   └── isolinux.cfg       configuración del bootloader
├── kernel/
│   └── config             snapshot del .config del kernel 6.14
└── busybox/
    └── config             snapshot del .config de BusyBox 1.36.1
```

## Qué necesitás para reconstruir la ISO

1. **Ubuntu 26.04** (u otra distro Linux x86_64 moderna).
2. **Paquetes de host**: ver la Parte 0 de `docs/GUIA.txt` (es un `apt install`
   de ~15 paquetes).
3. **Cross toolchain** `i486-linux-musl-cross` de musl.cc.
4. **Sources** (tarballs) de kernel, busybox, ncurses, bash, nano, joe, tcc,
   lua, micropython, dropbear, rsync. URLs exactas en GUIA.txt.

## Cómo reconstruir

Seguí `docs/GUIA.txt` de principio a fin. Las partes 1–11 compilan cada
paquete; cuando digan "menuconfig" o "configure", al terminar correr el patch
correspondiente de `patches/` **antes** de `make`:

```bash
# ejemplo con busybox
cd busybox-1.36.1
make defconfig
# usar busybox/config de este repo como override
cp /ruta/al/repo/busybox/config .config
/ruta/al/repo/patches/02-busybox-sha-hwaccel-off.sh .
make CROSS_COMPILE=i486-linux-musl- -j$(nproc)
```

El mismo patrón aplica para kernel, bash y tcc. Ver `patches/README.md`.

## Qué contiene el rootfs final

Lo que arma la Parte 13–17 de GUIA.txt mezcla:

- **Instalación de BusyBox** (`make install CONFIG_PREFIX=rootfs`): puebla
  `bin/`, `sbin/`, `usr/bin/`, `usr/sbin/` con symlinks al único binario.
- **Binarios compilados**: bash, nano, joe, tcc, lua, micropython, dropbear,
  rsync — se copian uno por uno a `usr/bin/` o `usr/sbin/`.
- **Headers de desarrollo**: kernel headers + musl headers + libc.a + crts.
- **Dynamic linker musl** (libc.so + symlinks ld-musl-i386.so.1 y
  ld-musl-arm.so.1 — este último por un workaround de tcc, ver PENDING.txt).
- **Overlay de este repo** (`rootfs-overlay/`): se copia sobre el rootfs
  **al final**, sobrescribiendo defaults.
- **Terminfo mínimo**: compilado con `tic` desde el source de ncurses.

## Autenticación

- Usuario **root** / pass `minilinux`
- Usuario **mux** / pass `minilinux` (UID 1000)

## Estado

Ver `docs/PENDING.txt` para issues conocidos. En particular:
- Fuente Monocraft no se aplica (SYSFB no activa framebuffer).
- tcc tiene el ELF interpreter de ARM cocido (hay workaround con symlink).
- Red no probada funcionalmente desde el host.
