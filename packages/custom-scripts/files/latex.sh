#!/usr/bin/env bash

################################################################################
##                                 Colors                                     ##
################################################################################
ESCAPE="\033[0;"
RESET="${ESCAPE}0m"
BOLD="${ESCAPE}1m"
CYAN="${ESCAPE}36m"
LIGHT_RED="${ESCAPE}91m"
LIGHT_GREEN="${ESCAPE}92m"
LIGHT_YELLOW="${ESCAPE}93m"
LIGHT_MAGENTA="${ESCAPE}95m"
LIGHT_CYAN="${ESCAPE}96m"

START="${BOLD}${LIGHT_CYAN}::${RESET}${BOLD}"
FINISHED="${BOLD}${LIGHT_GREEN}::${RESET}${BOLD}"
ERROR="${BOLD}${LIGHT_RED}::${RESET}${BOLD}"
INFO="${BOLD}${LIGHT_MAGENTA}::${RESET}"
STEP="${BOLD}${CYAN}==>${RESET}"
SUB_STEP="${BOLD}${blue} ->${RESET}"
INPUT="${BOLD}${LIGHT_YELLOW}::${RESET}"

################################################################################
##                                  Help                                      ##
################################################################################
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

################################################################################
##                                CLI init                                    ##
################################################################################
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

################################################################################
##                                Settings                                    ##
################################################################################
filename=""

hide_output=true
rerun_on_error=false
open_browser_on_success=false
error=false

################################################################################
##                            parse arguments                                 ##
################################################################################
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

################################################################################
##                                compile                                     ##
################################################################################
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

