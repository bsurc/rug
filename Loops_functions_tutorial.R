#Construct a function
##Let's do a simple example like Pythagoras
###The theorem is this one
h<-sqrt(5^2+10^2)

#Now imagine that you have a list of x and y points and you want to know the distance between them. 
##With a function this could be way easier.

#Lets create some random data

X1<-runif(20, min=0, max=100)
Y1<-runif(20, min=0, max=100)

X2<-runif(20, min=0, max=100)
Y2<-runif(20, min=0, max=100)

coord<-data.frame(cbind(X1,Y1,X2,Y2))

Xdist<-X1-X2
Ydist<-Y1-Y2

coord$Xdist<-Xdist
coord$Ydist<-Ydist

#Now is when we create the function
hyp<- function(c1,c2){
  h<-sqrt((c1^2)+(c2^2))
  return(h)
}

#Let's see if it works

hyp(coord$Xdist[1],coord$Y1[1])


#If we would like to do this for each distance we again would have to copy the duntion and change the number
##Loops save a lot of time of copy paste

for (i in 1:nrow(coord)){
  hyp(coord$Xdist[i],coord$Y1[i])
}

#It does its thing, but we need a place to store it
distances<-c(rep(NA,20))
for (i in 1:nrow(coord)){
  distances[i]<-hyp(coord$Xdist[i],coord$Y1[i])
}


#############coding club tutorial###########
##https://ourcodingclub.github.io/tutorials/
#Load libraries

library(dplyr)
library(ggplot2)
library(gridExtra)

#Set the working directory
setwd("C:/Users/cristinabarberal/Documents/Courses/Loops and functions")

#Because we set our working directory we do not have to specify all the path to our csv
LPI <- read.csv("LPI_data_loops.csv")

#Scatter plot of vulture populations between 1970 and 2017 in Croatia and Italy

vulture <- filter(LPI, Common.Name == "Griffon vulture / Eurasian griffon")
vultureITCR <- filter(vulture, Country.list == c("Croatia", "Italy"))

(vulture_scatter <- ggplot(vultureITCR, aes(x = year, y = abundance, colour = Country.list)) +
    geom_point(size = 2) +                                              # Changing point size
    geom_smooth(method = lm, aes(fill = Country.list)) +                # Adding a linear model fit and colour-coding by country
    scale_fill_manual(values = c("#EE7600", "#00868B")) +               # Adding custom colours
    scale_colour_manual(values = c("#EE7600", "#00868B"),               # Adding custom colours
                        labels = c("Croatia", "Italy")) +               # Adding labels for the legend
    ylab("Griffon vulture abundance\n") +                             
    xlab("\nYear")  +
    theme_bw() +
    theme(axis.text.x = element_text(size = 12, angle = 45, vjust = 1, hjust = 1),       # making the years at a bit of an angle
          axis.text.y = element_text(size = 12),
          axis.title.x = element_text(size = 14, face = "plain"),             
          axis.title.y = element_text(size = 14, face = "plain"),             
          panel.grid.major.x = element_blank(),                                # Removing the background grid lines                
          panel.grid.minor.x = element_blank(),
          panel.grid.minor.y = element_blank(),
          panel.grid.major.y = element_blank(),  
          plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), units = , "cm"),           # Adding a 0.5cm margin around the plot
          legend.text = element_text(size = 12, face = "italic"),              # Setting the font for the legend text
          legend.title = element_blank(),                                      # Removing the legend title
          legend.position = c(0.9, 0.9)))               # Setting the position for the legend - 0 is left/bottom, 1 is top/right

#This is really long!! Do you want to have to type all of this for each subset?

theme_my_own <- function(){
  theme_bw()+
    theme(axis.text.x = element_text(size = 12, angle = 45, vjust = 1, hjust = 1),
          axis.text.y = element_text(size = 12),
          axis.title.x = element_text(size = 14, face = "plain"),             
          axis.title.y = element_text(size = 14, face = "plain"),             
          panel.grid.major.x = element_blank(),                                          
          panel.grid.minor.x = element_blank(),
          panel.grid.minor.y = element_blank(),
          panel.grid.major.y = element_blank(),  
          plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), units = , "cm"),
          plot.title = element_text(size = 20, vjust = 1, hjust = 0.5),
          legend.text = element_text(size = 12, face = "italic"),          
          legend.title = element_blank(),                              
          legend.position = c(0.9, 0.9))
}

