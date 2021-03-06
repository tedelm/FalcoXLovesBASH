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
        echo "-- ESC Settings ---"
        echo "ESC Proto: $(Get-FalcoXESCMapping ${FalcoXSettings[esc_protocol]})"
        echo "-----------------"
    #VTX
        echo "-- VTX Settings ---"
        echo "VTX Channel: $(Get-FalcoXVTXMapping ${FalcoXSettings[vtx_protocol]};echo $VTXCh)"
        echo "VTX Freq: $(Get-FalcoXVTXMapping ${FalcoXSettings[vtx_protocol]};echo $VTXFreq)"
        echo "-----------------"
       

}

#Get-FalcoXLocalConfig miniSquad_4inch_4s_falcoX_Alpha_v0.10.txt


Get-FalcoXLocalHTMLReport () {
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
            if [ ${FalcoXSettings[use_dyn_aa]} = 1 ]; then
                DynamicAAEnabled="True"
            else
                DynamicAAEnabled="False"
            fi


    #Create HTML
    echo "
    <html>
    <head>
    <title>FalcoXHtmlReport</title>
    <style>
    table.default {
    font-family: Arial, Helvetica, sans-serif;
    border-collapse: collapse;
    border: 1px solid black;
    }
    th.th_headline {
    font-family: Arial, Helvetica, sans-serif;
    font-size: 15px;
    font-weight: bold;
    }
    td.td_headline {
    font-family: Arial, Helvetica, sans-serif;
    font-size: 15px;
    font-weight: bold;
    }
    td {
    font-family: Arial, Helvetica, sans-serif;
    font-size: 15px;
    border: 1px solid black;
    }
    </style>
    </head>
    <body>
    <table class= 'Default'>
        <tr>
            <th>$VersionOutput</th><th></th><th></th><th>ROLL</th><th>PITCH</th><th>YAW</th><th>TPA</th><th>P</th><th>I</th><th>D</th>
        </tr>      
        <tr>
            <td class= 'td_headline'>FILT1</td><td>$(Get-FalcoXFilter ${FalcoXSettings[filt1_type]})</td><td class= 'td_headline' align='center'>P</td><td>${FalcoXSettings[roll_p]}</td><td>${FalcoXSettings[pitch_p]}</td><td>${FalcoXSettings[yaw_p]}</td><td>0%</td><td>${FalcoXSettings[p_curve0]}</td><td>${FalcoXSettings[i_curve0]}</td><td>${FalcoXSettings[d_curve0]}</td>
        </tr>
        <tr>
            <td class= 'td_headline'>FILT2</td><td>$(Get-FalcoXFilter ${FalcoXSettings[filt2_type]})</td><td class= 'td_headline' align='center'>I</td><td>${FalcoXSettings[roll_i]}</td><td>${FalcoXSettings[pitch_i]}</td><td>${FalcoXSettings[yaw_i]}</td><td>10%</td><td>${FalcoXSettings[p_curve1]}</td><td>${FalcoXSettings[i_curve1]}</td><td>${FalcoXSettings[d_curve1]}</td>
        </tr>
        <tr>
            <td class= 'td_headline'>DFILT1</td><td>$(Get-FalcoXFilter ${FalcoXSettings[dfilt1_type]})</td><td class= 'td_headline' align='center'>D</td><td>${FalcoXSettings[roll_d]}</td><td>${FalcoXSettings[pitch_d]}</td><td>${FalcoXSettings[yaw_d]}</td><td>20%</td><td>${FalcoXSettings[p_curve2]}</td><td>${FalcoXSettings[i_curve2]}</td><td>${FalcoXSettings[d_curve2]}</td>
        </tr>
        <tr>
            <td class= 'td_headline'>DFILT2</td><td>$(Get-FalcoXFilter ${FalcoXSettings[dfilt2_type]})</td><td></td><td></td><td></td><td></td><td>30%</td><td>${FalcoXSettings[p_curve3]}</td><td>${FalcoXSettings[i_curve3]}</td><td>${FalcoXSettings[d_curve3]}</td>
        </tr>
        <tr>
            <td class= 'td_headline'>FILT1 (Hz)</td><td>${FalcoXSettings[filt1_freq]}</td><td class= 'td_headline'>SIM</td><td>$SimmodeEnabled</td><td></td><td></td><td>40%</td><td>${FalcoXSettings[p_curve4]}</td><td>${FalcoXSettings[i_curve4]}</td><td>${FalcoXSettings[d_curve4]}</td>
        </tr>
        <tr>
            <td class= 'td_headline'>FILT2 (Hz)</td><td>${FalcoXSettings[filt2_freq]}</td><td class= 'td_headline'>SIM BOOST</td><td>${FalcoXSettings[sim_boost]}</td><td></td><td></td><td>50%</td><td>${FalcoXSettings[p_curve5]}</td><td>${FalcoXSettings[i_curve5]}</td><td>${FalcoXSettings[d_curve5]}</td>
        </tr>
        <tr>
            <td class= 'td_headline'>DFILT1 (Hz)</td><td>${FalcoXSettings[dfilt1_freq]}</td><td class= 'td_headline'>WHISPER</td><td>$WhisperEnabled</td><td></td><td></td><td>60%</td><td>${FalcoXSettings[p_curve6]}</td><td>${FalcoXSettings[i_curve6]}</td><td>${FalcoXSettings[d_curve6]}</td>
        </tr>
        <tr>
            <td class= 'td_headline'>DFILT2 (Hz)</td><td>${FalcoXSettings[dfilt2_freq]}</td><td class= 'td_headline'>CG COMP</td><td>${FalcoXSettings[cg_comp]}</td><td></td><td></td><td>70%</td><td>${FalcoXSettings[p_curve7]}</td><td>${FalcoXSettings[i_curve7]}</td><td>${FalcoXSettings[d_curve7]}</td>
        </tr>
        <tr>
            <td class= 'td_headline'>DYNAMIC AA</td><td>$DynamicAAEnabled</td><td class= 'td_headline'>SMOOTH STOP</td><td>${FalcoXSettings[smooth_stop]}</td><td></td><td></td><td>80%</td><td>${FalcoXSettings[p_curve8]}</td><td>${FalcoXSettings[i_curve8]}</td><td>${FalcoXSettings[d_curve8]}</td>
        </tr>
        <tr>
            <td class= 'td_headline'>AA STRENGTH</td><td>${FalcoXSettings[aa_strength]}</td><td class= 'td_headline'>Idle %</td><td>${FalcoXSettings[idle_percent]}</td><td></td><td></td><td>90%</td><td>${FalcoXSettings[p_curve9]}</td><td>${FalcoXSettings[i_curve9]}</td><td>${FalcoXSettings[d_curve9]}</td>
        </tr>		
        <tr>
            <td class= 'td_headline'>DYNAMIC FILT STRENGTH</td><td>${FalcoXSettings[dynLpfScale]}</td><td class= 'td_headline'>ESC proto</td><td>$(Get-FalcoXESCMapping ${FalcoXSettings[esc_protocol]})</td><td></td><td></td><td>100%</td><td>${FalcoXSettings[p_curve10]}</td><td>${FalcoXSettings[i_curve10]}</td><td>${FalcoXSettings[d_curve10]}</td>
        </tr>       			
    </table>" > FalcoXHTMLReport.html

    echo "Report exported to FalcoXHTMLReport.html"
    #xdg-open FalcoXHTMLReport.html
}







