

TextParse="$(cat miniSquad_4inch_4s_falcoX_Alpha_v0.10.txt | tr -d SET | tr -d ][ | tr -d \",\")"

IFS='"," ' # space is set as delimiter
read -ra ADDR <<< "$TextParse" # str is read into an array as tokens separated by IFS
#echo ${ADDR[@]}

arr=( "1" "2" )

for i in "${ADDR[@]}"; do # access each element of array
    echo "$i"
    arr+=( "${i[0]}" )
done



