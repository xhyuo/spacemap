// Generated by using Rcpp::compileAttributes() -> do not edit by hand
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <RcppArmadillo.h>
#include <Rcpp.h>

using namespace Rcpp;

// calcThetaXY
NumericMatrix calcThetaXY(const NumericMatrix& Gamma, const NumericVector& diagThetaYY);
RcppExport SEXP spacemap_calcThetaXY(SEXP GammaSEXP, SEXP diagThetaYYSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const NumericMatrix& >::type Gamma(GammaSEXP);
    Rcpp::traits::input_parameter< const NumericVector& >::type diagThetaYY(diagThetaYYSEXP);
    rcpp_result_gen = Rcpp::wrap(calcThetaXY(Gamma, diagThetaYY));
    return rcpp_result_gen;
END_RCPP
}
// calcThetaYY
NumericMatrix calcThetaYY(const NumericMatrix& ParCor, const NumericVector& diagThetaYY);
RcppExport SEXP spacemap_calcThetaYY(SEXP ParCorSEXP, SEXP diagThetaYYSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const NumericMatrix& >::type ParCor(ParCorSEXP);
    Rcpp::traits::input_parameter< const NumericVector& >::type diagThetaYY(diagThetaYYSEXP);
    rcpp_result_gen = Rcpp::wrap(calcThetaYY(ParCor, diagThetaYY));
    return rcpp_result_gen;
END_RCPP
}
// conc2parcor
NumericMatrix conc2parcor(const NumericMatrix& D);
RcppExport SEXP spacemap_conc2parcor(SEXP DSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const NumericMatrix& >::type D(DSEXP);
    rcpp_result_gen = Rcpp::wrap(conc2parcor(D));
    return rcpp_result_gen;
END_RCPP
}
// nonZeroWhole
unsigned int nonZeroWhole(const NumericMatrix& Gamma, const double aszero);
RcppExport SEXP spacemap_nonZeroWhole(SEXP GammaSEXP, SEXP aszeroSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const NumericMatrix& >::type Gamma(GammaSEXP);
    Rcpp::traits::input_parameter< const double >::type aszero(aszeroSEXP);
    rcpp_result_gen = Rcpp::wrap(nonZeroWhole(Gamma, aszero));
    return rcpp_result_gen;
END_RCPP
}
// nonZeroUpper
unsigned int nonZeroUpper(const NumericMatrix& ParCor, const double aszero);
RcppExport SEXP spacemap_nonZeroUpper(SEXP ParCorSEXP, SEXP aszeroSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const NumericMatrix& >::type ParCor(ParCorSEXP);
    Rcpp::traits::input_parameter< const double >::type aszero(aszeroSEXP);
    rcpp_result_gen = Rcpp::wrap(nonZeroUpper(ParCor, aszero));
    return rcpp_result_gen;
END_RCPP
}
// gaussCondLogLik
double gaussCondLogLik(const arma::mat& Y, const arma::mat& X, const arma::mat& ThetaYY, const arma::mat& ThetaXY);
RcppExport SEXP spacemap_gaussCondLogLik(SEXP YSEXP, SEXP XSEXP, SEXP ThetaYYSEXP, SEXP ThetaXYSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const arma::mat& >::type Y(YSEXP);
    Rcpp::traits::input_parameter< const arma::mat& >::type X(XSEXP);
    Rcpp::traits::input_parameter< const arma::mat& >::type ThetaYY(ThetaYYSEXP);
    Rcpp::traits::input_parameter< const arma::mat& >::type ThetaXY(ThetaXYSEXP);
    rcpp_result_gen = Rcpp::wrap(gaussCondLogLik(Y, X, ThetaYY, ThetaXY));
    return rcpp_result_gen;
END_RCPP
}
// gaussLogLik
double gaussLogLik(const arma::mat& Theta, const arma::mat& Y);
RcppExport SEXP spacemap_gaussLogLik(SEXP ThetaSEXP, SEXP YSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const arma::mat& >::type Theta(ThetaSEXP);
    Rcpp::traits::input_parameter< const arma::mat& >::type Y(YSEXP);
    rcpp_result_gen = Rcpp::wrap(gaussLogLik(Theta, Y));
    return rcpp_result_gen;
END_RCPP
}
// olsRefitSpacemap
bool olsRefitSpacemap(const arma::mat& Y, const arma::mat& X, arma::mat& ParCor, arma::mat& Gamma, arma::colvec& sigma, arma::colvec& RSS, double tol, double ridge);
RcppExport SEXP spacemap_olsRefitSpacemap(SEXP YSEXP, SEXP XSEXP, SEXP ParCorSEXP, SEXP GammaSEXP, SEXP sigmaSEXP, SEXP RSSSEXP, SEXP tolSEXP, SEXP ridgeSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const arma::mat& >::type Y(YSEXP);
    Rcpp::traits::input_parameter< const arma::mat& >::type X(XSEXP);
    Rcpp::traits::input_parameter< arma::mat& >::type ParCor(ParCorSEXP);
    Rcpp::traits::input_parameter< arma::mat& >::type Gamma(GammaSEXP);
    Rcpp::traits::input_parameter< arma::colvec& >::type sigma(sigmaSEXP);
    Rcpp::traits::input_parameter< arma::colvec& >::type RSS(RSSSEXP);
    Rcpp::traits::input_parameter< double >::type tol(tolSEXP);
    Rcpp::traits::input_parameter< double >::type ridge(ridgeSEXP);
    rcpp_result_gen = Rcpp::wrap(olsRefitSpacemap(Y, X, ParCor, Gamma, sigma, RSS, tol, ridge));
    return rcpp_result_gen;
END_RCPP
}
// olsRefitSpace
bool olsRefitSpace(const arma::mat& Y, arma::mat& ParCor, arma::colvec& sigma, arma::colvec& RSS, double tol, double ridge);
RcppExport SEXP spacemap_olsRefitSpace(SEXP YSEXP, SEXP ParCorSEXP, SEXP sigmaSEXP, SEXP RSSSEXP, SEXP tolSEXP, SEXP ridgeSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const arma::mat& >::type Y(YSEXP);
    Rcpp::traits::input_parameter< arma::mat& >::type ParCor(ParCorSEXP);
    Rcpp::traits::input_parameter< arma::colvec& >::type sigma(sigmaSEXP);
    Rcpp::traits::input_parameter< arma::colvec& >::type RSS(RSSSEXP);
    Rcpp::traits::input_parameter< double >::type tol(tolSEXP);
    Rcpp::traits::input_parameter< double >::type ridge(ridgeSEXP);
    rcpp_result_gen = Rcpp::wrap(olsRefitSpace(Y, ParCor, sigma, RSS, tol, ridge));
    return rcpp_result_gen;
END_RCPP
}
// doRemMap
List doRemMap(const NumericMatrix& Ym, const NumericMatrix& Xm, const NumericMatrix& Wm, const double rlasso, const double rgroup, const double tol, const int maxIter);
RcppExport SEXP spacemap_doRemMap(SEXP YmSEXP, SEXP XmSEXP, SEXP WmSEXP, SEXP rlassoSEXP, SEXP rgroupSEXP, SEXP tolSEXP, SEXP maxIterSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const NumericMatrix& >::type Ym(YmSEXP);
    Rcpp::traits::input_parameter< const NumericMatrix& >::type Xm(XmSEXP);
    Rcpp::traits::input_parameter< const NumericMatrix& >::type Wm(WmSEXP);
    Rcpp::traits::input_parameter< const double >::type rlasso(rlassoSEXP);
    Rcpp::traits::input_parameter< const double >::type rgroup(rgroupSEXP);
    Rcpp::traits::input_parameter< const double >::type tol(tolSEXP);
    Rcpp::traits::input_parameter< const int >::type maxIter(maxIterSEXP);
    rcpp_result_gen = Rcpp::wrap(doRemMap(Ym, Xm, Wm, rlasso, rgroup, tol, maxIter));
    return rcpp_result_gen;
END_RCPP
}
// doSpace
List doSpace(const NumericMatrix& Ym, NumericVector& sigma_sr, const double lasso, const double ridge, const double tol, const int maxIter, const NumericVector& beta_init, const bool init);
RcppExport SEXP spacemap_doSpace(SEXP YmSEXP, SEXP sigma_srSEXP, SEXP lassoSEXP, SEXP ridgeSEXP, SEXP tolSEXP, SEXP maxIterSEXP, SEXP beta_initSEXP, SEXP initSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const NumericMatrix& >::type Ym(YmSEXP);
    Rcpp::traits::input_parameter< NumericVector& >::type sigma_sr(sigma_srSEXP);
    Rcpp::traits::input_parameter< const double >::type lasso(lassoSEXP);
    Rcpp::traits::input_parameter< const double >::type ridge(ridgeSEXP);
    Rcpp::traits::input_parameter< const double >::type tol(tolSEXP);
    Rcpp::traits::input_parameter< const int >::type maxIter(maxIterSEXP);
    Rcpp::traits::input_parameter< const NumericVector& >::type beta_init(beta_initSEXP);
    Rcpp::traits::input_parameter< const bool >::type init(initSEXP);
    rcpp_result_gen = Rcpp::wrap(doSpace(Ym, sigma_sr, lasso, ridge, tol, maxIter, beta_init, init));
    return rcpp_result_gen;
END_RCPP
}
// doSpaceMap
List doSpaceMap(const NumericMatrix& Ym, const NumericMatrix& Xm, const NumericMatrix& Wm, NumericVector& sigma_sr, const double slasso, const double sridge, const double rlasso, const double rgroup, const double tol, const int maxIter, const NumericVector& beta_init, const bool init);
RcppExport SEXP spacemap_doSpaceMap(SEXP YmSEXP, SEXP XmSEXP, SEXP WmSEXP, SEXP sigma_srSEXP, SEXP slassoSEXP, SEXP sridgeSEXP, SEXP rlassoSEXP, SEXP rgroupSEXP, SEXP tolSEXP, SEXP maxIterSEXP, SEXP beta_initSEXP, SEXP initSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const NumericMatrix& >::type Ym(YmSEXP);
    Rcpp::traits::input_parameter< const NumericMatrix& >::type Xm(XmSEXP);
    Rcpp::traits::input_parameter< const NumericMatrix& >::type Wm(WmSEXP);
    Rcpp::traits::input_parameter< NumericVector& >::type sigma_sr(sigma_srSEXP);
    Rcpp::traits::input_parameter< const double >::type slasso(slassoSEXP);
    Rcpp::traits::input_parameter< const double >::type sridge(sridgeSEXP);
    Rcpp::traits::input_parameter< const double >::type rlasso(rlassoSEXP);
    Rcpp::traits::input_parameter< const double >::type rgroup(rgroupSEXP);
    Rcpp::traits::input_parameter< const double >::type tol(tolSEXP);
    Rcpp::traits::input_parameter< const int >::type maxIter(maxIterSEXP);
    Rcpp::traits::input_parameter< const NumericVector& >::type beta_init(beta_initSEXP);
    Rcpp::traits::input_parameter< const bool >::type init(initSEXP);
    rcpp_result_gen = Rcpp::wrap(doSpaceMap(Ym, Xm, Wm, sigma_sr, slasso, sridge, rlasso, rgroup, tol, maxIter, beta_init, init));
    return rcpp_result_gen;
END_RCPP
}
