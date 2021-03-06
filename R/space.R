##################################
######11-30-07: R package "space"
######R functions for fitting JSRM and MB: 

space.nested <- function(Y, seq_lam1, sridge=0, sig=NULL, weight=NULL,iter=2, tol = 1e-6, cdmax = 1e7L,
                           verbose = FALSE) { 
  #sequence of penalty parameters should be decreasing.
  vlam1 <- sort(seq_lam1, decreasing = TRUE)
  requireNamespace("foreach")
  
  res <- vector("list", length(vlam1))
  res[[1]] <- spacemap::space(Y = Y, lam1 = vlam1[1], sridge = sridge, sig=sig, weight = weight,
                              iter = iter, tol = tol, cdmax = cdmax,
                              verbose = verbose, rho  = NULL)
  
  for(i in 2:length(vlam1)) { 
    res[[i]] <- spacemap::space(Y = Y, lam1 = vlam1[i], sridge = sridge, sig = res[[i-1]]$sig.fit, weight = weight,
                                iter = iter, tol = tol, cdmax = cdmax,
                                verbose = verbose, rho = res[[i-1]]$ParCor)
  }
  res
}

#' Fit the SPACE model. 
#'
#' Estimate partial correlations according to SPACE model. 
#' @inheritParams spacemap
#' @param sridge The \eqn{l_2} penalty parameter defaults to 0. When it is positive, 
#' it imposes an elastic net  penalty in tandem with \code{lam1} on \eqn{\rho}. 
#' @param weight The weights applied to the Q regressions in the SPACE model. 
#' 
#'  If \code{weight==NULL}, each regression has equal weight.
#'  
#'  If \code{weight==1}, each regression is weighted according to 
#'  \eqn{\sigma^{ii}} and enforces \code{iter>=2}.
#'  
#'  If \code{weight==2} each regression is weighted according to
#'   the out-degree of \eqn{q}th response variable and enforces \code{iter>=2}.
#'  
#'  Otherwise, \code{weight=}user-specified vector of length p. 
#' 
#' The scale of weight does not matter. In this function, weight will be rescaled to have mean=1 
#' @return A list containing 
#'\enumerate{
#'   \item \code{ParCor} The estimated partial correlation matrix (\eqn{P \times P}), 
#'   where off-diagonals  \eqn{ |\hat \rho^{p,q}_{yy}| > 1e-6}  encode the edges \eqn{\{ y_q - y_l : q \neq l \} }
#'   and the diagonals are 1's. 
#'   \item \code{sig.fit} The estimated diagonal \eqn{\hat \sigma^{ii}}.
#'   \item \code{rss} The residual sums of squares from the model fit. 
#'   \item convergence logical: true for successful convergence, otherwise failed to converge. Failure can be 
#'   mitigated by increasing \code{tol} and/or \code{cdmax}. 
#'   \item \code{deltaMax} The maximum change in parameter values between the penultimate and ultimate iteration. 
#'   If \code{spacemap} does not converge, \code{deltaMax} provides some measure of how far away it was from converging
#'   when compared to \code{tol}. 
#' }
#' @importFrom Rcpp evalCpp
# #' @import RcppArmadillo
#' @useDynLib spacemap
#' @export
#' @seealso \code{\link{spacemap}}, \code{\link{cvVote}}, \code{\link{bootEnsemble}}, \code{\link{bootVote}}
#' @examples
#' data(sim1)
#' net <- spacemap::space(Y = sim1$Y, lam1 = 70)
#' #adjacency matrix of y-y edges. 
#' adjnet <- adjacency(net)
space <-function(Y, lam1, sridge=0, sig=NULL, weight=NULL,iter=3, tol = 1e-6, cdmax = 1e7L,
                       rho = NULL, iscale = TRUE)
{
  ########################parameters: 
  ## Y: n (sample size) by p (number of variables) data matrix; 
  ##            (In this function, Y will be first standardized to mean zero and l_2 norm 1)
  ## lam1:l_1 penalty paramter; corresponding to Y scaled as norm being one, 
  ##     suggested range is: O(n^{3/2}\Phi^{-1}(1-\alpha/(2p^2))) for small $\alpha$ such as 0.1 
  ## sridge: l_2 penalty paramter
  ## sig: vector of {sigma^{ii}}; If sig==NULL, then set the initial value as sig=rep(1,p) and then iter>=2  
  ##     remark: the scale of sig does not matter
  ## weight: if weight==NULL: equal weight; if weight==1, set weight=sig and iter>=2; 
  ##        if weight==2. set weight==degree and iter>=2; otherwise, weight=user specified vector of length p 
  ##        remark: the scale of weight does not matter. In this function, weight will be rescaled to have mean=1 
  ## iter: number of iterations used for estimating \rho and \sigma; default==2; or user specified
  #       note:  in some cases iter is forced to be at least 2.
  #######################
  
  ####################### return value
  ## A list: the estimated \{\rho^{ij}\}: p by p matrix, and $\{\sigma^{ii}\}$: p by 1 vector
  #######################
  
  n=nrow(Y)
  p=ncol(Y)
  ITER=iter
  
  #check for missing data
  if (any(is.na(Y))) { 
    stop("Missing values found in input matrix Y; imputation is required prior to Spacemap fitting.")
  } 
  
  if (iscale) { 
    #Standardize the response vector
    Y.s <- scale(Y)
    #Keep the same scale as user input:
    # W = diag(apply(Y, 2, sd))
    # R = inv(W) \Sigma inv(W)
    #...Therefore
    # \Sigma = inv(W) inv(R) inv(W)
    Y.stddev <- attr(Y.s, "scaled:scale")  
  } else { 
    Y.s <- Y
    Y.stddev <- rep(1,p)
  }
  
  
  ################### preparation
  if(!is.null(sig))
  { #### if the user specify "sig", still update sig
    SIG.update=T
    SIG=sig
  } else { #### otherwise, need to update sig in each iteration
    SIG.update=T
    SIG=rep(1, p) 
  } 
  
  if(length(weight)==0 | (length(weight)>1 & length(weight)<p)) ### weight==NULL 
  {
    WEIGHT.tag=0 ### equal weight 
    WEIGHT=rep(1, p)
    WEIGHT.update=F
  } 
  if(length(weight)==1)
  {
    if(weight==1)
    {
      WEIGHT.tag=1 ### sig based weight
      WEIGHT=SIG
      WEIGHT.update=T
      ITER=max(2, iter)
    } else {
      WEIGHT.tag=2 ### degree based weight
      WEIGHT=rep(1,p)
      WEIGHT.update=T
      ITER=max(2, iter)
    } 
  }
  if(length(weight)==p)  
  {
    WEIGHT.tag=3 ## prespecified weight
    WEIGHT=weight
    WEIGHT.update=F
  }
  ################## begin to iterate
  for(i in 1:ITER) {
    
    Y.u<-Y.s*matrix(sqrt(WEIGHT),n,p,byrow=TRUE)
    sig.u<-SIG/WEIGHT
    
    jsrm.fit <-jsrm(Y.u,sig.u,n,p,lam1,sridge, 
                    n_iter = cdmax, tol = tol, rho = rho)
    ParCor.fit <- jsrm.fit$ParCor.fit
    diag(ParCor.fit)<-1
    
    coef<-ParCor.fit[upper.tri(ParCor.fit)]
    beta.cur<-Beta.coef(coef,SIG) 
    
    
    if(!WEIGHT.update & !SIG.update)
    {
      break
    } else { ## update sig or weight
      if(SIG.update)
      {
        SIG<-InvSig.diag.new(Y.s,beta.cur)   
      }
      if(WEIGHT.update)
      {
        if(WEIGHT.tag==1)
        {        #### sig based
          WEIGHT=SIG
        } else { #### degree based
          temp.w<-apply(abs(ParCor.fit)>1e-6,1,sum)
          temp.w<-temp.w+max(temp.w)     
          WEIGHT<-temp.w/sum(temp.w)*p    
        }
      } 
    } ### end updating WEIGHT and SIG
    #Do not continue estimating if it didn't converge in the first iteration. 
    if (!jsrm.fit$convergence) break;
  } ### end iteration
  
  #Keep the same scale as user input:
  SIG <- SIG / (Y.stddev * Y.stddev) 
  
  result<-list(ParCor = ParCor.fit, sig.fit = SIG, rss = jsrm.fit$rss, 
               convergence = jsrm.fit$convergence, deltaMax = jsrm.fit$deltaMax)
  return(result)  
}

