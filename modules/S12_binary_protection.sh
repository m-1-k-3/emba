#!/bin/bash

# emba - EMBEDDED LINUX ANALYZER
#
# Copyright 2020-2021 Siemens Energy AG
# Copyright 2020-2021 Siemens AG
#
# emba comes with ABSOLUTELY NO WARRANTY. This is free software, and you are
# welcome to redistribute it under the terms of the GNU General Public License.
# See LICENSE file for usage of this software.
#
# emba is licensed under GPLv3
#
# Author(s): Michael Messner, Pascal Eckmann

# Description:  This module looks for protection mechanisms in the binaries via checksec.

S12_binary_protection()
{
  module_log_init "${FUNCNAME[0]}"
  module_title "Check binary protection mechanisms"
  local BIN_PROT_COUNTER=0

  if [[ -f "$EXT_DIR"/checksec ]] ; then
    print_output "RELRO           STACK CANARY      NX            PIE             RPATH      RUNPATH      Symbols         FORTIFY Fortified  Fortifiable  FILE"
    for LINE in "${BINARIES[@]}" ; do
      if ( file "$LINE" | grep -q ELF ) ; then
        print_output "$( "$EXT_DIR"/checksec --file="$LINE" | grep -v "CANARY" | rev | cut -f 2- | rev )""\\t""$NC""$(print_path "$LINE")"
        BIN_PROT_COUNTER=$((BIN_PROT_COUNTER+1))
      fi
    done
  else
    print_output "[-] Binary protection analyzer $EXT_DIR/checksec not found - check your installation."
  fi

  module_end_log "${FUNCNAME[0]}" "$BIN_PROT_COUNTER"
}