#FilterMapping
Get-FalcoXFilter () {

    case "$1" in
    1) filtername=BiQuad;;
    2) filtername=Freq;;
    3) filtername=Dynamic;;
    esac
echo $filtername
}

#ESC Mapping
Get-FalcoXESCMapping () {

    case "$1" in
    0) ESCProto=MULTISHOT;;
    1) ESCProto=DSHOT64;;
    2) ESCProto=DSHOT32;;
    3) ESCProto=DSHOT1200;;
    4) ESCProto=DSHOT600;;
    5) ESCProto=DSHOT300;;
    6) ESCProto=PROSHOT32;;
    7) ESCProto=PROSHOT16;;
    esac
echo $ESCProto
}

#VTX Mapping
Get-FalcoXVTXMapping () {

    case "$1" in
    0) VTXCh=A1 VTXFreq=5865;;
    1) VTXCh=A2 VTXFreq=5845;;
    2) VTXCh=A3 VTXFreq=5825;;
    3) VTXCh=A4 VTXFreq=5805;;
    4) VTXCh=A5 VTXFreq=5785;;
    5) VTXCh=A6 VTXFreq=5765;;
    6) VTXCh=A7 VTXFreq=5745;;
    7) VTXCh=A8 VTXFreq=5725;;
    #Boscam B
    8) VTXCh=B1 VTXFreq=5733;;
    9) VTXCh=B2 VTXFreq=5752;;
    10) VTXCh=B3 VTXFreq=5771;;
    11) VTXCh=B4 VTXFreq=5790;;
    12) VTXCh=B5 VTXFreq=5809;;
    13) VTXCh=B6 VTXFreq=5828;;
    14) VTXCh=B7 VTXFreq=5847;;
    15) VTXCh=B8 VTXFreq=5866;;
    #Boscam E
    16) VTXCh=E1 VTXFreq=5705;;
    17) VTXCh=E2 VTXFreq=5685;;
    18) VTXCh=E3 VTXFreq=5665;;
    19) VTXCh=E4 VTXFreq=5645;;
    20) VTXCh=E5 VTXFreq=5885;;
    21) VTXCh=E6 VTXFreq=5905;;
    22) VTXCh=E7 VTXFreq=5925;;
    23) VTXCh=E8 VTXFreq=5945;;
    #Fatshark
    24) VTXCh=F1 VTXFreq=5740;;
    25) VTXCh=F2 VTXFreq=5760;;
    26) VTXCh=F3 VTXFreq=5780;;
    27) VTXCh=F4 VTXFreq=5800;;
    28) VTXCh=F5 VTXFreq=5820;;
    29) VTXCh=F6 VTXFreq=5840;;
    30) VTXCh=F7 VTXFreq=5860;;
    31) VTXCh=F8 VTXFreq=5880;;
    #Raceband R
    32) VTXCh=R1 VTXFreq=5658;;
    33) VTXCh=R2 VTXFreq=5695;;
    34) VTXCh=R3 VTXFreq=5732;;
    35) VTXCh=R4 VTXFreq=5769;;
    36) VTXCh=R5 VTXFreq=5806;;
    37) VTXCh=R6 VTXFreq=5843;;
    38) VTXCh=R7 VTXFreq=5880;;
    39) VTXCh=R8 VTXFreq=5917;;
    #Lowband
    40) VTXCh=L1 VTXFreq=5732;;
    41) VTXCh=L2 VTXFreq=5765;;
    42) VTXCh=L3 VTXFreq=5828;;
    43) VTXCh=L4 VTXFreq=5840;;
    44) VTXCh=L5 VTXFreq=5866;;
    45) VTXCh=L6 VTXFreq=5740;;
    46) VTXCh=L7 VTXFreq=0;;
    47) VTXCh=L8 VTXFreq=0;;
    esac
#echo $VTXCh
#echo $VTXFreq
}


#Get-FalcoXLocalConfig miniSquad_4inch_4s_falcoX_Alpha_v0.10.txt

