# a simple for loop
for(i in 1:10) {
    print(i)
}

# a simple example with start, stop, stride
x <- seq(1,10,2)
for(i in x) {
    print(i)
}

# a simple function demonstrating next/break
count <- function(word, c, max=-1) {
    n <- 0
    chars <- strsplit(word, "")[[1]] # create a sequence of characters
    if(max < 0) {
        max <- length(chars) + 1
    }
    for(x in chars) {
        if(x != c) {
            next
        }
        n <- n + 1
        if(n >= max) {
            break
        }
    }
    return(n)
}

count("panama", 'a')

count("panama", 'a', 2)

# Example of how well defined functions are easy to test:
x <- "panama"
if(count(x, 'a') != 3 || count(x, 'a', 2) != 2) {
    print("fail")
} else {
    print("pass")
}

# 'hidden' loop
x <- c(1,2,3,4,5)
min(x)
# min(x) loops over x, but in the underlying C code:
# int i = 0;
# double m = MAX_DBL;
# for(i=0;i<length(x);i++) {
#     if(x[i] < m) {
#         m = x[i];
#     }
# }

# The same is true with raster functions, for example:
#
# daily_max[j] <- max(a[[start_day_seq[j]:end_day_seq[j]]]
#
# must iterate over all pixels similar to:
# m <- inf # not sure what the min double precision is...
# for(i=0; i<nLines; i++) {
#     for(j=0; j < nPixels; j++) {
#         if(x[i][j] < m) {
#             m = x[i][j]
#         }
#     }
# }

