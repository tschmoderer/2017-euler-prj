# euler-prj

Here a project of the implementation of the euler's equations for gas dynamics : https://en.wikipedia.org/wiki/Euler_equations_(fluid_dynamics) 

The method implemented could be found in this paper : http://www4.ncsu.edu/~acherto/papers/CCKR.pdf (page 4) assuming boundaries don't move. 

Require : 
  - Linux : https://www.ubuntu.com/
  - Octave : https://octave.sourceforge.io/
  - Gnuplot : http://gnuplot.info/
  - ffmpeg : https://ffmpeg.org/
  
The main program is started from the terminal with the command ./euler.bash , after doing the usual chmod +x

If everything went well this script will create all the directory needed for the computation and produce GIF animation of the results. 

You can specify the number of Nodes like this : ./euler.bash N 
By default N=200;

## Description
You will find : 
  - README.md : this file
  - euler.bash : shell script to launch all the computation
  - LICENSE : GNU General License
  - In src/ : all the code I've made
    - f.m
    - main_euler.m
    - minmod.m
    - P0.m
    - qf.m
    - speedofsound.m
  - In results : Gif animation I have already compute for 
  	- Uniform Nodes distribution
     - 100 Nodes
     - 200 Nodes 
     - 300 Nodes
     - 400 Nodes
     - 800 Nodes
     - 1600 Nodes
     - 3200 Nodes 
    - Non Uniform Nodes Distribution 
     - 100 Nodes (equivalent 300 for the uniform case)
     - 200 Nodes (equivalent 600 for the uniform case)
     - 300 Nodes (equivalent 900 for the uniform case)

## Coming Soon 

 - A post processing script that will only process existing data
 - Maybe the routine in C
 - A repport explaining all this work 
 
## Contact 
If you nortice any problem or have any trouble with the program, please feel free to mail me : timothee.schmoderer -at- netcourrier.com . 

## Credits

You can use and reproduce this codes as you like.

This project was made in my fourth year at INSA ROUEN NORMANDIE (FRANCE) in the departement of applied mathematics. 

This project was realize for the University of Cologne as a summer internship 

2017


