#!/bin/bash



Get-FalcoXLocalConfig () {
    falcoxDump="${1}" # $1 represent first argument
    value2="${2}" # $2 represent second argument

    TextParse="$(cat $falcoxDump | tr -d SET | tr -d ][ | tr -d \",\")"

    IFS='"," ' #split string
    read -ra ADDR <<< "$TextParse" # str is read into an array as tokens separated by IFS

    #Create key/value hash
    declare -A FalcoXSettings

    for i in "${ADDR[@]}"; do # access each element of array
        #echo "$i"

        IFS='=' #split string
        read -ra FalcoXSetting <<< "$i"

        FalcoXSettings+=( ["${FalcoXSetting[0]}"]="${FalcoXSetting[1]}" )
    done


    #PIDs
        echo "-- PIDs ---"
        echo "       P     I     D "
        echo "Roll:  ${FalcoXSettings[roll_p]},  ${FalcoXSettings[roll_i]},  ${FalcoXSettings[roll_d]}"
        echo "Pitch: ${FalcoXSettings[pitch_p]},  ${FalcoXSettings[pitch_i]},  ${FalcoXSettings[pitch_d]}"
        echo "Yaw:   ${FalcoXSettings[yaw_p]},  ${FalcoXSettings[yaw_i]},  ${FalcoXSettings[yaw_d]}"

            if [ ${FalcoXSettings[use_simmode]} = 1 ]; then
                SimmodeEnabled="True"
            else
                SimmodeEnabled="False"
            fi
            if [ ${FalcoXSettings[use_whisper]} = 1 ]; then
                WhisperEnabled="True"
            else
                WhisperEnabled="False"
            fi

        echo "-- PID Controller --"
        echo "Sim mode: $SimmodeEnabled"
        echo "Sim Boost: ${FalcoXSettings[sim_boost]}"
        echo "Whisper: $WhisperEnabled"
        echo "-----------------"

    #Filters
        echo "----- Gyro -----"
        echo "Filter1: $(Get-FalcoXFilter ${FalcoXSettings[filt1_type]}) @ ${FalcoXSettings[filt1_freq]} Hz"
        echo "Filter2: $(Get-FalcoXFilter ${FalcoXSettings[filt2_type]}) @ ${FalcoXSettings[filt2_freq]} Hz"
        echo "Dynamic filter Strenght: ${FalcoXSettings[dynLpfcale]}"

        echo "----- D-Term -----"
        echo "Filter1: $(Get-FalcoXFilter ${FalcoXSettings[dfilt1_type]}) @ ${FalcoXSettings[dfilt1_freq]} Hz"
        echo "Filter2: $(Get-FalcoXFilter ${FalcoXSettings[dfilt2_type]}) @ ${FalcoXSettings[dfilt2_freq]} Hz"

            if [ ${FalcoXSettings[use_dyn_aa]} = 1 ]; then
                DynamicAAEnabled="True"
            else
                DynamicAAEnabled="False"
            fi
        echo "-- Dynamic AA ---"
        echo "Dynamic AA Enabled: $DynamicAAEnabled"
        echo "Dynamic AA Strength: ${FalcoXSettings[aa_strength]}"
        echo "-----------------"

}

#Get-FalcoXLocalConfig miniSquad_4inch_4s_falcoX_Alpha_v0.10.txt

#FilterMapping
Get-FalcoXFilter () {

    case "$1" in

    1) filtername=BiQuad
        ;;
    2) filtername=Freq
        ;;
    3) filtername=Dynamic
        ;;
    esac
echo $filtername
}



#Get-FalcoXLocalConfig miniSquad_4inch_4s_falcoX_Alpha_v0.10.txt

