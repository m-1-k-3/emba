#!/bin/bash

# EMBA - EMBEDDED LINUX ANALYZER
#
# Copyright 2020-2022 Siemens Energy AG
#
# EMBA comes with ABSOLUTELY NO WARRANTY. This is free software, and you are
# welcome to redistribute it under the terms of the GNU General Public License.
# See LICENSE file for usage of this software.
#
# EMBA is licensed under GPLv3
#
# Author(s): Michael Messner

# Description:  Installs vmlinux-to-elf - https://github.com/marin-m/vmlinux-to-elf

I24_25_kernel_tools() {
  module_title "${FUNCNAME[0]}"

  if [[ "$LIST_DEP" -eq 1 ]] || [[ $IN_DOCKER -eq 1 ]] || [[ $DOCKER_SETUP -eq 0 ]] || [[ $FULL -eq 1 ]]; then

    print_pip_info "lz4"
    print_pip_info "zstandard"
    print_tool_info "python3-pip" 1
  
    if [[ "$LIST_DEP" -eq 1 ]] || [[ $DOCKER_SETUP -eq 1 ]] ; then
      ANSWER=("n")
    else
      echo -e "\\n""$MAGENTA""$BOLD""These applications (if not already on the system) will be downloaded!""$NC"
      ANSWER=("y")
    fi
  
    case ${ANSWER:0:1} in
      y|Y )
        apt-get install "${INSTALL_APP_LIST[@]}" -y --no-install-recommends
        if ! [[ -d external/vmlinux-to-elf ]]; then
          git clone https://github.com/marin-m/vmlinux-to-elf external/vmlinux-to-elf
        fi

        cd external/vmlinux-to-elf || ( echo "Could not install EMBA component vmlinux-to-elf" && exit 1 )
        pip3 install --upgrade lz4 zstandard git+https://github.com/clubby789/python-lzo@b4e39df
        pip3 install --upgrade git+https://github.com/marin-m/vmlinux-to-elf
        cd "$HOME_PATH" || ( echo "Could not install EMBA component vmlinux-to-elf" && exit 1 )
      ;;
    esac
  fi
} 