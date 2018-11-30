#Let's look at 'for' loops first!

# Create a vector filled with random normal values
u1 <- rnorm(30)
print("This loop calculates the square of the first 10 elements of vector u1")

# Initialize `u squared`
usq <- 0

for(i in 1:10) {
  # i-th element of `u1` squared into `i`-th position of `u squared`
  usq[i] <- u1[i]*u1[i]
  print(usq[i])
}

#now lets try a nested for loop

## Create a 30 x 30 matrix (of 30 rows and 30 columns)
mymat <- matrix(nrow=30, ncol=30)

# For each row and for each column, assign values based on position: 
#product of two indexes

for(i in 1:dim(mymat)[1]) {
  for(j in 1:dim(mymat)[2]) {
    mymat[i,j] = i*j
  }
}

# Just show the upper left 10x10 chunk
mymat[1:10, 1:10]

#Do i always have to use i??

#No!
## Create a 30 x 30 matrix (of 30 rows and 30 columns)
mymat <- matrix(nrow=30, ncol=30)

# For each row and for each column, assign values based on position: 
#product of two indexes

for(z in 1:dim(mymat)[1]) {
  for(p in 1:dim(mymat)[2]) {
    mymat[z,p] = z*p
  }
}

# Just show the upper left 10x10 chunk
mymat[1:10, 1:10]



#Let's do a 3 dimensional array for...fun
# Create your three-dimensional array
my_array <- array(1:20, dim=c(20, 20, 20))

for (i in 1:dim(my_array)[1]) {
  for (j in 1:dim(my_array)[2]) {
    for (k in 1:dim(my_array)[3]) {
      my_array[i,j,k] = i*j*k
    }
  }
}

# Show a 10x10x15 chunk of your array
my_array[1:10, 1:10, 1:15]

#Now let's go onto 'while' loops

# Your User Defined Function
readinteger <- function() 
{ n <- readline(prompt="Please, enter your ANSWER: ") 
} 
response<-as.integer(readinteger()); 

#type any number besides 42 into the console now, then run the rest of the code

while (response!=42) 
{ 
  print("Sorry, the answer to whatever the question MUST be 42");
  response<-as.integer(readinteger()); 
}


#now let's do a repeat loop
readinteger <- function(){
  n <- readline(prompt="Please, enter your ANSWER: ") 
}

repeat {   
  response <- as.integer(readinteger());
  if (response == 42) {
    print("Well done!");
    break
  } else print("Sorry, the answer to whatever the question MUST be 42");
}


#adding breaks to loops
# Make a lower triangular matrix (zeroes in upper right corner)
m=10 
n=10

# A counter to count the assignment
ctr=0

# Create a 10 x 10 matrix with zeroes 
mymat = matrix(0,m,n)

for(i in 1:m) {
  for(j in 1:n) {   
    if(i==j) { 
      break;
    } else {
      # you assign the values only when i<>j
      mymat[i,j] = i*j
      ctr=ctr+1
    }
  }
  print(mymat) 
}

# Print how many matrix cells were assigned
print(ctr)



#example using 'next'
#this code says if a number has a non-zero remainder when divided by 2,
#print it, if not, skip it.

m=20

for (k in 1:m){
  if (!k %% 2)
    next
  print(k)
}


#Vectorization

#you could add a series of numbers together using a loop
a <- 1:10
b <- 1:10

res <- numeric(length = length(a))
for (i in seq_along(a)) {
  res[i] <- a[i] + b[i]
}
res

#why isn't this OK?
#lets look at the ruin time for a bigger example

a <- 1:10000000
b <- 1:10000000

res <- numeric(length = length(a))
system.time(for (i in seq_along(a)) {
  res[i] <- a[i] + b[i]
})
res



"Or we could use the vectorized function '+'"
a <- 1:10
b <- 1:10
res2<-a+b
res2

#lets see how much faster this is for our bigger numbers
a <- 1:10000000
b <- 1:10000000
system.time(res2<-a+b)

#we can sometimes perform operations to vectors of unequal length
a <- 1:10
b <- 1:5
a + b


#this seems weird until we se another example
a <- 1:10
b <- 5
a * b

#what if the longer vector is not a multiple of the shorter vector?
a <- 1:10
b <- 1:7
a + b


#lets look at the apply functions


data = matrix(rnorm(20), nrow=5, ncol=4)

# row sums
apply(data, 1, sum)

# row means
apply(data, 1, mean)

# col sums
apply(data, 2, sum)

# col means
apply(data, 2, mean)

#Let's do lapply now
data = list(l1 = 1:10, l2 = 1000:1020)
lapply(data, mean)

#sapply
data = list(l1 = 1:10, l2 = runif(10), l3 = rnorm(10,2))

lapply(data, mean)
sapply(data, mean)

#tapply
data = c(1:10, rnorm(10,2), runif(10))

groups = gl(3,10)

tapply(data, groups, mean)

#One more tapply example (data,groups,mean)
data(iris)
tapply(iris$Sepal.Length, iris$Species, mean)

#mapply
list(rep(1,4), rep(2,3), rep(3,2), rep(4,1))
mapply(rep, 1:4, 4:1)

#Let's do one real-world 'apply' example
data("mtcars")
mtcars

#2 means that this is applied column wise, "1" would apply is row wise
# 1 would be more closely associated with a for loop
apply(mtcars,1,mean)


apply(mtcars,2,function(x) sin(x))
