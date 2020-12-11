#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
NumericMatrix fZooMSS_MvF_Rcpp(int cngrps,
                               NumericMatrix cN_iter,
                               NumericMatrix cA_iter,
                               NumericMatrix cC_iter,
                               NumericMatrix cS_iter,
                               IntegerVector ccurr_min_size,
                               IntegerVector ccurr_max_size) {

    for(int i = 0; i < cngrps; i++){
        // Do the first size class for group i
        cN_iter(i,ccurr_min_size[i]) = (cS_iter(i,ccurr_min_size[i]) + cA_iter(i,ccurr_min_size[i]) * cN_iter(i,(ccurr_min_size[i]-1))) / cC_iter(i,ccurr_min_size[i]);

        for(int j = (ccurr_min_size[i]+1); j < ccurr_max_size[i]; j++){
            cN_iter(i,j) = (cS_iter(i,j) + cA_iter(i,j)*cN_iter(i,j-1)) / cC_iter(i,j);

        }

    }

    return cN_iter;
}