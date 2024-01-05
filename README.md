# CUFSM

This is the GitHub repository for the cross-section elastic buckling analysis tool CUFSM written in MATLAB.

## Description

CUFSM - is the Constrained and Unconstrained Finite Strip Method - and provides elastic buckling for member cross-sections as utilized by structural engineers. The method employs the finite strip method, a variant of the finite element method. The implementation allows for general end boundary conditions through series approximations or provides the signature curve analysis aligned with classical buckling solutions with idealized end conditions.

## Installation

The latest version of the software is available for download on [the latest release page](https://github.com/thinwalled/cufsm-git/releases). The software is provided as both (1) the MATLAB source code and (2) compiled standalone applications. For researchers, students, or anyone with access to MATLAB, it is highly recommended to use the source code directly in MATLAB, this is much more stable and manageable.

Note installation of tha standalone version (PC or Mac) will also require downloading of libraries from Matlab (Mathworks). In addition, be patient at boot up of the standalone version it takes a few moments for the code to load.

Note installation of the matlab app version will place an icon for cufsm in the matlab app toolbar and allow users to use the GUI without knowing underlying file structures etc., Anyone using cufsm for research, or in batch mode, should use the source files. Open cufsm5.m and modify your direectly location of installation and then run cufsm5 from the command line in matlab to start the GUI.

## License

Software is open source and distributed under [MIT license](https://github.com/thinwalled/cufsm-git/blob/main/LICENSE).

## Help and Support

For assistance with the package, please raise an issue on the Github Issues page. Please use the appropriate labels to indicate the specific functionality you are inquiring about.

## Additional Information

The websites [www.ce.jhu.edu/cufsm](www.ce.jhu.edu/cufsm) and [www.ce.jhu.edu/bschafer](www.ce.jhu.edu/bschafer) provide more information on the software.
