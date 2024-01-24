# News

## Version 5.20 - 01/24/2024

- Several big fixes to plastic surface builder.
- Further improved Sheng Jin's 3D plotting code and made default.
- Added optional vectorized analysis for improved performance on large problems.
- Added examples and batchcufsm5 code, for non-GUI based use of CUFSM.
- Miscellaneous Github best practice cleanups with files.

## Version 5.06 - 01/02/2024

- Moved management to GitHub for the code.
- Merged in Sheng Jin's 3D plotting code.

## Version 5.05 - 12/28/2023

- Cleanups for R2023b.
- Critically, `strip.m` renamed to `stripmain.m` because `strip` has become reserved word - source of lots of user problems.
- Also removed the waitbar from analysis, seemed to cause more problems and hung windows, possibly related to `strip.m `issue but removed.
- Some functionality removed: `holehelper()`, `abaqus_me()`, and MASTAN in/out. Will separate into their own tools, or bring back in the future version.
- Changed CUTWP to use global variables instead of load and save, this should now work in compiled versions bringing back this functionality to those users.

## Version 5.04+ - 07/07/2023

- Fixed eigs call in `strip()` which throws an error in R2022.

## Version 5.04+ - 07/08/2021

- Fixed bug on plastic surface gridding when `thetap` is nonzero (`thetap` is changed to degrees in `plasticbuild_cb` (line 94) to fix the error).

## Version 5.04 - 04/06/2020

- Debugging so version will compile on MATLAB R2020a.

## Version 5.03 - 05/16/2019

- Fixed a bug with discrete springs.

## Version 5.02 - 04/05/2018

- Small bug fixes, reset went to CUFSM4.

## Version 5.01 - 02/26/2018

- Fixed Javascript bugs in `boundcond.m` that caused crashes.

## Version 5.00 - 01/31/2018

- Clean up and hide some features to create a version for release to end users.

## Version 4.502 - 05/17/2017

- Debug springs to ground with general end boundary conditions.

## Version 4.501 - 03/24/2016-11/28/2016

- Bring in the holes tool for approximating members with holes using FSM and methods of Cris Moen's dissertation.
- Contributions from Junle Cai in this effort.


## Version 4.301 - 02/26/2016

- Interface clean up and getting plastic section integrated into the code for the beam-column effort.
- `plasticbuild.m` added for plastic surface creation and $\beta_p$ values for yield on the PMM plastic surface.
- Contributions from Shahab Torabian in this effort.

## Version 4.3 - 12/14/2015

- Working on node-to-node foundation and discrete springs
- Other improvements.

## Version 4.2 - 12/11/2015

- Working on menus and program workflow.
- Added CUTWP and AbaqusMaker.
- Traditional file menu across the top replaced old buttons.

## Version 4.12 - 11/06/2015-12/08/2015

- Added sharp/round corner option to the template generator.
- Reworking applied load/stress generator to be more consistent with the beam-column effort.
- Applied stress generator completely reworked, now consistent with the PMM beam-column efforts.

## Version 4.11 - 10/26/2015

- Added element discretization control to the template generator.

## Version 4.10 - 10/26/2015

- Add cross-section rotation for getting properties into MASTAN as desired.
- Added export to MASTAN, either `user.dat` or replace a section in a model.
- Added read from MASTAN into the forces for a CUFSM model, especially useful potentially for bimoment.
- Upgraded the template generator so that out-to-out or centerline dimensions can be used and upgraded plot of the template section.
- Added cross-section duplication for easing creation of built-up section.

## Version 4.05 - 03/05/12

- Bugs in `loader.m` are fixed.
- Add digit precision for springs.
- Bugs in the post-processing are fixed.

## Version 4.04 - 08/05/11

- Some small interface bugs removed.

## Version 3.12 - 12/4/06

- Fixed CUFSM 3.11 so that it can read old CUFSM files.
- Commented out $\beta$ calculation until CUTWP calculations are corrected.

## Version 4.03 - 09/13/10

- Major update. Zhanjie Li and Benjamin W. Schafer provided new source code.
- CUFSM now handles a suite of general boundary conditions from fix-fix to simple-simple, this adds some complexity.
- Significant interface changes.
- Lots of small interface bugs removed, $\beta$ testing to start soon.

## Version 3.1 - 10/06/06

- cFSM features added to the pre- and post-processors.
- Numerous small interface improvements.

## Version 3.0 - 04/30/04

- Warping section properties fixed and CUTWP integrated.
- Application of modal constraints made available for use as of 08/25/05.
- Host of small interface problems eliminated.
- Section properties won't bomb on arbitrary shapes.
- Debugging done on MATLAB Version 7.

## Version 2.6b - 08/14/03

- Zoom and rotate cleaned up.
- After analysis the program jumps to the post-processor.
- Translate a node with a text box instead.

## Version 2.6 - 12/09/02

- Zoom and rotate added.
- Double any element, delete any connected node.
- Added warping properties and bimoment stress generation.
- Automatic generation of master-slave constraints added for DB help.

## Version 2.5 - 10/01

- Updated to MATLAB Version 6.
- Spring foundations that change with length are added to better model typical cases.
- Input pages modified for ease of use.
- Cross-section plotting improved to show thickness.
- Inputs modified to allow multiple materials in the same model.

## Version 2.0e - 10/01

- Fixed bug with N and mm in the template generator.
- Added a circle in the post-processing so you can tell what length you are at.

## Version 2.0d - 08/09/01

- Fixed bug with springs and constraints in DOS version.

## Version 2.0c - 10/03/00

- Fixed bug with saving while in the input screen.

## Version 2.0b - 10/02/00

- Fixed bug with first node set to zero displacement.

## Version 2.0a - 08/28/00

- Version compatible between complied GUI and MATLAB GUI made, standalone DOS version created with `trytobuild.m`.

## Version 2.0 - 08/23/2000

- Completely redesigned and simplified the interface with help buttons.
- Copy and print inside the program.
- Added a template generator for C- and Z-sections.
- Normal right hand coordinate system used for input and results (no more positive z-axis downward).
- Choice of eigensolvers when doing analysis.
- Higher modes may be displayed in the post-processor.
- Continuous springs have been added for consideration of external stiffness on the buckling mode.
- Visualization of fixed conditions and springs added (symbols added).
- Constraint equations may be written and imposed on the member (e.g., v1 = 2 * v2).
- Post-processor for comparing the results of multiple analyses is provided.

## Version 1.0d - 12/09/97

- Section properties and generation of stress distribution module added.

## Version 1.0c - 11/06/97

- Menus taken off the top of the windows to avoid confusion.
- `num2str()` changed to `sprintf()` in `pre2.m` file so that input files are read correctly.
- Watch added for 3D plotting.
- Waitbar added for the analysis.
- Plotting modified so that it shows the first minimum that occurs.
- Double the cross-section discretization button in the input pre-processor.

## Version 1.0b - 10/22/97

- Changes to the post-processor: 
  - Added 3D plotting.
  - Plotting of deformed and undeformed geometries.

## Version 1.0a - 10/20/97

- Bug fixes in general input of the pre-processor.
- Bug fixes in plotting of the deformed shape for non-continuous sections.
