#!/usr/bin/env bash

#
# =========================================
#                    Colors
# =========================================
ESCAPE="\033[0;"
RESET="${ESCAPE}0m"
BOLD="${ESCAPE}1m"
LIGHT_RED="${ESCAPE}91m"
LIGHT_GREEN="${ESCAPE}92m"
LIGHT_YELLOW="${ESCAPE}93m"
LIGHT_CYAN="${ESCAPE}96m"

START="${BOLD}${LIGHT_CYAN}::${RESET}${BOLD}"
FINISHED="${BOLD}${LIGHT_GREEN}::${RESET}${BOLD}"
ERROR="${BOLD}${LIGHT_RED}::${RESET}${BOLD}"
INPUT="${BOLD}${LIGHT_YELLOW}::${RESET}"

#
# =========================================
#                    Help
# =========================================
#
HELP_TEXT=$(cat <<EOF
Latex build script v1.1 - MaFeLP <mafelp@protonmail.ch>
Builds a latex file to pdf and cleans up the build directory.

Usage:
  latex.sh (<option>) <file>

Options:
  -i  --init    Copies the LaTeX template to file.tex
  -v  --verbose  Verbose - Show compiler output
  -r  --rerun    Rerun - Rerun verbosely on compiler error
  -o  --open    Opens the editor after exiting
  --browser=BROWSER  Open the the compiled PDF in BROWSER

Copyright (c) 2021 MaFeLP <mafelp@protonmail.ch>
EOF
)
if [ "$1" = "-h" -o "$1" = "--help" ]; then
echo -e "$HELP_TEXT"
exit; fi

#
# =========================================
#                    Init
# =========================================
#
if [ "$1" = "-i" -o "$1" = "--init" ];then
  if [ "$2" = "-o" -o "$2" = "--open" ];then
    filename=$3
  else
    filename=$2
  fi

  if [ -f "$filename.tex" ];then
    echo -e "$ERROR Could not copy the LaTeX Template to $filename.tex! File already exists!$RESET"
    exit 1
  fi
  echo -e "$START Copying LaTeX Template to $filename.tex...$RESET"
  if cp ~/Templates/LaTeX.tex ./$filename.tex;then
    echo -e "$FINISHED Copied LaTeX Template to $filename.tex!$RESET"
    exit 0
  else
    echo -e "$ERROR Could not copy the LaTeX Template to $filename.tex! cp exited with an error!$RESET"
    exit 1
  fi

  if [ "$2" = "-o" -o "$2" = "--open" ];then
    echo -e "$START Opening $filename.tex with $EDITOR...$RESET"
    $EDITOR "$filename.tex"
  fi
fi

#
# =========================================
#                Settings
# =========================================
#
filename=""

hide_output=true
rerun_on_error=false
open_browser_on_success=false
error=false

#
# =========================================
#              Parse Arguments
# =========================================
#
function parse_arguments() {
  for arg in $@;do
    if [[ "$arg" =~ '^-{1}[vVrR]{1,2}$' ]];then
      for (( i=0;i<${#arg};i++ ));do
        c=${arg:i:1}
        if [ "$c" = "v" -o "$c" = "V" ];then
          hide_output=false
        elif [ "$c" = "r" -o "$c" = "R" ];then
          rerun_on_error=true
        #elif [ "$c" = "-" ];then
        fi
      done
    elif [[ "$arg" =~ '^(-{2}[Bb]rowser=.+)$' ]];then
      local browser_name_builder=""
      local is_name="false"

      for (( i=0; i<${#arg}; i++ ));do
        c=${arg:i:1}
        if [ $is_name == "true" ];then
          browser_name_builder=$browser_name_builder$c
        elif [ $c == "=" ];then
          is_name="true"
        fi
      done
      browser=$browser_name_builder
      open_browser_on_success=true
    elif [[ "$arg" =~ '^(-{2}[Vv]erbose)' ]];then
      hide_output=false
    elif [[ "$arg" =~ '^(-{2}[Rr]erun)$' ]];then
      rerun_on_error=true
    else
      filename=$arg
      if [[ "$filename" =~ '\.tex$' ]];then
        filename=$(echo "$filename" | sed 's/\.tex//g')
      fi
      break
    fi
  done
}

#
# =========================================
#                   compile
# =========================================
#
function compile() {
  if [ $hide_output == "true" ];then
    echo "x\n" | pdflatex "${filename}.tex" >> /dev/null
    if [ $? -gt 0 ];then
      error=true
    else
      error=false
    fi
  else
    pdflatex "${filename}.tex"
    if [ $? -gt 0 ];then
      error=true
    else
      error=false
    fi
  fi
}

function remove() {
  for item in ".aux" ".out" ".log" ".toc" ".fdb_latexmk" ".fls";do
    if [ -f "$filename$item" ];then
      if [ $hide_output == "true" ];then
        echo -e "$START Removing $filename$item..."
      fi
      rm "${filename}${item}"
    fi
  done
  # Removes "texput.log" out of syntax
  if [ -f "texput.log" ];then
    if [ $hide_output == "true" ];then
      echo -e "$START Removing texput.log..."
    fi
    rm "texput.log"
  fi
}

function build() {
  echo -e "$START Building PDF... $RESET"
  compile

  if [ $error == "true" ];then
    echo -e "$ERROR Error: PDF Latex exited with exit code 1 or higher.$RESET"

    if [ $rerun_on_error = "true" ];then
      hide_output=false
      compile
    fi
    exit 1
  fi

  echo -e "$START Building PDF the second time... $RESET"
  compile

  echo -e "$START Cleaning up...$RESET"
  remove

  echo -e "$FINISHED Done!$RESET"

  if [ $open_browser_on_success == true ];then
    echo -e "$START Opening document with $browser...$RESET"
    $browser "${filename}.pdf" &>> /dev/null
  fi
}

#
# =========================================
#                Main Menu
# =========================================
#
function menu() {
  options=()
  options+=("init" "Create a new LaTeX file")
  options+=("compile" "Compile an existing LaTeX file")
  options+=("help" "Show the command line help")
  entry=$(whiptail --title 'Menu' --backtitle 'latex.sh' --notags --menu 'Please select an action' 0 0 0 "${options[@]}" 3>&1 1>&2 2>&3 | sed 's/"//g')

  case "$entry" in
    "init")
      whiptail --title 'Feature not implemented!' --backtitle 'latex.sh' --msgbox "This feature is currently not implemented in the GUI! Please use the command line option '-i <FILENAME>' to create a file from the template!" 0 0
      ;;

    "compile")
      local msgtext="Enter the filename to compile"
      while [ ! -e "$filename" ];do
        filename=$(whiptail --title 'Filename' --backtitle 'latex.sh' --inputbox "$msgtext" 0 0 "$filename" 3>&1 1>&2 2>&3)
        if [[ $? -ne 0 ]];then
          exit 1
        fi
        filename=$(echo "$filename" | sed 's/"//g')
        msgtext="File '$filename' does not exist!\n\nEnter the filename to compile"
      done
      filename=$(echo "$filename" | sed 's/\.tex$//g')
      build
      ;;

    "help")
      whiptail --title 'Help' --backtitle 'latex.sh' --msgbox "$HELP_TEXT" 0 0
      ;;

    *)
      whiptail --title 'Error!' --backtitle 'latex.sh' --msgbox "A menu entry was selected, that should not have been selected!\n\nPlease report the problem to the project Maintainer!" 0 0
      exit 1
      ;;
  esac
}

#
# =========================================
#                 Running
# =========================================
#
if [ -z "$1" ];then
  menu
else
  parse_arguments $@

  build
fi