############################## function for example
######## generate starr based network: three hubs 

Hub.net<-function(p,hub.no=3,hub.size=16,umin=0.5,umax=1)
{
  
  degree.gen<-sample(1:3,p,replace=T)
  degree.gen[1:hub.no]<-hub.size          ##hub size
  
  if(sum(degree.gen)/2 != round(sum(degree.gen)/2)) 
    degree.gen[p]<-degree.gen[p]+1
  
  net.adj<-RanGra(degree.gen,p)
  diag(net.adj)<-0
  
  ParCor.gen<-GenPar(net.adj,umin,umax,flip=TRUE,factor=1.5) 
  ##generate original "paratial correlation"
  
  ##check whether the generatee partial correlation is p.d?
  all(eigen(ParCor.gen)$values>0)                         ##p.d.?
  
  ##truncation the partial correlations to make small ones larger
  thre<-0.1
  
  ParCor.trun<-ParCor.gen
  ParCor.trun[abs(ParCor.gen)<thre&abs(ParCor.gen)>0]<-thre
  all(eigen(ParCor.trun)$values>0)                        ##still p.d.?
  
  ##get covariance matrix and save in Sig.Rdata
  Sig<-GenCov(ParCor.trun) 
  
  ##
  return(Sig)
}



##################################################################
############################ internal functions 
#################################################################

