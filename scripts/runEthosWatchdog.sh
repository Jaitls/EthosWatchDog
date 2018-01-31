#!/bin/bash

#load files:
# -- application configurations
source ../config/appcontrol.conf
# -- helper functions for logging and error handling
source ./programfunctions.sh

main() {

	#1:setup log
	initLogging
	
    #2:log script start
	log "Starting script $0"
    
    #convert script files
    #convertFilesToUnix ../scripts
    
    #3:get hostnames of mining rigs
    getRigHostnames
    
    #4:get hashrates of mining rigs
    getRigStats
}

#call main function
main $*

# check final return code and exit accordingly
case $? in
    0)
        log "Script ended without critical errors"
        ;;
    *)
        errorExit "ERROR: uncaught error; final return code was non zero"
        ;;
esac