################################################################################
##                                init GUI                                    ##
################################################################################
function init() {
  # Input the filename
  filename=$(whiptail --title 'Filename' --backtitle 'latex.sh' --inputbox "Please enter a filename for the new file\n\n(.tex will be appended automatically)" 0 0 "$(date +'%Y-%m-%d')-Max_Fehlinger--" 3>&1 1>&2 2>&3 | sed 's/"//g')
  filename="${filename}.tex"

  # Check if the file already exists
  if [ -e "$filename" ];then
    if ! whiptail --title 'File already exists' --backtitle 'latex.sh' --yesno "A file with the name '$filename' already exists. What do want to do?" 0 0 --yes-button "Overwrite" --no-button "Do nothing";then
      exit 1
    fi
  fi

  echo -e "$INFO Using filename '$filename'"

  # Select the language
  local language=$(whiptail --title 'Language' --backtitle 'latex.sh' --notags --menu 'Select a language' 0 0 0 ngerman Deutsch english English spanish "Español" 3>&1 1>&2 2>&3 | sed 's/"//g')
  echo -e "$INFO Using language '$language'"

  # Select the packages
  local packages=()
  packages+=()
  packages+=("\usepackage[utf8]{inputenc}" "inputenc - input encoding=utf-8" "on")
  packages+=("\usepackage[margin=60pt,twoside]{geometry}" "geometry - Page margins & twoside" "on")
  packages+=("\usepackage{fancyhdr}" "fancyhdr - Header & Footer" "on")
  packages+=("\usepackage[$language]{babel}" "babel - langage optimizations" "on")
  packages+=("\usepackage{multicol}" "multicols - use multiple columns" "off")
  packages+=("\usepackage{csquotes}" "csquotes - quote stuff" "off")
  packages+=("\usepackage{xcolor}" "xcolor - colored pages" "off")
  packages+=("\usepackage[version=4]{mhchem}" "mhchem - chemistry equations with \\ce" "off")
  packages+=("\usepackage{chemfig}" "chemfig - draw skeleton structures of molecules" "off")
  packages+=("\usepackage{amsmath}" "amsmath - useful math stuff" "off")
  packages+=("\usepackage{graphicx}" "graphicx - include graphics (plots/images) in the pdf" "off")
  packages+=("\usepackage{pgfplots}" "pgfplots - plot nice graphics" "off")
  packages+=("\usepackage{tikz}" "tikz - multifunctional graphics library" "off")
  local selected_packages=(`whiptail --title 'Packages' --backtitle 'latex.sh' --nocancel --notags --checklist 'Select packages to include' 0 0 0 "${packages[@]}" 3>&1 1>&2 2>&3 | sed 's/"//g'`)
  echo -e "$INFO Selected ${#selected_packages[@]} packages"

  # Enter title
  local title=$(whiptail --title 'Title' --backtitle 'latex.sh' --inputbox --nocancel 'Please enter a title for the document' 0 0 "" 3>&1 1>&2 2>&3 | sed 's/"//g')
  echo -e "$INFO Using title '$title'"

  # Enter author
  local author=$(whiptail --title 'Author' --backtitle 'latex.sh' --inputbox --nocancel 'Please enter an author for the document' 0 0 "Max Ove Fehlinger" 3>&1 1>&2 2>&3 | sed 's/"//g')
  echo -e "$INFO Using author '$author'"

  # Enter date
  local date=$(whiptail --title 'Date' --backtitle 'latex.sh' --inputbox --nocancel 'Please enter a date for the document' 0 0 "$(date +'%d.%m.%Y')" 3>&1 1>&2 2>&3 | sed 's/"//g')
  echo -e "$INFO Using date '$date'"

  # Enter subject
  local subject=$(whiptail --title 'Subject' --backtitle 'latex.sh' --inputbox --nocancel 'Please enter a subject for the document' 0 0 "" 3>&1 1>&2 2>&3 | sed 's/"//g')
  echo -e "$INFO Using subject '$subject'"

  # Enter keywords
  local keywords=$(whiptail --title 'Keywords' --backtitle 'latex.sh' --inputbox --nocancel 'Please enter some keywords for the document' 0 0 "" 3>&1 1>&2 2>&3 | sed 's/"//g')
  echo -e "$INFO Using keywords '$keywords'"

  # Enter header 1
  local header1=$(whiptail --title 'Header left' --backtitle 'latex.sh' --nocancel --inputbox 'Please enter a left header' 0 0 "Fach/Kürzel/$author/10a" 3>&1 1>&2 2>&3 | sed 's/"//g')
  echo -e "$INFO Using left header '$header1'"

  # Enter header 2
  local header2=$(whiptail --title 'Header right' --backtitle 'latex.sh' --nocancel --inputbox 'Please enter a right header' 0 0 '\textbf{}' 3>&1 1>&2 2>&3 | sed 's/"//g')
  echo -e "$INFO Using right header '$header2'"

  # Enter footer 1
  case "$language" in
    "ngerman")
      footer1='Erstellt mit \LaTeX'
      ;;
    "spanisch")
      footer1='Creado con \LaTeX'
      ;;
    *)
      footer1='Created with \LaTeX'
      ;;
  esac
  local footer1=$(whiptail --title 'Footer left' --backtitle 'latex.sh' --nocancel --inputbox 'Please enter a left footer' 0 0 "$footer1" 3>&1 1>&2 2>&3 | sed 's/"//g')
  echo -e "$INFO Using left footer '$footer1'"

  # Enter footer 2
  local footer2=$(whiptail --title 'Footer right' --backtitle 'latex.sh' --nocancel --inputbox 'Please enter a right footer' 0 0 '\thepage' 3>&1 1>&2 2>&3 | sed 's/"//g')
  echo -e "$INFO Using right footer '$footer2'"

  # Ask if file should be written
  local config=$(cat <<EOF
Your LaTeX configuration looks like the following:

Language: $language
Number of packages: ${#selected_packages[@]}
Title: $title
Author: $author
Date: $date
Subject: $subject
Keywords: $keywords
Left Header: $header1
Right Header $header2
Left Footer $footer1
Right Footer $footer2

Do you want to write it as TeX to $filename?
EOF
  )
  if ! whiptail --title 'Write configuration?' --backtitle 'latex.sh' --yesno "$config" 0 0;then
    exit 1
  fi

  # Save the file
  echo -e "$START Writing file $filename..."
  echo -e "$STEP Adding documentclass and language"
  cat > "$filename" <<EOF
\\documentclass[a4paper]{scrartcl}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                              Import Packages                              %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
EOF
  echo -e "$STEP Adding packages"
  for pkg in "${selected_packages[@]}"; do
    echo -e "$SUB_STEP appending '$pkg'"
    echo "$pkg" >> "$filename"
  done

  echo -e "$STEP Adding the rest"
  cat >> "$filename" <<EOF

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                               General Config                              %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Use hyperlinks in the table of contents
\\usepackage{hyperref}
\\hypersetup{
    colorlinks,
    citecolor=black,
    filecolor=black,
    linkcolor=black,
    urlcolor=black
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                               Informations                                %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\\title{$title}
\\author{$author}
\\date{$date}
\\pdfinfo{
  /Title    ($title)
  /Author   ($author)
  /Creator  ($author)
  /Producer ($author)
  /Subject  ($subject)
  /Keywords ($keywords)
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                            Header and Footer                              %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\\pagestyle{fancy}
\\fancyhf{} % Removes the page number in the middle
\\fancyhead[RE,LO]{$header1} % Left side of the header
\\fancyhead[LE,RO]{$header2} % right side of the header
\\fancyfoot[RE,LO]{$footer1} % left side of the footer
\\fancyfoot[LE,RO]{$footer2} % right side of the footer

\\renewcommand{\\headrulewidth}{2pt} % Makes a two point line below the header
\\renewcommand{\\footrulewidth}{2pt} % Makes a two point line below the footer

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                 Macros                                    %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\\newcommand{\\mkline}{\\begin{center}\\rule{0.5\\textwidth}{0.4pt}\\end{center}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                Document                                   %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\\begin{document}
\\maketitle % Prints the title
\\tableofcontents % Prints the table of contents
\\clearpage % Makes an empty page. Useful after long table of contents and title

\\end{document}
EOF

  open_editor "$filename"
}

################################################################################
##                               open editor                                  ##
################################################################################
function open_editor() {
  local file="$1"
  local editors=()
  editors+=("codium" "Visual Studio Codium")
  editors+=("nvim" "NeoVim")
  editors+=("system" "system ($EDITOR)")
  editors+=("custom" "Custom")
  local selected=$(whiptail --title 'Open in editor' --backtitle 'latex.sh' --notags --menu 'Please select an editor to open the file with' 0 0 0 "${editors[@]}" 3>&1 1>&2 2>&3 | sed 's/"//g')

  case "$selected" in
    "codium" | "nvim")
      "$selected" "$file"
      ;;
    "system")
      "$EDITOR" "$file"
      ;;
    "custom")
      $(whiptail --title 'Editor' --backtitle 'latex.sh' --inputbox "Enter the path to the editor binary" 0 0 "nvim" 3>&1 1>&2 2>&3) "$file"
      ;;
    *)
      exit 0
      ;;
  esac
}

################################################################################
##                                Main Menu                                   ##
################################################################################
function menu() {
  local options=()
  options+=("init" "Create a new LaTeX file")
  options+=("compile" "Compile an existing LaTeX file")
  options+=("open" "Open a TeX file in an editor")
  options+=("help" "Show the command line help")
  local entry=$(whiptail --title 'Menu' --backtitle 'latex.sh' --notags --menu 'Please select an action' 0 0 0 "${options[@]}" 3>&1 1>&2 2>&3 | sed 's/"//g')

  case "$entry" in
    "init")
      init
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

    "open")
      filename=""
      filename=$(whiptail --title 'Filename' --backtitle 'latex.sh' --inputbox "$msgtext" 0 0 "$filename" 3>&1 1>&2 2>&3)
      if [[ "$filename" == "" ]];then
        exit 1
      fi
      open_editor "$filename"
      ;;

    "help")
      whiptail --title 'Help' --backtitle 'latex.sh' --msgbox "$HELP_TEXT" 0 0
      ;;

    *)
      # This will be called on cancel
      exit 1
      ;;
  esac
}

################################################################################
##                                 Running                                    ##
################################################################################
if [ -z "$1" ];then
  menu
else
  parse_arguments $@

  build
fi
