# euler-prj

Here a project of the implementation of the euler's equations for gas dynamics : https://en.wikipedia.org/wiki/Euler_equations_(fluid_dynamics) 

The method implemented could be found in this paper : http://www4.ncsu.edu/~acherto/papers/CCKR.pdf (page 4) assuming boundaries don't move. 

Require : 
  - Linux : https://www.ubuntu.com/
  - Octave : https://octave.sourceforge.io/
  - Gnuplot : http://gnuplot.info/
  - ffmpeg : https://ffmpeg.org/

## Description
You will find : 
  - README.md : this file
  - LICENSE : GNU General License
  - In src/ : all the code I've made
    - boundary.m :  management of different boundary conditions
    - construct_nodes : function to construct the mesh in the case of non uniform nodes distribution
    - f.m : compute the flux function
    - initial.m : set all initial value 
    - main_euler_non_uniform : main routine for non uniform meshes
    - main_euler_uniform : main routine for uniform meshes
    - main_euler_uniform_error.m : main routine to check rate of convergence of teh method
    - main_euler_uniform_gui : main routine for uniform meshes with GUI visualization
    - minmod.m : compute the minmod function
    - qf_non_uniform.m : function to compute the second member for non uniform meshes
    - qf_uniform.m : function to compute the second member for uniform meshes
    - rhoEx.m : compute the analytic solution for the main_euler_uniform_error
    - source.m compute the source term for the main_euler_uniform_error
    - speedofsound.m : compute the speed of sound in the domain 
    - test.m : a test routine for a 2D result
    
  - In Results/ : All results I have already compute for you 
  	- Non Uniform/ 
      - Coming soon
     - Uniform/ : results compute on regular meshes 
      The structure is the following : 
        - Case/ : case tested could take value in [Blast, Lax,Sedov,Sedov 3D,Shu-Osher,Sod,Toro]
          - N Nodes/ 
            - data/ : archive of the data computed
            - img/ : archive of the image computed with gnuplot
            - initial/ : images of the initial conditions 
            - shock/ : images at the shock time (or any interesting time)
            - *.gif : GIF animation for all quantities we are interested in
            - *.mp4 : same animation but in mp4 format 
            
   - In Report/ : some text to explain this work
     - analysis of the method.pdf : a summary of the next file 
     - main.pdf : the full report of this work
   - euler_non_uniform.bash : a script t make computation in teh non uniform case
   -euler_uniform_all.bash : a script to make all the simulation I computed in one shot, better be sure before launching blindly this programm.

 ## How to run 
 It depends what do you want to do : 
 1. I *strongly* recommand to read at least the Report/analysis of the method.pdf file before you launch the method.
 2. I suggests you begin with launching main_euler_uniform_gui.m with octave (Lanching with matlab is possible but you might have to do some minor changes in the code), in order to get familiar with the cases and the method. 
 3. If you want to launch all the simulation (might take a long time and use a lot of you computer ressources) lauch euler_uniform_all.bash from the consol. 
 
## Coming Soon 
 - The routine for non uniform meshes 
 - Maybe the routine in C
 
## Contact 
If you notice any problem or have any trouble with the program, please feel free to mail me : timothee.schmoderer -at- netcourrier.com . 

## Credits

<p align="center">
You can use and reproduce this codes as you like.<br>
This project was made in my fourth year at INSA ROUEN NORMANDIE (FRANCE) in the departement of applied mathematics. <br>
This project was realize for the University of Cologne as a summer internship <br>
2017
</p>
