# create a simple directory watcher
watch <- function(dir) {
    # on start up, get a listing of the directory
    files <- Sys.glob(file.path(dir, "*"))
    for(i in 1:20) {
        Sys.sleep(1)
        fs <- Sys.glob(file.path(dir, "*"))
        new <- setdiff(fs, files)
        now <- format(Sys.time(), "%a %b %d %X %Y")
        for(f in new) {
            cat(paste(now, f), file="watch.txt", append=TRUE, sep="\n")
        }
        files <- fs
    }
}
watch("./")