#Now we create the same plot using our new function

(vulture_scatter <- ggplot(vultureITCR, aes (x = year, y = abundance, colour = Country.list)) +
    geom_point(size = 2) +                                                
    geom_smooth(method = lm, aes(fill = Country.list)) +                    
    theme_my_own() +                                                    # Adding our new theme!
    scale_fill_manual(values = c("#EE7600", "#00868B")) +               
    scale_colour_manual(values = c("#EE7600", "#00868B"),               
                        labels = c("Croatia", "Italy")) +                 
    ylab("Griffon vulture abundance\n") +                             
    xlab("\nYear"))


#Lets make other plots

LPI.UK <- filter(LPI, Country.list == "United Kingdom")

# Pick 4 species and make scatterplots with linear model fits that show how the population has varied through time
# Careful with the spelling of the names, it needs to match the names of the species in the LPI.UK dataframe

house.sparrow <- filter(LPI.UK, Common.Name == "House sparrow")
great.tit <- filter(LPI.UK, Common.Name == "Great tit")
corn.bunting <- filter(LPI.UK, Common.Name == "Corn bunting")
reed.bunting <- filter(LPI.UK, Common.Name == "Reed bunting")
meadow.pipit <- filter(LPI.UK, Common.Name == "Meadow pipit")

#Now the plots

(house.sparrow_scatter <- ggplot(house.sparrow, aes (x = year, y = abundance)) +
    geom_point(size = 2, colour = "#00868B") +                                                
    geom_smooth(method = lm, colour = "#00868B", fill = "#00868B") +          
    theme_my_own() +
    labs(y = "Abundance\n", x = "", title = "House sparrow"))

(great.tit_scatter <- ggplot(great.tit, aes (x = year, y = abundance)) +
    geom_point(size = 2, colour = "#00868B") +                                                
    geom_smooth(method = lm, colour = "#00868B", fill = "#00868B") +          
    theme_my_own() +
    labs(y = "Abundance\n", x = "", title = "Great tit"))

(corn.bunting_scatter <- ggplot(corn.bunting, aes (x = year, y = abundance)) +
    geom_point(size = 2, colour = "#00868B") +                                                
    geom_smooth(method = lm, colour = "#00868B", fill = "#00868B") +          
    theme_my_own() +
    labs(y = "Abundance\n", x = "", title = "Corn bunting"))

(meadow.pipit_scatter <- ggplot(meadow.pipit, aes (x = year, y = abundance)) +
    geom_point(size = 2, colour = "#00868B") +                                                
    geom_smooth(method = lm, colour = "#00868B", fill = "#00868B") +          
    theme_my_own() +
    labs(y = "Abundance\n", x = "", title = "Meadow pipit"))

#Let's put them all together

panel <- grid.arrange(house.sparrow_scatter, great.tit_scatter, corn.bunting_scatter, meadow.pipit_scatter, ncol = 2)
ggsave(panel, file = "Pop_trend_panel.png", width = 10, height = 8)
dev.off() # to close the image

#Loops to make this even faster
##We make a list with all our subsets
Sp_list <- list(house.sparrow, great.tit, corn.bunting, meadow.pipit)

#And here it is our loop
for (i in 1:length(Sp_list)) {                                    # For every item along the length of Sp_list we want R to perform the following functions
  data <- as.data.frame(Sp_list[i])                               # Create a dataframe for each species
  sp.name <- unique(data$Common.Name)                             # Create an object that holds the species name, so that we can title each graph
  plot <- ggplot(data, aes (x = year, y = abundance)) +               # Make the plots and add our customised theme
    geom_point(size = 2, colour = "#00868B") +                                                
    geom_smooth(method = lm, colour = "#00868B", fill = "#00868B") +          
    theme_my_own() +
    labs(y = "Abundance\n", x = "", title = sp.name)
#Cool short cut: paste function
  ggsave(plot, file = paste(sp.name, ".pdf", sep = ''), scale = 2)       # save plots as .pdf, you can change it to .png if you prefer that
  
  print(plot)                                                      # print plots to screen
}

