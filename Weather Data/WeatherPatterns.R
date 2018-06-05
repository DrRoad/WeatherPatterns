#Setting the working directory
getwd()
setwd("./Weather Data")
getwd()

#Reading the data
Chicago <- read.csv("Chicago-F.csv", row.names=1) #add row.names=1 to assign the first column as the row names of the data
NewYork <- read.csv("NewYork-F.csv", row.names=1)
Houston <- read.csv("Houston-F.csv", row.names=1)
SanFrancisco <- read.csv("SanFrancisco-F.csv", row.names=1)

#Check the datasets
Chicago
NewYork
Houston
SanFrancisco

#Check is these are dataframes
is.data.frame(Chicago) #all of the data inside this dataframe is numeric, so there is no need to store this data as a dataframe, let's convert it to a matrix

#Converting to matrices
Chicago <- as.matrix(Chicago)
NewYork <- as.matrix(NewYork)
Houston <- as.matrix(Houston)
SanFrancisco <- as.matrix(SanFrancisco)

#Check the matrices
is.matrix(Chicago)

#let's put all of them into a list
Weather <- list(Chicago=Chicago, NewYork=NewYork, Houston=Houston, SanFrancisco=SanFrancisco )
Weather

#Let's play with the list
Weather[3]
Weather[[3]]
Weather$Houston

#The Apply Family
#apply= use on a matrix: either the rows or the columns
#tapply= use on a vector to extract subgroups or and apply a function to them 
#by= use on dataframes. Same concept as in group by in SQL
#eapply = use on an environment (E)
#lapply = apply a function to elements of a list (L)
#sapply = a version of lapply. Can simplify (S) the results so it's not presented as a list 
#vapply = has a pre-specified type of return value (V)
#replicate = run a function several times. Usually used with generation of random variables.
#mapply = multivariate (M) version of sapply. Arguments can be recycled.
#rapply = recursive (R) version of lapply.

#Using apply()
?apply #check out what it is
Chicago
apply(Chicago,1, mean) #calculate the mean in each ROW
#check if above is true
mean(Chicago["DaysWithPrecip",]) #correct
#analyze one city
apply(Chicago,1, min)
apply(Chicago,1, max)
#for practice:
apply(Chicago,2, min) #doesn't make much sense, but good to see that "2" corresponds to every COLUMN
apply(Chicago,2, max)
#Compare the means for each city
apply(Chicago,1, mean) 
apply(NewYork,1, mean) 
apply(Houston,1, mean) 
apply(SanFrancisco,1, mean) 


#Recreating the apply function with loops
#Find the mean of each row
#1. via loops
output <- NULL #creating an empty vector
for (i in 1:5){ #run the cycle
  output[i] <- mean(Chicago[i,])
} 
output  
names(output) <- rownames(Chicago)
output

#2. via apply()
apply(Chicago,1,mean)

#using lapply
?lapply
Chicago
t(Chicago) #transposing Chicago matrix
mynewlist <- lapply(Weather, t) #t(Weather$Chicago), t(Weather$NewYork), t(Weather$Houston), t(Weather$SanFrancisco) -> this is what R will do in its backend
mynewlist
#example 2
Chicago
rbind(Chicago, NewRow=1:12)
lapply(Weather, rbind, NewRow=1:12)
#example 3 
?rowMeans
rowMeans(Chicago) #identical to apply(Chicago,1,mean)
lapply(Weather,rowMeans)

#rowMeans
#colMeans
#rowSums
#colSums

#combining lapply with the [ ] operator
Weather 
Weather[[1]][1,1]
Weather$Chicago[1,1]
lapply(Weather, "[",1,1) #Weather$Chicago[1,1], Weather$NewYork[1,1]...
lapply(Weather,"[",1, ) #Weather$Chicago[1,], Weather$NewYork[1,]...
lapply(Weather,"[", ,3) #Weather$Chicago[,3], Weather$NewYork[,3]...

#adding your own functions
Weather
lapply(Weather, rowMeans)
lapply(Weather, function(x) x[1,]) #extracts the first row of each element in the list
lapply(Weather, function(x) x[5,])
lapply(Weather, function(x) x[,12]) #extracts December month of each element in the list
lapply(Weather, function(z) z[1,]-z[2,]) 
lapply(Weather, function(z) round((z[1,]-z[2,])/z[2,],2)) # % temp fluctuation from high to low in each city
 
#Using sapply
Weather
#AvgHigh_F for July:
#with lapply:
lapply(Weather,"[",1,7)
#with sapply:
sapply(Weather,"[",1,7)

#AvgHigh_F for the 4th quarter:
lapply(Weather, "[",1,10:12)
sapply(Weather, "[",1,10:12)

#Another example:
lapply(Weather, rowMeans)
sapply(Weather, rowMeans)
round(sapply(Weather, rowMeans),2)

#another example:
lapply(Weather, function(z) round((z[1,]-z[2,])/z[2,],2))
sapply(Weather, function(z) round((z[1,]-z[2,])/z[2,],2))

#by the way:
sapply(Weather, rowMeans, simplify = FALSE) #same as lapply

#nesting apply functions
Weather
apply(Chicago, 1, max)
#apply across whole list
lapply(Weather, apply, 1, max) #lapply will iterate over through the weather list, it will pass on those matrices one by one,
                              #it will take the matrix and add on these optional arguments    
lapply(Weather, function(x) apply(x,1,max)) #same as above, just a different approach..

#tidy up:
sapply(Weather, apply, 1, max)
sapply(Weather, apply, 1, min)

#which.max
which.max(Chicago[1,]) #returns the maximum value in the first row of Chicago, since its a named vector it will return the output with the name
names(which.max(Chicago[1,]))
#by the sounds of it:
#we will have: apply - to iterate over rows of the matrix,
#and we will have: lapply or sapply - to iterate over component of the list
apply(Chicago,1, function(x) names(which.max(x)))
lapply(Weather, function(y) apply(y,1, function(x) names(which.max(x))))
sapply(Weather, function(y) apply(y,1, function(x) names(which.max(x))))
sapply(Weather, function(y) apply(y,1, function(x) names(which.min(x))))
 






