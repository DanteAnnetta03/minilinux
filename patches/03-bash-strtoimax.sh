#!/bin/sh
# Fix bash 5.2 + musl static cross: multiple definition of strtoimax
#
# El ./configure de bash hace DOS checks:
#   1) AC_CHECK_FUNC: existe strtoimax? -> si (musl la provee).
#   2) AC_RUN_IFELSE: funciona correctamente? -> ejecuta un test.
# En cross-compile, el AC_RUN_IFELSE no puede correr el binario target,
# entonces responde "no" por default y bash agrega su propio
# lib/sh/strtoimax.o al LIBOBJS. Al linkar -static, su copia Y la de musl
# terminan en el mismo binario -> "multiple definition".
#
# Fix: sacar strtoimax de LIBOBJS en lib/sh/Makefile. Limpia el .o huerfano
# para forzar relink.
#
# Aplicar DESPUES de './configure', ANTES de 'make'.

set -e
SRC="${1:?uso: $0 <bash-src-dir>}"
F="$SRC/lib/sh/Makefile"
[ -f "$F" ] || { echo "no encontrado: $F (correr ./configure primero)" >&2; exit 1; }

sed -i 's|\${LIBOBJDIR}strtoimax\$U\.o||' "$F"
rm -f "$SRC/lib/sh/strtoimax.o" "$SRC/lib/sh/libsh.a" "$SRC/bash"

echo "OK: strtoimax removido de LIBOBJS en $F"
