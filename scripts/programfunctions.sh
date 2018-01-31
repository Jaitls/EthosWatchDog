#!/bin/bash

#helper functions / general utilities; e.g., logging and error handling

initLogging() {  
    #initializes logging file
    local TMP=$(tail -n $LOG_MAX_LINES $LOGFILE 2>/dev/null) && echo "${TMP}" > $LOGFILE
    exec > >(tee -a $LOGFILE)
    exec 2>&1
}

log() {  
    echo "[$(date --rfc-3339=seconds)]: $*" >> $LOGFILE
}

convertFilesToUnix(){
    for file in $(find -L "$1" -type f)
    do 
      vi +':w ++ff=unix' +':q' ${file}
    done
}

rmFileIfExists() {
    #remove local file if already exists
    if [ -f $1 ] ; then
        rm $1
    fi
}

errorExit() {
    log "$1"
    log "ERROR: Script exited on error"
    exit 1
}

#main functions
getRigStats() {
    for rig in $(echo $RIGS | tr ',' '\n')
    do
        ssh ethos@$rig '/opt/ethos/bin/show stats | grep -w miner_hashes' > ../tmp/${rig}_hash
    done
}

getRigHostnames() {
    for rig in $(echo $RIGS | tr ',' '\n')
    do
        ssh ethos@$rig 'hostname' > ../tmp/${rig}_hostname
    done
}