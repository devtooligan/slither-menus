#!/bin/bash

# NOTE: main() invoked at EOF

#################################################################################################################################################
# initial variable assigments
target=$1
selected_logdir=$2
today=$(date "+%Y-%m-%d")
default_logdir="./"

# color definitions
BOLD=$(tput bold)
RED=$(tput setaf 1)    # RED
GREEN=$(tput setaf 2)  # GREEN
YELLOW=$(tput setaf 3) # YELLOW
BLUE=$(tput setaf 4)   # BLUE
RESET=$(tput sgr0)

#################################################################################################################################################
#  FUNCTIONS:

checkcanceled() {
    exitStatus=$?
    if (("$exitStatus" == 1)); then
        echo
        echo
        echo
        echo 'Canceled'
        exit
    fi
}

selectprinters() {
    cmd=(dialog --separate-output --title "Select printers:" --checklist "Use arrow keys and press Space to select/deselect. Press Enter to accept." 0 0 0)

    options=(
        contract-summary "Output a quick list of functions for each contract." off
        function-summary "Summary of functions including visibility, modifiers, and more. 😍 A crowd favorite." off
        inheritance "A break down of parent -> child and child -> parent relationships." off
        constructor-calls "Print the calling sequence of constructors based on C3 linearization." off
        variable-order "Print the storage order of the state variables for all contracts including parents." off
        modifiers "Print the modifiers called by each function." off
        pausable "Unfortunately named, this prints functions that are NOT pausable." off
        vars-and-auth "Print all storage writes and any msg.sender checks found in each function." off
        require "Print the require and assert calls of each function." off
        function-id "Print the 4 byte signature of the functions." off
        data-dependency "Print the data dependencies of the variables for all functions for all contracts including parents." off
        slithir-ssa "Print the slithIR representation of the functions (SSA version)" off
        inheritance-graph "Export a graph showing the inheritance interaction between the contracts to a DOT file ⚫ 📂." off
        cfg "Export the control flow graph of each function to a DOT file ⚫ 📂." off
        call-graph "Export the call-graph of the contracts to a DOT file ⚫ 📂. " off
        dominator "Export the dominator tree of each function to a DOT file ⚫ 📂." off
        slithir "Print the slithIR representation of the functions. 🚧 WIP" off
        evm "Print the EVM representation of the functions. 🚧 Needs dep installed" off
        echidna "This printer is meant to improve Echidna code coverage. 🚧 WIP - not yet used by Echidna." off
        declaration "Printse source code declaration, implementation and references of the contracts 🚧 Under construction." off
        human-summary "Print a human-readable summary of the contracts. 🚧 Unstable." off)

    choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
    checkcanceled

}

completed() {
    echo
    echo ${GREEN}Printer run completed${RESET}
    echo
    echo Have a nice day! 😃
    echo
}

process() {
    # Logic for multiple printers
    # Join the elements in the array with commas
    # printers_string=$(printf "%s," "${printers[@]}")
    # Remove the last comma from the string
    # printers_string=${printers_string%?}

    logs_created=()
    for printer in ${choices[@]}; do

        # determine log file name.  example: slither_contract-summary_2020_01_01.log
        # if file exists, append (1),(2) etc to the end of the file name
        output_name="${base_logdir}slither-${printer}-${today}"
        output="${output_name}.log"
        count=0
        while [ -e "$output" ]; do
            count=$((count + 1))
            output="${output_name}(${count}).log"
        done
        logs_created+=("$output")

        command="slither ${target} --print ${printer}"
        echo
        echo "Running command: ${BOLD}${command}${RESET} &> ${BOLD}${output}${RESET}"
        ${command} &>${output}
        echo
        cat $output
        echo
        echo "Saved in file: ${BOLD}${output}${RESET}"
        echo
    done
    echo The following log files were created:
    for log in ${logs_created[@]}; do
        echo "${BOLD}${log}${RESET}"
    done

}

error() {
    echo 'No target specified'
    echo
    echo 'Usage: slp.sh <target> <output>'
    echo
    echo 'Example: slp.sh ./contracts/ ./output/'
    echo
    exit
}

validateargs() {
    if [ -z "$target" ]; then
        error
    fi

    if [ -z "$selected_logdir" ]; then
        echo 'No output directory specified'
        echo 'Example: slp.sh ./contracts/ ./output/'
        echo 'Using default: ${$default_output}'
        echo ${default_output}
        base_logdir=$default_logdir
    else
        base_logdir=$selected_logdir
    fi
}

main() {
    validateargs
    selectprinters
    process
}

#################################################################################################################################################
# invoke main here:
main
