#!/bin/bash

# The first argument is the path to the jar file.

JAR="$1"

# Check if java is installed
if [[ ! -f /Library/Java/JavaVirtualMachines/jdk-18.0.1.1.jdk/Contents/Home/bin/java ]]; then   # Java is not installed

    value=$(osascript -e 'display dialog "It seems Java is not installed on your Mac. Would you install it? (OpenJDK 18.0.1.1, ≈320MB)" buttons {"Yes", "No"}')
    if [[ $value == "button returned:No" ]]; then
        exit 9
    fi

    # Install OpenJDK 18.0.1.1
    if [[ -z "$(uname -a | grep "X86_64")" ]]; then       # aarch64 system
        curl -L --progress-bar "https://download.java.net/java/GA/jdk18.0.1.1/65ae32619e2f40f3a9af3af1851d6e19/2/GPL/openjdk-18.0.1.1_macos-aarch64_bin.tar.gz" -o "/tmp/openjdk.tar.gz"
    else                                                  # x86_64 system
        curl -L --progress-bar "https://download.java.net/java/GA/jdk18.0.1.1/65ae32619e2f40f3a9af3af1851d6e19/2/GPL/openjdk-18.0.1.1_macos-x64_bin.tar.gz" -o "/tmp/openjdk.tar.gz"        
    fi


    # Untar the file
    mkdir -p "/tmp/jdk-18.0.1.1.jdk"
    tar -xzf "/tmp/openjdk.tar.gz" --directory "/tmp/jdk-18.0.1.1.jdk"

    # Move the JDK to /Library/Java/JavaVirtualMachines/ using sudo permission
    osascript -e 'do shell script "mv /tmp/jdk-18.0.1.1.jdk/jdk-18.0.1.1.jdk /Library/Java/JavaVirtualMachines/jdk-18.0.1.1.jdk" with administrator privileges'
fi


# Launch Jar
if [[ -z "$1" ]]; then
    /Library/Java/JavaVirtualMachines/jdk-18.0.1.1.jdk/Contents/Home/bin/java -jar --enable-preview ./main.jar
else
    /Library/Java/JavaVirtualMachines/jdk-18.0.1.1.jdk/Contents/Home/bin/java -jar --enable-preview "$JAR" "$[@:2]"
fi
