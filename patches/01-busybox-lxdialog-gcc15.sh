#!/bin/sh
# Fix busybox 1.36.1 menuconfig con GCC 15 + shell quoting
#
# Problema 1: el test program del script usa K&R "main() {}". GCC 15 default
#   es C23 y rechaza funciones sin tipo de retorno explicito.
# Problema 2: make pasa -DCURSES_LOC="<ncurses.h>" al script como argumento,
#   pero las comillas dobles las consume la shell antes de que el script las
#   use. Al compilar, "<" se interpreta como redireccion y falla.
#
# Fix: int main(void){return 0;} + hardcode del include a <ncurses.h>.

set -e
SRC="${1:?uso: $0 <busybox-src-dir>}"
F="$SRC/scripts/kconfig/lxdialog/check-lxdialog.sh"
[ -f "$F" ] || { echo "no encontrado: $F" >&2; exit 1; }

sed -i 's/main() {}/int main(void){return 0;}/' "$F"
sed -i 's|#include CURSES_LOC|#include <ncurses.h>|' "$F"

echo "OK: parcheado $F"
