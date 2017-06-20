#!/bin/bash
clear 
echo "#########################################################"
echo "#														  #"
echo "#                        Welcome                        #"
echo "#   You are about to simulate a gas fluid a a 1D pipe   #"
echo "#       All informations are available in README 		  #"
echo "#														  #"
echo "#					Timothée Schmoderer 				  #"
echo "#							2017						  #"
echo "#														  #"
echo "#########################################################"

echo ""

# Parameters 

directory[0]=velocity
directory[1]=density
directory[2]=pressure
directory[3]=energy
directory[4]=sound

if [[ ! $1 = +([0-9]) ]] ; then
N=200 # non numérique --> valeur par défaut
else 
N=$1
fi

# Pre processing 


#check if directories exists 
if [ ! -d  "img" ]; then
mkdir img
fi 
if [ ! -d  "data" ]; then
mkdir data
else 
rm data/*.dat
fi 
if [ ! -d  "gif" ]; then
mkdir gif
fi 

for dir in "${directory[@]}"; do 
if [ ! -d "img/$dir" ]; then 
mkdir img/$dir 
else
rm img/$dir/*
fi
if [ ! -d "data/$dir" ]; then 
mkdir data/$dir
else
rm data/$dir/*
fi
done

# Processing 
cd src	
octave --no-gui --eval "main_euler($N)" 

cd ..

# Post Processing
rm gif/*.gif

# All directories have the same number of elements
nbFiles="$(ls data/velocity | grep dat | wc -l)"
# dt is the semae for all
dt="$(echo $(cat data/dt.dat) | awk '{ print sprintf("%.9f",$1); }')"

for dir in "${directory[@]}" ; do 

if [ "$dir" == "velocity" ]; then 
yl="v"
yr=-10:21
titre="Velocity"
fi 
if [ "$dir" == "energy" ]; then 
yl="E"
yr=0:1200
titre="Energy"
fi 
if [ "$dir" == "density" ]; then 
yl="rho"
yr=0:8
titre="Density"
fi 
if [ "$dir" == "pressure" ]; then 
yl="P"
yr=0:450
titre="Pressure"
fi 
if [ "$dir" == "sound" ]; then 
yl="c"
yr=0:40
titre="Speed of Sound"
fi 


rm img/$dir/*.png 
files="$(ls -1v data/$dir)"

echo "Processs $dir data"

for file in $files; do

output="img/$dir/${file/.dat/.png}"
file="data/$dir/$file"

t="${file//[^0-9]/}"
t="$(echo "$dt*$t" | bc)"

gnuplot <<- EOF
    set xlabel "x"
    set ylabel "${yl}"
    set title "${titre} at t = $t s."  
    set yrange [${yr} < * ] 
    set term png
    set output "${output}"
    plot "${file}" using 1:2 notitle
EOF
done
echo "$dir -- Plotting Done"
echo ""
# You should maybe adjust the framerate in case of your choice of number of nodes
# 60 for 100 
# 120 is ok from 200 to 400
# 150 for 800 ?
# 170 for 1600 ?
ffmpeg  -framerate 120 -i "img/$dir/%d.png"  gif/$dir.gif -y
done

echo ""
echo "Thank you for using this script"
echo ""
