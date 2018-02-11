##UT PRC
##Rob's group
##11.17.15

############################
##Introduction to R##
############################

#To annotate in R, use the # symbol.)

############################
##R as a calculator
############################

#Basic mathematical computations using +,-, *, /, and ()
2+3
6*7
pi*1  #Notice that pi is hard coded in R
6*3/2-3
6*3/(2-3)
1/0

#run = command enter

#Basic functions
3^2
2^(3+2)
sqrt(9)
pi*2  #pi is hard coded in R
log(1000)  #log() computes natural algorithms by default
exp(10)   

#Ways to get more information on functions:
#Example with log function:
?log
help("log")

##############################
##Objects and Vectors
##############################

##Objects: The Basics:

#Numbers, formulas, data, etc. can be stored as objects in R. 
 
#Objects are given names and are stored in the workspace.

#In R, objects are hidden from view unless they are "called up" by writing the name of the object or by using the ls() command.

x<-2 #Creates the object "x" left facing arrow or equal sign

x    #Shows the contents of object "x"

#The most commonly used operator is "<-", but it is also possible to use "=":
y=3
y

h<-"practice"   #You can also put strings in an object "characters"
h

#R calls strings a "character"
is.character(h) #yes, it is a string variable

#You can also check to see if an object is numeric, integer, factor, etc.
is.integer(h)
is.factor(h)
is.numeric(h)

is.integer(y)
is.numeric(y)
is.factor(y)  #Factor is a categorical variable#

#To change an object to a different type of object:
y_factor<-as.factor(y) #as factor turns it into a factor
is.factor(y_factor)

#(This can useful for variables in a dataset; for example, to let R know that values of 1, 2, 3, represent factors or categories rather than numbers.)


#Objects can have whatever name you choose to give them.  

object.one<-1
object.one

#The function ls() will list all of the objects that have been created:
ls() #gives a "list"

#If you create an object with the name of a previously created object, R will override the original object:
x     #Original object that we created above.
x<-7  #New object with same name
x     #New object

##Vectors: The Basics
#Vectors are objects, usually numeric, that store multiple objects
#Vectors are indexed by positive integers.  Many mathematical functions can operate on each member of a vector (e.g. each number in a vector), and other functions can aggregate members of the vector (e.g. give the mean of the vector).  

#Create a vector with repeated numbers
help(rep)

z<- rep(1,5) #replicate the number 1 5x
z

q<-rep(c(1, 2), 5) #replicate numbers 1 and 2 5x ; c=concatenate
q

t<-rep(c(1,2), c(5, 5)) #first corresponds to first, 
t

#Creating vectors with sequences of numbers
help(seq)

a<-1:5
a

b<-seq(1,5)
b

c<-seq(5,1)
c

d<-seq(from=0, to=15, by=3)
d

e<-seq(0, 15, 3) #this does the same thing as above but w/ less 
e

#To create a vector with specific numbers or objects inside, we need to use the c() -- concatenate-- function:
help(c)

f<-(0, 5, 10)  #What happens?

f<-c(0, 5, 10)
f

#Creating a vector with random numbers using the random numbers distrubiont

#10 random numbers drawn from the normal distribution (mean of 0, standard deviation of 1) -- sampling

g<-rnorm(10, mean=0, sd=1)
g

#10 random numbers drawn from a uniform distribution (each number has an equal probability of being chosen)
help(runif) #random uniform

h<-runif(10, min=0, max=1)
h #this is how you can create a random subset of your data

#See what you have previously created in R:
ls()

#Clear what you have done previously from R:
rm(list=ls()) #clears what you had done
ls()

#Create a new vector with number 0-100, sequenced by 5:
x<-seq(0, 100, 5)
x

#Summarizing the characteristics of vectors

#Length function (this is often used when preparing to write a loop and/or to create an object with the total number of cases) - go from one to the length of this list

n=length(x)
n                #there are 21 items in this list

## Mean and Standard Deviation##
mean(x)
sd(x)

#Round the standard deviation
sd_round<-round(sd(x))
sd_round

#Calculate the mean one piece at a time
#Sum of all the elements
x_sum<-sum(x, na.rm=TRUE)  #na.rm=TRUE removes missing values
x_sum

