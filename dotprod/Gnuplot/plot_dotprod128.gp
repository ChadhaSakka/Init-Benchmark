#!/usr/local/bin/gnuplot -persist

set terminal pngcairo font "georgia,16" fontscale 1.0 size 1200, 600 
set output 'dotprod128.png'

set boxwidth 0.9 absolute
set style fill solid 1.00 border lt -1
set key fixed right top vertical Right nobox
set style histogram clustered gap 1 title textcolor lt -1 
set style data histograms
set grid 

set xtics border in scale 0,0 nomirror rotate by -45  autojustify 
set xtics   ()

set xrange [ 0 : * ] 
set yrange [ * : * ] 

#set multiplot layout 2,2 rowsfirst 
set ylabel " MiB/s"
set xlabel " Different flags with GCC/Clang"

set title 'Mesures Performance Dotprod MBi/s'

plot 'dotprod_128x60_gcc_O1.dat' using 14:xtic(1) ti "gcc : -O1" lc rgb 'grey20','dotprod_128x60_gcc_O2.dat' using 14:xtic(1) ti "-O2" lc rgb 'grey40','dotprod_128x60_gcc_O3.dat' using 14:xtic(1) ti "-O3" lc rgb 'grey60','dotprod_128x60_gcc_Ofast.dat' using 14:xtic(1) ti "-Ofast" lc rgb 'grey','dotprod_128x60_clang_O1.dat' using 14:xtic(1) ti "clang : -O1" lc rgb 'blue','dotprod_128x60_clang_O2.dat' using 14:xtic(1) ti "-O2" lc rgb 'web-blue','dotprod_128x60_clang_O3.dat' using 14:xtic(1) ti "-O3" lc rgb 'dark-turquoise','dotprod_128x60_clang_Ofast.dat' using 14:xtic(1) ti "-Ofast" lc rgb 'skyblue'


replot
#unset multiplot
