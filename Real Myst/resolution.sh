#!/bin/bash

#9a99 193e 0000 0000 8007 0000 3804 0000 2000 = resolution 1920 x 1080 x 32 bits
#9a99 193e 0000 0000 8007 0000 3804 0000 1000 = resolution 1920 x 1080 x 16 bits
#9a99 193e 0000 0000 9006 0000 1a04 0000 2000 = resolution 1650 x 1080 x 32 bits
#9a99 193e 0000 0000 9006 0000 1a04 0000 1000 = resolution 1650 x 1080 x 16 bits

#1920 dec = 0780 hex = reverse it and get 8007
#1080 dec = 0438 hex = reverse it and get 3804
#1680 dec = 0690 hex = reverse it and get 9006
#1050 dec = 041a hex = reverse it and get 1a04

#2000 = 32 bits
#1000 = 16 bits

w=$1
h=$2

# conversion de la resolution en hexa

wb=$(echo 'obase=16;' $w | bc)
hb=$(echo 'obase=16;' $h | bc)

#calcul du nombre de caractères des résultats hexa

echo $w en hexa: $wb soit ${#wb} caractères
echo $h en hexa: $hb soit ${#hb} caractères

#la resolution hexa doit être égal à 4 caractères, ajout de 0 si besoin

if [ ${#wb} = "1" ]; then wb="000$wb"
elif [ ${#wb} = "2" ]; then wb="00$wb"
elif [ ${#wb} = "3" ]; then wb="0$wb"
fi

echo wb est à présent égal à $wb

if [ ${#hb} = "1" ]; then hb="000$hb"
elif [ ${#hb} = "2" ]; then hb="00$hb"
elif [ ${#hb} = "3" ]; then hb="0$hb"
fi

echo hb est à présent égal à $hb

#découpage de la résolution en hexa par 2x2 chiffres

wb1=$(echo $wb |cut -c1-2)
wb2=$(echo $wb |cut -c3-4)
hb1=$(echo $hb |cut -c1-2)
hb2=$(echo $hb |cut -c3-4)

#echo "Maintenant il faut remplacer "9a99 193e 0000 0000 .... 0000 .... 0000 .000" par "9a99 193e 0000 0000 $wb2 $wb1 0000 $hb2 $hb1 0000 2000"
#sed -i 's/\x9a\x99\x19\x3e\x00\x00\x00\x00\x..\x..\x00\x00\x..\x..\x00\x00\x.0\x00/\x9a\x99\x19\x3e\x00\x00\x00\x00\x80\x07\x00\x00\x38\x04\x00\x00\x20\x00/g'
#	    9a  99  19  3e  00  00  00  00  80  07  00  00  38  04  00  00  20  00   9a  99  19  3e  00  00  00  00  80  07  00  00  38  04  00  00  20  00
#sed -i 's/9a99 193e 0000 0000 .... 0000 .... 0000/9a99 193e 0000 0000 8002 0000 e001 0000/g' dev_mode.dat.hex

#sed -e 's/\x80\x02\x00\x00\xE0\x01/\x'$wb2'\x'$wb1'\x00\x00\x'$hb2'\x'$hb1'/g' dev_mode.dat
xxd dev_mode.dat > dev_mode.dat.hex
sed -i 's/9a99 193e 0000 0000 .... 0000 .... 0000/9a99 193e 0000 0000 '$wb1''$wb2' 0000 '$hb1''$hb2' 0000/g' dev_mode.dat.hex
sed -i 's/.000 0000 6400/2000 0000 6400/g' dev_mode.dat.hex
#sed -e 's/\x80\x02\x00\x00\xE0\x01/\x'$wb2'\x'$wb1'\x00\x00\x'$hb2'\x'$hb1'/g' dev_mode.dat
xxd -r dev_mode.dat.hex > dev_mode.dat