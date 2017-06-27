#!/bin/bash
clear 

echo "#########################################################"
echo "#                                                       #"
echo "#                        Welcome                        #"
echo "#   You are about to simulate a gas fluid a a 1D pipe   #"
echo "#     All informations are available in README          #"
echo "#                                                       #"
echo "#                 Timothée Schmoderer                   #"
echo "#                         2017                          #"
echo "#                                                       #"
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

echo "Number of nodes : $N"

# Set framerate
if [ $N -le 100 ]; then 
f=60
elif [ $N -le 200 ]; then 
f=90
elif [ $N -le 300 ]; then 
f=110
elif [ $N -le 400 ]; then 
f=120
elif [ $N -le 800 ]; then 
f=150
elif [ $N -le 1600 ]; then 
f=170
elif [ $N -le 3200 ]; then 
f=200
else 
f=250
fi

echo "Output framerate : $f fps"

# Pre processing 
if [ ! -d Results/Uniform/$N\ Nodes ]; then 
mkdir Results/Uniform/$N\ Nodes
else
rm Results/Uniform/$N\ Nodes/*
fi 


#check if directories exists 
if [ ! -d  img ]; then
mkdir img
fi 
if [ ! -d  data ]; then
mkdir data
fi 
 

for dir in "${directory[@]}"; do 
if [ ! -d img/$dir ]; then 
mkdir img/$dir 
#else
#rm img/$dir/*
fi
if [ ! -d data/$dir ]; then 
mkdir data/$dir
#else
#rm data/$dir/*
fi
done
echo ""
echo "#########################################################"
echo "#                                                       #"
echo "#                Processing main routine                #"
echo "#    This could take several minutes, hours, days ..    #"
echo "#          So please make yourself comfortable          #"
echo "#                                                       #"
echo "#########################################################"
echo ""

# Processing 
cd src	
octave --no-gui --eval "main_euler_uniform($N)" 
cd ..

echo ""
echo "#########################################################"
echo "#                                                       #"
echo "#                  Processing Complete                  #"
echo "#        We will now process the data you compute       #"
echo "#                                                       #"
echo "#########################################################"
echo ""

# All directories have the same number of elements
nbFiles="$(ls data/velocity | grep dat | wc -l)"
# dt is the same for all
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

ffmpeg  -framerate $f -i "img/$dir/%d.png"  Results/Uniform/$N\ Nodes/$dir.gif -y
# Save Memory space : 
rm data/$dir/*
rm img/$dir/*
done

mv data/dt.dat Results/Uniform/$N\ Nodes/
mv img/initial_condition_$N\_Nodes.png Results/Uniform/$N\ Nodes/
mv img/chock_$N\_Nodes.png Results/Uniform/$N\ Nodes/

#tar -zcvf Results/Uniform/$N\ Nodes/data_$N\_Nodes.tar.gz data/
#rm -r data/*
#rm -r img/*

clear

echo ""
echo "#########################################################"
echo "#                                                       #"
echo "#               Post-Processing Complete                #"
echo "#   Results are available in ResultsUniform//N Nodes    #"
echo "#                                                       #"
echo "#########################################################"
echo ""

echo "#########################################################"
echo "#                                                       #"
echo "#                        Bye :)                         #"
echo "#             Thank you for using this script           #"
echo "#     If any probems occured please let me know         #"
echo "#                                                       #"
echo "#                 Timothée Schmoderer                   #"
echo "#         timothee.schmoderer-at-netcourrier.com        #"
echo "#                                                       #"
echo "#             INSA Rouen Normandie - Dpt GM             #"
echo "#                  Universität zu Köln                  #"
echo "#                         2017                          #"
echo "#                                                       #"
echo "#########################################################"
echo ""
