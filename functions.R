#### Functioner i R

interpoler<-function(a0,y0,a1,y1,a) y0+(y1-y0)/(a1-a0)*(a-a0)
calc.perc<-function(m,l,s,z) return(as.numeric(m*(1+l*s*z)^(1/l)))
calc.zscore<-function(y,m,l,s) return((((y/m)^l)-1)/(l*s))

zScore <- function(modelData, newData){
  modelData0 <- subset(modelData,select=c(age,m,sigma,nu)) # select only needed columns
  modelData0 <- modelData0[order(modelData0$age),]
  
  colnames(newData) <- c("id", "age", "ratio") # set new column names
  newData <- newData[order(newData$age),]
  newData$age[newData$age<0.2]<-0.19
  age.seq<-newData$age
  
  md.new<-data.frame(modelData0)[c(),]
  res0<-data.frame(modelData0)[c(),]
  age<-modelData0$age
  n<-length(age)
  
  for(a in age.seq){
    
    # Hvis alderen er udenfor intervallet hvor der haves lms-værdier returneres NA
    if ((a<age[1]) || (a>age[n])) {res<-res0; res[1,]<-c(a,NA,NA,NA)} else
      # Den mindste og største alder og deres lms-værdier beholdes
      if ((a<min(age)+0.000001)&&(a>min(age)-0.000001)) res<-modelData0[1,] else
        if ((a<max(age)+0.000001)&&(a>max(age)-0.000001)) res<-modelData0[n,] else
        {
          # Her beregnes lms-værdier for en alder
          # Find to nærmeste aldre på hver side af ax
          # Position i og i+1
          i <- sum(age < a)
          a0 <- age[i]
          a1 <- age[i+1]
          # M
          y0 <- modelData0$m[i]
          y1 <- modelData0$m[i+1]
          m.a <- interpoler(a0,y0,a1,y1,a)
          # S
          y0 <- modelData0$sigma[i]
          y1 <- modelData0$sigma[i+1]
          sigma.a <- interpoler(a0,y0,a1,y1,a)
          # L
          y0 <- modelData0$nu[i]
          y1 <- modelData0$nu[i+1]
          nu.a <- interpoler(a0,y0,a1,y1,a)
          
          res<-data.frame(modelData0)[1,]
          res[1,]<-c(a,m.a,sigma.a,nu.a)
        }
        
        md.new<-rbind(md.new,res)
  }
  
  newData <-cbind(md.new,newData)
  
  # Beregn z-scorer for hver person
  newData.z <- apply(newData,1,function(x) calc.zscore(x[7],x[2],x[4],x[3]))
  
  newData <- cbind(newData,newData.z)
  names(newData)[8]<-"z"
  newData <- subset(newData,select=c(id,age,ratio,z))
  
  return(newData)
}
