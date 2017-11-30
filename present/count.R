
words <- scan("mobydick.txt", character(0)) # Read text as a sequence of words
print(length(words))
# trimpunc checks the first and last character in a word,
# and removes them if they are in punc.  The trimmed word
# is returned
trimpunc <- function(word) {
    punc <- c('.', ',', ';', ':', '!', '?', "'", '"')
    chars <- strsplit(word, "")[[1]]
    for(p in punc) {
        if(chars[1] == p) {
            chars <- chars[2:length(chars)]
        }
        if(chars[length(chars)] == p) {
            chars <- chars[1:length(chars)-1]
        }
    }
    return(paste(chars, collapse=''))
}

# wc counts the number of times key is found in text.
# If cs is TRUE, then the comparison in case-sensitive.
# If cs is FALSE the key and the text are both converted
# to lowercase forms.
wc <- function(key, text, cs=FALSE) {
    n <- 0
    if(!cs) {
        key = tolower(key)
    }
    for(word in words) {
        if(!cs) {
            word <- tolower(word)
        }
        word <- trimpunc(word)
        if(key == word) {
            n <- n + 1
        }
    }
    return(n)
}

wc("whale", words, FALSE)
wc("whale", words, TRUE)
wc("Whale", words, TRUE)
wc("Whale", words, TRUE) + wc("whale", words, TRUE)
wc("WHALE", words, TRUE)
wc("pequod", words, FALSE)

trimpunc("whale,")

