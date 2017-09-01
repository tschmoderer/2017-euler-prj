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
    - f.m : compute the flux function
    - initial.m : set all initial value 
    - lglnodes.m : procedure to compute the LGL non uniform mesh
    - main_euler : main routine
    - main_euler_error.m : main routine to check rate of convergence of teh method
    - minmod.m : compute the minmod function
    - qf.m : function to compute the second member of the method
    - qf_weno.m : compute the second memeber for the WENO method
    - rhoEx.m : compute the analytic solution for the main_euler_error
    - source.m compute the source term for the main_euler_uniform_error
    - speedofsound.m : compute the speed of sound in the domain 
    - weno.m : A WENO-5 method to compute reference solutions
    - weno_error.m : a procedure to check the WENO rate of convergence
    
  - In Results/ : All results I have already compute for you 
    - Error/
      - Case 1 or 2/error in norms 1,2 or infinity on uniform and non uniform mesh
      - WENO/error analysis for the weno method
      
     - Uniform/ : results compute on regular meshes 
      The structure is the following : 
        - Case/ : case tested could take value in [Blast, Lax,Sedov, Shu-Osher,Sod,Toro]
          - N Nodes/ 
            - initial/ : images of the initial conditions 
            - shock/ : images at the shock time (or any interesting time)
            - *.gif : GIF animation for all quantities we are interested in
            - *.mp4 : same animation but in mp4 format 
            
   - In Report/ : some text to explain this work
     - analysis of the method.pdf : a summary of the next file 
     - main.pdf : the full report of this work

 ## How to run 
 It depends what do you want to do : 
 1. I *strongly* recommand to read at least the Report/analysis of the method.pdf file before you launch the method.
 2. I suggests you begin with launching main_euler.m with octave (Lanching with matlab is possible but you might have to do some minor changes in the code), in order to get familiar with the cases and the method. 
 3. Then you can adapt the procedure to your case by modifying the initial conditions function
 
## Coming Soon 
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