############################## (b). calling JSRM adaptive shooting functions in c (by pei)
############# for shooting: data  is standardized to norm 1
############# for update sigma: data is standardized to sd 1;  both are done within the c code

#######JSRM
###### call C function directly in R

jsrm<-function(Y,sig.use,n,p,lam1,sridge, n_iter, tol, rho = NULL) {
  
  #cat("Y is:", class(Y)); flush.console();
  stopifnot(is.matrix(Y), is.numeric(sig.use), 
            length(sig.use) == ncol(Y))
  lambda1=lam1
  lambda2=sridge
  sigma_sr=sig.use^0.5
  
  if (!is.null(rho) & is.matrix(rho)) {
    stopifnot(nrow(rho) == p, ncol(rho) == p)
    res <- doSpace(Y, sigma_sr, lambda1, lambda2, tol, n_iter, as.vector(rho), TRUE)
  } else { 
    res <- doSpace(Y, sigma_sr, lambda1, lambda2, tol, n_iter, as.vector(matrix(0, p, p)), FALSE)
  }
  
  return(list(ParCor.fit = matrix(res$rho, p,p, byrow=T),
              rss = res$rss, convergence = res$convergence, 
              deltaMax = res$deltaMax))
}

########################################
##### Estimate diagonal sigma
##use the fact that 1/sig^{ii} is the residual variance in one versus all others setting


InvSig.diag.new<-function(Y, Beta){
  ################### parameters
  ### Y:    n by p data matrix; should be standardized to sd 1;
  ### Beta: beta matrix for the regression model
  p=ncol(Y)
  Beta.temp=Beta
  diag(Beta.temp)=0
  esti.Y=Y%*%Beta.temp
  residue=Y-esti.Y
  result=apply(residue^2, 2, mean)
  return(1/result)
}


