# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/

library(shiny)
library(tidyverse)
library(shinyWidgets)
library(DT)
library(forcats)

# Reads data from cleaned file
data <- data <- read_csv("../data/cleaned_water_data.csv") %>%
  mutate(total_water = blue + grey, 
         total_country = population * total_water, 
         selected = "no")

# Names the countries in dataset
country_origin <- sort(unique(data$country))

country_comparison <- sort(unique(data$country))

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Water Consumption Per Capita"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(width = 3,
                 pickerInput("your_country",
                             label = "Select your country", 
                             choices = country_origin, #Select the country of interest. 
                             options = list(`actions-box` = TRUE), 
                             selected = "Canada"),
                 htmlOutput("lines"),
                 pickerInput("comparison_country",
                             label = "Select comparison country", 
                             choices = country_origin, #Select the country of interest. 
                             options = list(`actions-box` = TRUE), 
                             selected = "Albania")
                 
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot")
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  data_input <- reactive({
    data %>%
      filter(country == input$your_country[1]) %>%
      mutate(selected = "yes")
  })
  
  data_input2 <- reactive({
    data %>%
      filter(country == input$comparison_country[1])}
  )
  
  # Water min and max
  max_water <- reactive({
    data %>% 
    filter(total_water == max(.$total_water))}
  )
  
  min_water <- reactive({
    data %>% 
    filter(total_water != 0) %>% 
    filter(total_water == min(.$total_water))}
  )
  
  # Row bind relevant countries
  data_viz <- reactive({rbind(min_water(), max_water(), data_input(), data_input2())})
  
  # Define palette
  cols <- c("no" = "black", "yes" = "red")
  
  # Render plots
  output$distPlot <- renderPlot({
    # generate bins based on input$bins from ui.R
    
    data_viz() %>% 
      ggplot(aes(x=fct_reorder(country, total_water), y = total_water, size = total_country, colour = selected)) +
      theme_bw() + 
      xlab("Country") +
      ylab("Water Use Per Person (m^3/yr)") + 
      ggtitle("Water Footprint by Country") +
      guides(fill=guide_legend(title="Total National Water Use")) +
      scale_colour_manual(values = cols) + 
      geom_point()

  })
}

# Run the application 
shinyApp(ui = ui, server = server)

