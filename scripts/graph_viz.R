library(tidyverse)
library(ggplot2)
library(dplyr)
library(forcats)
library(scales) 

# Load in water dataset
data <- read.csv("../data/cleaned_water_data.csv")

# Calculate total water used column
data <- data %>% 
  mutate(total_water = blue + grey, 
         total_country = population * total_water, 
         selected = "no")

# Country with maximum water use
max <- data %>%
  filter(total_water == max(.$total_water))

# Country with minimum water use
min <- data %>%
  filter(total_water != 0) %>%
  filter(total_water == min(.$total_water))

# Chosen country
select_ctry <- "Canada"
select <- data %>% 
  filter(country == select_ctry) %>%
  mutate(selected = "yes")



# Comparison country
compare_ctry <- "USA"
compare_ctry <- data %>%
  filter(country == compare_ctry)

# Row bind relevant countries
data_viz <- rbind(min, max, select, compare_ctry)

# Drop unused factors for countries
data_viz$country <- data_viz$country %>%
  fct_drop()

# Define palette for discrete scale
cols <- c("no" = "black", "yes" = "red")

cap_text <- paste("Size of dots represents total water use of the country.\nThe average person in", select_ctry, "uses",
               round(select$total_water, 0), "m^3 of water per year domestically.")
  
# Visualize
data_viz %>% ggplot(aes(x=fct_reorder(data_viz$country, data_viz$total_water), y=total_water, size=total_country, colour=selected)) +
  theme_bw() + 
  labs(x="Country", 
       y="Water Use Per Person (m³/yr)", 
       caption = cap_text, 
       size='Total National Water Use (m³/yr)') +
  ggtitle("Water Footprint by Country") +
  scale_colour_manual(values = cols) + 
  geom_point() +
  theme(plot.caption = element_text(hjust = 0), 
        legend.position="none",
        plot.title = element_text(hjust = 0.5)) +
  guides(colour=FALSE) +
  scale_fill_gradient(labels = comma)

