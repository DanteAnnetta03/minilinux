#!/bin/sh
# Desactivar aceleracion HW de SHA1/SHA256 en busybox 1.36.1
#
# El asm x86-32 de SHA-NI (libbb/hash_md5_sha256_x86-32_shaNI.S) genera
# relocations en segmento read-only. Al linkar '-static' con musl, el linker
# (ld) aborta con:
#   read-only segment has dynamic relocations
# Fix: desactivar ambos CONFIG_SHA1_HWACCEL y CONFIG_SHA256_HWACCEL en .config.
# La implementacion C portable toma el relevo (performance despreciable para
# el uso nuestro).
#
# Aplicar DESPUES de 'make defconfig' / 'make menuconfig', ANTES de 'make'.

set -e
SRC="${1:?uso: $0 <busybox-src-dir>}"
F="$SRC/.config"
[ -f "$F" ] || { echo "no encontrado: $F (corré defconfig primero)" >&2; exit 1; }

sed -i 's|^CONFIG_SHA256_HWACCEL=y|# CONFIG_SHA256_HWACCEL is not set|' "$F"
sed -i 's|^CONFIG_SHA1_HWACCEL=y|# CONFIG_SHA1_HWACCEL is not set|' "$F"

echo "OK: SHA-NI desactivado en $F"
