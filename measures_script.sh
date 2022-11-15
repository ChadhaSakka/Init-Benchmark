#!/bin/bash

#etape0:
read -p "Enter the number of array elements [n]= " n
read -p "Enter the number of kernel repetitions [r]= " r
read -p "Enter the compiler name [gcc/clang]= " cc
 
for dir in "reduc" "dgemm" "dotprod"
do
#Etape1: modification du Makefile pour tester plusieurs flags sur le compilateur specifié
for flags in "O0" "O1" "O2" "O3" "Ofast"
do
cd "$dir"
echo "$dir" "$flags :"
make clean
sed -i "/OFLAGS=/c\OFLAGS=-$flags" Makefile
sed -i "/CC=/c\CC=$cc" Makefile										
make
cd ..
done
done
#Etape2: Récolte des mesures de performances
for dir in "reduc" "dgemm" "dotprod"
do 
for flags in "O0" "O1" "O2" "O3" "Ofast"
do
cd "$dir"
if [ -e "$dir"_"$n"x"$r"_"$cc"_"$flags".dat ]; then
rm "$dir"_"$n"x"$r"_"$cc"_"$flags".dat;
fi

#Exécution sur Linux comme systeme d'exploitataion principal
sudo cpupower -c all frequency-set -g performance
sudo taskset -c 1 ./$dir "$n" "$r" | awk '{gsub(/;/,"")}1' >> "$dir"_"$n"x"$r"_"$cc"_"$flags".dat

#Exécution sur VM
#./"$dir" "$n" "$r" | awk '{gsub(/;/,"")}1' >> "$dir"_"$n"x"$r"_"$cc"_"$flags".dat

#Etape4: suppression de l'espace entre les parenthèses de la colonne stddev
sed -i "s/( /(/g"  "$dir"_"$n"x"$r"_"$cc"_"$flags".dat

#Etape5: Creation des dossiers pour organiser les fichiers de perf générés
if [ -d "$dir"_"$n"x"$r"_"$cc"_"$flags" ]; then
rm -d -r "$dir"_"$n"x"$r"_"$cc"_"$flags"; 												
fi												
mkdir "$dir"_"$n"x"$r"_"$cc"_"$flags"

#Etape6: Séparation des données 
nb=$( wc -l < "$dir"_"$n"x"$r"_"$cc"_"$flags".dat )
aux=$( echo "$nb"| bc )
for ((i=1;i<aux;i++));
do
if [ -e "$dir"_"$i"_"$cc"_"$flags".dat ]; then
rm "$dir"_"$i"_"$cc"_"$flags".dat; 												
fi
#Etape7: Creation d'un dossier $i pour contenir les mesures pour chaque version $i dans kernels.c
mkdir -p "$i"	 											
echo "$(head -n 1 "$dir"_"$n"x"$r"_"$cc"_"$flags".dat)"  >> "$i"_"$dir"_"$n"x"$r"_"$cc"_"$flags".dat 						
echo "$(tail -n"$i" "$dir"_"$n"x"$r"_"$cc"_"$flags".dat | head -n 1)" | awk '{gsub(/;/,"")}1' >> "$i"_"$dir"_"$n"x"$r"_"$cc"_"$flags".dat
#Etape8: Organisation par compilateur/-flags d'optimisation	
cp "$i"_"$dir"_"$n"x"$r"_"$cc"_"$flags".dat ./"$dir"_"$n"x"$r"_"$cc"_"$flags"

#Etape9: Organisation par version
mv -u "$i"_"$dir"_"$n"x"$r"_"$cc"_"$flags".dat ./"$i"
done

cd ..
done

done


