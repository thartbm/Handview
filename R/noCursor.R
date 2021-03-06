source('R/shared.R')

# Analysis and Plots-----

getEIGroupConfidenceInterval <- function(groups = c('30implicit', '30explicit', 'cursorjump'), type = 't'){
  
  for (group in groups){
    data <- read.csv(file=sprintf('data/%s_reachaftereffects.csv',group), stringsAsFactors = F)
    
    datat<- t(data) #transpose and make it wide format
    newdata<- datat[-c(1),] #take away first row (participant)
    #data1 <- as.matrix(data[2:dim(data)[2]])
    
    confidence <- data.frame()
    
    
    cireaches <- unlist(newdata[1, ])
    cireaches <- as.numeric(cireaches)
    
    if (type == "t"){
      cireaches <- cireaches[!is.na(cireaches)]
      citrial <- t.interval(data = cireaches, variance = var(cireaches), conf.level = 0.95)
    } else if(type == "b"){
      citrial <- getBSConfidenceInterval(data = cireaches, resamples = 1000)
    }
    
    if (prod(dim(confidence)) == 0){
      confidence <- citrial
    } else {
      confidence <- rbind(confidence, citrial)
    }
    
    
    cireaches <- unlist(newdata[2,])
    cireaches <- as.numeric(cireaches)
    if (type == "t"){
      cireaches <- cireaches[!is.na(cireaches)]
      citrial <- t.interval(data = cireaches, variance = var(cireaches), conf.level = 0.95)
    } else if(type == "b"){
      citrial <- getConfidenceInterval(data = cireaches, resamples = 1000)
    }
    
    if (prod(dim(confidence)) == 0){
      confidence <- citrial
    } else {
      confidence <- rbind(confidence, citrial)
    }
    write.csv(confidence, file=sprintf('data/%s_CI_reachaftereffects.csv',group), row.names = F)
  }
}

#plot containing reach aftereffects for all groups
#inline means it will plot here in R Studio
plotGroupReachAfterEffects <- function(groups=c('30implicit', '30explicit', 'cursorjump'), target='inline') {
  #but we can save plot as svg file
  if (target=='svg') {
    svglite(file='doc/fig/Fig3_reachaftereffects.svg', width=7, height=4, pointsize=10, system_fonts=list(sans="Arial"))
  }
  
  # create plot
  meanGroupAftereffects <- list() #empty list so that it plots the means last
  
  #NA to create empty plot
  # could maybe use plot.new() ?
  plot(NA, NA, xlim = c(-0.1,1), ylim = c(-5,40), 
       xlab = "Strategy Use", ylab = "Reach Deviation (°)", frame.plot = FALSE, #frame.plot takes away borders
       main = "Group Reach Aftereffects", xaxt = 'n', yaxt = 'n') #xaxt and yaxt to allow to specify tick marks
  abline(h = 30, col = 8, lty = 2) #creates horizontal dashed lines through y =  0 and 30
  axis(1, at=c(0, 1), labels=c('Exclusive', 'Inclusive')) #tick marks for x axis
  axis(2, at = c(0, 10, 20, 30, 40)) #tick marks for y axis
  
  
  for (group in groups) {
    #read in files created by getGroupConfidenceInterval in filehandling.R
    groupconfidence <- read.csv(file=sprintf('data/%s_CI_reachaftereffects.csv',group))
    #take only exclusive first, last and middle columns of file
    lower <- groupconfidence[,1]
    upper <- groupconfidence[,3]
    mid <- groupconfidence[,2]
    
    col <- colourscheme[[group]][['T']] #use colour scheme according to group
    #upper and lower bounds create a polygon
    #polygon creates it from low left to low right, then up right to up left -> use rev
    #x is just trial nnumber, y depends on values of bounds
    
    polygon(x = c(c(0:1), rev(c(0:1))), y = c(lower, rev(upper)), border=NA, col=col)
    
    meanGroupAftereffects[[group]] <- mid #use mean to fill in empty list for each group
  }
  
  for (group in groups) {
    # plot mean reaches for each group
    col <- colourscheme[[group]][['S']]
    stuff<-(meanGroupAftereffects[[group]])
    lines(x=c(0,1), y = c(stuff[1], stuff[2]), col=col, lty=1)
  }
  
  #add legend
  legend(0.5,12.5,legend=c('Implicit 30°','Instructed 30°','Cursor Jump'),
         col=c(colourscheme[['30implicit']][['S']],colourscheme[['30explicit']][['S']],colourscheme[['cursorjump']][['S']]),
         lty=1,bty='n')
  
  #close everything if you saved plot as svg
  if (target=='svg') {
    dev.off()
  }
}

# Statistics-----
reachAftereffectsANOVA <- function() {
  
  # write code!
  
}