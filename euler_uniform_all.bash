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
directory[5]=mach

#trial[0]=sod
#trial[1]=blast
trial[0]=shu
trial[1]=toro
trial[2]=lax
trial[3]=sedov
#trial[6]=sedov3D

#dirResults[0]=Sod
#dirResults[1]=Blast
dirResults[0]=Shu-Osher
dirResults[1]=Toro
dirResults[2]=Lax
dirResults[3]=Sedov
#dirResults[6]="Sedov 3D"

#Nodes[0]=100
#Nodes[1]=200
#Nodes[2]=400
#Nodes[3]=800
#Nodes[4]=1600
#Nodes[5]=3200
Nodes[6]=6400


k=0
for essay in "${trial[@]}"; do 
outputDir=Results/Uniform/"${dirResults[$k]}"
if [ ! -d  "${outputDir}" ]; then 
mkdir "${outputDir}"
fi 
for N in "${Nodes[@]}"; do 

echo "Number of nodes : $N"
# Pre processing 
# Check for all directories to be ready 

output=${outputDir}/$N\ Nodes

if [ ! -d  "${output}" ]; then 
mkdir "${output}"
else 
rm -r "${output}"/*
fi 


mkdir "${output}"/img
mkdir "${output}"/data
mkdir "${output}"/initial
mkdir "${output}"/shock

for dir2 in "${directory[@]}"; do 
mkdir "${output}"/img/"${dir2}"
mkdir "${output}"/data/"${dir2}"
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
octave --no-gui --eval "main_euler_uniform($N,'${essay}')" 
cd ..

echo ""
echo "#########################################################"
echo "#                                                       #"
echo "#                  Processing Complete                  #"
echo "#        We will now process the data you compute       #"
echo "#                                                       #"
echo "#########################################################"
echo ""

# Post Processing
# same numer of line in time.dat as number in file


mesh="${output}"/data/mesh.dat

for dir in "${directory[@]}" ; do 
files="$(ls -1v "${output}"/data/"${dir}")"
i=1

if [ "$dir" == "velocity" ]; then 
yl="v"
titre="Velocity"
fi 
if [ "$dir" == "energy" ]; then 
yl="E"
titre="Energy"
fi 
if [ "$dir" == "density" ]; then 
yl="rho"
titre="Density"
fi 
if [ "$dir" == "pressure" ]; then 
yl="P"
titre="Pressure"
fi 
if [ "$dir" == "sound" ]; then 
yl="c"
titre="Speed of Sound"
fi 
if [ "$dir" == "mach" ]; then 
yl="M"
titre="Mach number"
fi 

for file in $files; do 
postFile=""${output}"/img/$dir/${file/.dat/.png}"
file=""${output}"/data/$dir/${file}"
time=$(sed -n "${i} p" < "${output}"/data/time.dat)

gnuplot <<- EOF
    set xlabel "x"
    set ylabel "${yl}"
    set title "${titre} at t = ${time} s."   
    set term png
    set output "${postFile}"
    plot '< paste "${mesh}" "${file}"' using 1:2 notitle
EOF
((i++))
done


echo "$dir -- Plotting Done"
echo ""

ffmpeg  -framerate 150 -i "${output}/img/${dir}/%d.png"  "${output}"/"${dir}".mp4 -y
#ffmpeg  -framerate 50 -i "${output}/img/${dir}/%d.png"  "${output}"/"${dir}".gif -y

# Save Memory space : 
#tar -zcvf "${output}"/data/$dir.tar.gz --directory="${output}"/data/$dir .
#tar -zcvf "${output}"/img/$dir.tar.gz --directory="${output}"/img/$dir .
rm -r "${output}"/data/$dir
rm -r "${output}"/img/$dir
done 

mv "${output}"/data/time.dat "${output}"
mv "${output}"/data/mesh.dat "${output}"

echo ""
echo "#########################################################"
echo "#                                                       #"
echo "#               Post-Processing Complete                #"
echo "#       Results are available in Results/Uniform/       #"
echo "#                                                       #"
echo "#########################################################"
echo ""

done
((k++))
done

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

