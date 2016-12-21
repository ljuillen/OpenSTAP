subroutine EIGENVAL(Stiff, Mass, MAXA, NN, NWK, NNM, NRoot)
    USE GLOBALS, ONLY : IOUT, PARDISODOOR
    use memallocate
    implicit none
    real(8) :: Stiff(NWK), Mass(NWK)
    integer :: MAXA(NNM)            !NNM = NN+1
    integer :: NN, NWK, NNM, NRoot
    real(8), parameter :: RTol = 1.0D-6
    real(8), allocatable :: EignVec(:,:),EignVal(:)
    !LANCZOS variables
    integer, parameter :: StiffTmp = 16
    integer :: NC, NNC, NRestart
    logical :: IFSS, IFPR
    !dfeast_scsrgv variables
    character(1) :: uplo
    integer :: fpm(128), info, loop
    real(8) :: epsout, emin, emax
    real(8),allocatable :: res(:)
    
    write(IOUT,*)'-------------------------------------------------------------------------------------'
    write(IOUT,*)'           E I G E N   V A L U E   C A L C U L A T I O N   R E S U L T S'
    
    NC = minval((/2*NRoot, NRoot+8, NWK/))
    allocate (EignVec(NN,NC),EignVal(NC))
    if (.NOT. PARDISODOOR) then
        open(StiffTmp, FILE = "Stff.tmp", FORM = "UNFORMATTED", STATUS = "Replace")
        REWIND StiffTmp
        WRITE (StiffTmp) Stiff(1:NWK)
        NNC=NC*(NC+1)/2
        !THE PARAMETERS NC AND/OR NRestart MUST BE INCREASED IF A SOLUTION HAS NOT CONVERGED
        call LANCZOS(Stiff, Mass, MAXA, EignVec, EignVal, NN, NNM, NWK, NWK, NRoot, RTol, NC, NNC, NRestart, IFSS, IFPR, StiffTmp, IOUT)
        REWIND StiffTmp
        READ (StiffTmp) Stiff
        close(StiffTmp)
    else
        uplo = 'U'
        allocate (res(NC))
        !IA(NP(9))      --  Mass Row Index
        !IA(NP(8))      --  Mass Column Indicator
        !IA(NP(5))      --  Stiffness Column Indicator
        !IA(NP(2))      --  Stiffness Row Index
        !DA(NP(10))     --  Mass Matrix
        !DA(NP(3))      --  Stiffness Matrix
        call pardiso_crop(DA(NP(10)), IA(NP(9)), IA(NP(8)))
        call dfeast_scsrgv(uplo, NN, Stiff, IA(NP(2)), IA(NP(5)), Mass, IA(NP(9)), IA(NP(8)), fpm, epsout, loop, emin, emax, NC, EignVal, EignVec, NRoot, res, info)
        deallocate (res)
    end if
    write(IOUT,*)'-------------------------------------------------------------------------------------'
    deallocate (EignVec, EignVal)
end subroutine EIGENVAL
    
subroutine prepare_MassMatrix
    use globals
    use memallocate
    implicit none

    CALL MEMALLOC(10,"M    ",NWK,ITWO)
    if (PARDISODOOR) then
        call memalloc(9,"MrInd",NEQ+1,1)
        call memalloc(8,"Mcolm",NWK,1)
        IA(NP(8):NP(8)+NWK) = IA(NP(5):NP(5)+NWK)
        IA(NP(9):NP(9)+NEQ+1) = IA(NP(2):NP(2)+NEQ+1)
    end if
end subroutine prepare_MassMatrix