InvSig.diag.old<-function(Y, Beta){
  ################### parameters
  ### Y:    n by p data matrix; should be standardized to sd 1;
  ### Beta: beta matrix for the regression model
  p<-ncol(Y)
  result<-numeric(p)
  for(i in 1:p){
    beta.cur<-Beta[,i]
    beta.cur<-matrix(beta.cur[-i])
    y.cur<-Y[,i]
    x.cur<-Y[,-i]
    e.cur<-y.cur-x.cur%*%beta.cur
    sig.ii<-mean(e.cur^2)
    result[i]<-1/sig.ii 
  }
  return(result)
}


########################################
### given rho^{ij}, get beta[j,i]: each column for each variable  
### beta[j,i]<-rho^{ij}sqrt(sig^{jj}/sig{ii})

Beta.coef<-function(coef, sig.fit){
  ############## parameter
  ### coef: rho^{ij}; 
  ### sig.fit: sig^{ii}
  p<-length(sig.fit)
  result<-matrix(0,p,p)
  result[upper.tri(result)]<-coef
  result<-result+t(result)
  result<-diag(1/sqrt(sig.fit))%*%result%*%diag(sqrt(sig.fit))
  result<-t(result) 
  return(result)
}


#######################################
####generate a random graph based on given degrees of nodes

RanGra<-function(degree,p){
  ##p--number of nodes;
  ##degree--degrees of each node 
  ##sum(degree) must be an even number 
  
  result<-matrix(0,p,p)
  stub<-matrix(0,sum(degree),2)
  
  count<-0
  for(i in 1:length(degree)){
    cur<-(count+1):(count+degree[i])
    stub[cur,1]<-i
    stub[cur,2]<-cur
    count<-count+degree[i]
  }
  
  index<-sample(1:sum(degree),sum(degree)/2)
  
  stub.1<-stub[index,]
  stub.2<-stub[-index,]    
  for (i in 1:nrow(stub.1)){
    cur.1<-stub.1[i,1]
    cur.2<-stub.2[i,1]
    result[cur.1,cur.2]<-1
    result[cur.2,cur.1]<-1
  }
  return(result)
  
}



###################################
###get partial correlation matrix based on an adjacent network 

GenPar<-function(net.adj,umin,umax,flip=TRUE,factor=2){
  ##net.adj<-the adjacent network
  ##unim,umax,  the range of the orginal parcor
  ##filp=T means random sign of the parcor
  p<-nrow(net.adj)
  result<-matrix(0,p,p)
  for(i in 2:p){
    for(j in 1:(i-1)){
      cur<- stats::runif(1,umin,umax)
      sign<-1 
      if(flip) sign<-sample(c(-1,1),1)   
      cur<-cur*sign    
      result[i,j]<-cur*net.adj[i,j]
      result[j,i]<-result[i,j]
    }
  }
  
  diag.re<-matrix(apply(abs(result),1,sum),p,p)*factor+1e-6
  result<-result/diag.re
  result<-(result+t(result))/2
  diag(result)<-1
  
  return(result)
  
}


##################################################
## get covariance matrix from a partial correlation matrix 
## make it p.d.

GenCov<-function(ParCor.m){
  temp<-(-ParCor.m)
  diag(temp)<-1
  Sig<-solve(ParCor.m)
  
  
  p<-nrow(Sig)
  for (i in 2:p){
    for (j in 1:(i-1)){
      Sig[i,j]<-Sig[i,j]/sqrt(Sig[i,i]*Sig[j,j]) ##standardize to sigma=1
      Sig[j,i]<-Sig[i,j]
    }
  }
  diag(Sig)<-1
  
  #diagonose
  D<-eigen(Sig)$values
  if(!all(D>0)){
    print("invalid covariance matrix")
    return()
  }
  
  return(Sig)
}

