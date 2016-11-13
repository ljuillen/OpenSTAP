! . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
! .                                                                       .
! .                            S T A P 9 0                                .
! .                                                                       .
! .     AN IN-CORE SOLUTION STATIC ANALYSIS PROGRAM IN FORTRAN 90         .
! .     Adapted from STAP (KJ Bath, FORTRAN IV) for teaching purpose      .
! .                                                                       .
! .     Xiong Zhang, (2013)                                               .
! .     Computational Dynamics Group, School of Aerospace                 .
! .     Tsinghua Univerity                                                .
! .                                                                       .
! . . . . . . . . . . . . . .  . . .  . . . . . . . . . . . . . . . . . . .

! .  Define global variables

module GLOBALS

   integer, parameter :: ElementTmpFile=3	! Unit storing element data 
   integer, parameter :: LoadTmpFile=4	! Unit storing load vectors
   integer, parameter :: InputFile=5		! Unit used for input
   integer, parameter :: OutputFile=6		! Unit used for output

   integer :: NumberOfNodalPoints		! Total number of nodal points
						! = 0 : Program stop
   integer :: NumberOfEquations		! Number of equations
   integer :: NumberOfMatrixElements		! Number of matrix elements
   integer :: MaxHalfBandwidth		! Maximum half bandwidth

   integer :: SolutionPhase		! Solution phase indicator
						!   1 - Read and generate element information
						!   2 - Assemble structure stiffness matrix
						!   3 - Stress calculations
   integer :: NPAR(10)	! Element group control data
						!   NPAR(1) - Element type
						!             1 : Truss element
						!   NPAR(2) - Number of elements
						!   NPAR(3) - Number of different sets of material and 
						!             cross-sectional  constants
   integer :: NumberOfElementGroups		! Total number of element groups, > 0
   integer :: NumberOfLoadCases
   integer :: SolutionMode		! Solution mode: 0 - data check only;  1 -  execution                                   

   real :: Timing(5)		! Timing information
   character*80 :: JobIdentifier	! Master heading information for use in labeling the output

   integer :: NFIRST
   integer :: NLAST
   integer :: ElementGroupArraySize
   integer :: MaxElementGroupArraySize

   integer :: CurrentElementGroup

end module GLOBALS