#Denominator (number of cases)
x_total<-length(x)
x_total

#Mean
x_mean<-x_sum/x_total
x_mean


#Characteristics of vectors
#Boolean operators (logical phrases)

x<60
x<65
x[x<65] #tell me the numbers in x that are less than 65
# bracket = subset command
x>90 & x<100
x[x>90 & x<100]
x[x<10 | x>90]
x[x==60 | x==90]

#You can use these arguments to subset part of the vector in a new object
x_low_high<-x[x<10 | x>90]
x_low_high

x[1:length(x)]  #Going through the whole vector and subsetting elements from the first element through the last element  (This will often be seen in commands for loops)

x_3_n<- x[3:length(x)]  #Same thing, but starting at the 3rd element

#these are useful for writing loops

#A different way to accomplish the same thing:
x[1:n]
x[3:n]

##Last word on vectors: Checking to see if a vector is a vector.
is.vector(x)

#If you needed to convert an object to a vector, you would use the as.vector() command:


#############################
##Topic 3: Arrays/Matrices
##############################

#Create a matrix using the matrix command
x<-matrix(1:12, nrow=3)
x

#Alternatively
y<-matrix(1:12, ncol=4)
y

#Alternatively
z<-1:10 #z = numbers 1 thru 10
matrix.z<-matrix(z, ncol=5)
matrix.z

#Create a matrix of zeroes
matrix.zero<-matrix(0, nrow=5, ncol=5)
matrix.zero

#Put 1s on the diagonal of this matrix
diag(matrix.zero)=1
matrix.zero

#Help for the matrix command:
help(matrix)

#Get matrix dimensions (rows columns)
y
dim(y) #3 rows by 4 columns

#Subsetting elements in a matrix 
#Recall that rows come first, then columns

#Display the number in row 2, column 2
y[2,2]

#Row 1, column 4
y[1,4]

#Display the second row of y
y
y[2,]  #By leaving the column portion blank, the whole row is displayed -- give me the first number, leave the rest blank
#if you only want to see the first five rows, this is how you would do it --> shows all teh columns

#Display the last column of y
y[,3]  #By leaving the row portion blank, the whole column is displayed

#Display the second through fourth columns
y[,2:4]

#Display the second and fourth columns only
y[,c(2,4)]

#Change the value/s of an element or elements in the matrix
#Change all of column 1 to zeros
y[,1]=0
y

#

#Combining columns or rows from different matrices  

#The command cbind combines columns, and the command rbind combines rows.  

#In terms of using real data, rbind could be use to add or combine cases, and cbind could be use to combine variables

#Note: You need to have the same number of columns to use cbind, and rows to use rbind.
#cbind = combine columns, rbind = combine rows
#rbind = add cases into own subset

a<-matrix(1:25, nrow=5)
a

b<-matrix(50:74, nrow=5)
b

#Combine matrix a and b by column.
c<-cbind(a, b)
c

#Combine matrix a and b by row.
d<-rbind(a, b)
d

#Combine column 1 in matrix a with column 1 of matrix b.
ab1<-cbind(a[,c(1)], b[,c(1)])
ab1

#Combine row 5 in matrix a with row 3 in matrix b.
a5b3<-rbind(a[c(5),], b[c(3),])
a5b3

#Another way to do the same thing is to subset the elements of the matrix that you want first, and then "bind" them together

a_row5<-a[c(5),]
a_row5

b_row3<-b[c(3), ]
b_row3

#Combine as rows
rbind(a_row5, b_row3)

#Combine as columns
cbind(a_row5, b_row3)


#######################################
###Mathematical operations using matrices

a<-matrix(1, ncol=5, nrow=5)
a

b<-matrix(5, ncol=5, nrow=5)
b

a-b
b-a
a + b

##Matrix multiplication
c<-matrix(3, ncol=4, nrow=5)
c

dim(c) #Get matrix dimensions

d<-matrix(7, ncol=5, nrow=3)
d

dim(d)  #Get matrix dimensions

c %*% d  #Note that we use %*% to multiply matrices.

d %*% c




