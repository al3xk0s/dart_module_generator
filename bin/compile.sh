#!/usr/bin/bash

function main() {
    local targetName="dart_module_generator"
    local targetFile="./module_generator.dart"
    local exeFile="module_generator.exe"
    
    dart compile exe "$targetFile" && \
        mv "$exeFile" "$targetName"

}

main "${@}"