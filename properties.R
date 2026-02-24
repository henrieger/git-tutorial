# ##############################################################################
#                                                                              #
# properties.R                                                                 #
#                                                                              #
# This file is a collection of code snippets present in the phytools tutorial: #
# http://www.phytools.org/***SanJuan2016/ex/7/Anc-states-continuous.html       #
#                                                                              #
# This script is aims to explore some properties of ancestral reconstruction   #
# of continuous characters under simulated data, using the phytools package    #
#                                                                              #
# Original author: Liam J. Revell                                              #
# Last updated 29 Jun. 2015                                                    #
#                                                                              #
# ##############################################################################


# load libraries
library(phytools)

## simulate a tree & some data
tree<-pbtree(n=26,scale=1,tip.label=LETTERS[26:1])
## simulate with ancestral states
x<-fastBM(tree,internal=TRUE)
## ancestral states
a<-x[as.character(1:tree$Nnode+Ntip(tree))]
## tip data
x<-x[tree$tip.label]

# Estimate ancestral states using fastAnc (re-rooting)
fit<-fastAnc(tree,x,CI=TRUE)
print(fit,printlen=6)

# Compare estimates to the generated values for simulated data
plot(a,fit$ace,xlab="true states",ylab="estimated states")
lines(range(c(x,a)),range(c(x,a)),lty="dashed",col="red") ## 1:1 line

## first, let's go back to our previous dataset
print(fit)
mean(((a>=fit$CI95[,1]) + (a<=fit$CI95[,2]))==2)

## custom function that conducts a simulation, estimates ancestral
## states, & returns the fraction on 95% CI
foo<-function(){
    tree<-pbtree(n=100)
    x<-fastBM(tree,internal=TRUE)
    fit<-fastAnc(tree,x[1:length(tree$tip.label)],CI=TRUE)
    mean(((x[1:tree$Nnode+length(tree$tip.label)]>=fit$CI95[,1]) +
        (x[1:tree$Nnode+length(tree$tip.label)]<=fit$CI95[,2]))==2)
}
## conduct 100 simulations
pp<-replicate(100,foo())
mean(pp)


### Ancestral state estimations when some nodes are known ###

## ## fixate ancestral states for chars 27, 31 and 35
## anc.states<-a[as.character(c(27,31,35))]
## fit<-fastAnc(tree,x,anc.states=anc.states,CI=TRUE)
## plot(a,fit$ace,xlab="true states",ylab="estimated states")
## lines(range(c(x,a)),range(c(x,a)),lty="dashed",col="red") ## 1:1 line
##
## ## simulate data with a trend
## tree<-pbtree(n=100,scale=1)
## x<-fastBM(tree,internal=TRUE,mu=3)
## phenogram(tree,x,ftype="off",spread.labels=FALSE)
##
## a<-x[as.character(1:tree$Nnode+Ntip(tree))]
## x<-x[tree$tip.label]
## ## let's see how bad we do if we ignore the trend
## plot(a,fastAnc(tree,x),xlab="true values",
##     ylab="estimated states under BM")
## lines(range(c(x,a)),range(c(x,a)),lty="dashed",col="red")
## title("estimated without prior information")
##
## ## incorporate prior knowledge
## pm<-setNames(c(1000,rep(0,tree$Nnode)),
##     c("sig2",1:tree$Nnode+length(tree$tip.label)))
## ## the root & two randomly chosen nodes
## nn<-as.character(c(length(tree$tip.label)+1,
##     sample(2:tree$Nnode+length(tree$tip.label),2)))
## pm[nn]<-a[as.character(nn)]
## ## prior variance
## pv<-setNames(c(1000^2,rep(1000,length(pm)-1)),names(pm))
## pv[as.character(nn)]<-1e-100
## ## run MCMC
## mcmc<-anc.Bayes(tree,x,ngen=100000,
##     control=list(pr.mean=pm,pr.var=pv,
##     a=pm[as.character(length(tree$tip.label)+1)],
##     y=pm[as.character(2:tree$Nnode+length(tree$tip.label))]))
##
## anc.est<-colMeans(mcmc[201:1001,
##     as.character(1:tree$Nnode+length(tree$tip.label))])
## plot(a[names(anc.est)],anc.est,xlab="true values",
##     ylab="estimated states using informative prior")
## lines(range(c(x,a)),range(c(x,a)),lty="dashed",col="red")
## title("estimated using informative prior")
