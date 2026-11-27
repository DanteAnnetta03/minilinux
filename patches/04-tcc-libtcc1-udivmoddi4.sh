#!/bin/sh
# Fix tcc 0.9.27 libtcc1: __udivmoddi4 declarada static, no exportable.
#
# En lib/libtcc1.c linea 148:
#   static UDWtype __udivmoddi4 (UDWtype n, UDWtype d, UDWtype *rp)
# Al hacer 64-bit divides en codigo que compila tcc, el linker busca
# ese simbolo en libtcc1.a pero esta como 't' minuscula (local), no 'T'
# (exportable). Resultado: "undefined symbol __udivmoddi4" al linkar
# programas de usuario.
#
# Fix: sacar el 'static' asi queda como simbolo global.
#
# Aplicar antes de 'make cross-i386'.

set -e
SRC="${1:?uso: $0 <tcc-src-dir>}"
F="$SRC/lib/libtcc1.c"
[ -f "$F" ] || { echo "no encontrado: $F" >&2; exit 1; }

sed -i 's|^static UDWtype __udivmoddi4|UDWtype __udivmoddi4|' "$F"

echo "OK: __udivmoddi4 ahora es global en $F"
