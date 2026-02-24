# ##############################################################################
#                                                                              #
# anoles.R                                                                     #
#                                                                              #
# This file is a collection of code snippets present in the phytools tutorial: #
# http://www.phytools.org/***SanJuan2016/ex/7/Anc-states-continuous.html       #
#                                                                              #
# This script is an example analysis of ancestral state reconstruction using   #
# the phytools package                                                         #
#                                                                              #
# Original author: Liam J. Revell                                              #
# Last updated 29 Jun. 2015                                                    #
#                                                                              #
# ##############################################################################


# load libraries
library(phytools)

## read tree from file and plot
tree<-read.tree("Anolis.tre") 
plotTree(tree,type="fan",ftype="i")

## read data into a vector
svl<-read.csv("svl.csv",row.names=1)
svl<-setNames(svl$svl,rownames(svl))
svl

# estimate ancestral states with variances and confidence intervals
fit<-fastAnc(tree,svl,vars=TRUE,CI=TRUE)
print(fit,printlen=10)

## as discussed in class, 95% CIs can be broad
range(svl) ## compare to root node

## projection of the reconstruction onto the edges of the tree
obj<-contMap(tree,svl,plot=FALSE)
obj
plot(obj, type="fan", legend=0.7*max(nodeHeights(tree)))
