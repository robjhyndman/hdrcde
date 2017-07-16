#include <R.h>
#include <Rinternals.h>
#include <R_ext/Rdynload.h>

void F77_SUB(linbin)(double *x, int *n, double *a,
         double *b, int *m, int *trun, double *gcounts);

static const R_FortranMethodDef FortEntries[] = {
    {"linbin", (DL_FUNC) &F77_SUB(linbin),  7},
    {NULL, NULL, 0}
};


void R_init_KernSmooth(DllInfo *dll)
{
    R_registerRoutines(dll, NULL, NULL, FortEntries, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
