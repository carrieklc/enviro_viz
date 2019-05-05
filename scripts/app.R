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

# load water use conversion table
water_use <- read_csv("../data/water_use.csv")

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
                             selected = "Albania"),
                 p("Time to take action!", style='font-size:130%'),
                 sliderInput("flushInput", "Reduce toilet flushes a day by?", 
                             min = 0, max = 30, value = 30, post =" flushes", ticks = FALSE),
                 sliderInput("showerInput", "Shortens daily showers by how many mins?",
                             min = 0, max = 30, value = 30, post =" mins", ticks = FALSE),
                 sliderInput("carInput",  "How about car washes per year?",
                             min = 0, max = 30, value = 30, post =" washes", ticks = FALSE),
                 sliderInput("laundryInput", "Reduce laundry loads a week by?",
                             min = 0, max = 30, value = 30, post =" loads", ticks = FALSE)
                 
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot"),
      dataTableOutput("table")
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
  
  # 
  flush <- reactive({
    water_use %>% 
    filter(activity == 'toilet flush (newer toilets)') %>% 
    mutate(activity = ifelse(activity == 'toilet flush (newer toilets)', 'toilet flush', activity)) %>% 
    mutate(`water consumption (m^3)` = round(`water consumption (m^3)`, 3),
           `water saved(m^3)` = round(365 * input$flushInput[1] * `water consumption (m^3)`, 3))
  })
  
  shower <- reactive({
    water_use %>% 
    filter(activity == 'shower (20 minutes)') %>% 
    mutate(activity = ifelse(activity == 'shower (20 minutes)', 'shower', activity)) %>% 
    mutate(`water consumption (m^3)` = round(`water consumption (m^3)`, 3),
           `water saved(m^3)` = round(365 * input$showerInput[1] * `water consumption (m^3)`/20, 3))
  })
  
  car <- reactive({
    water_use %>% 
    filter(activity == 'car wash (by hand - very rough estimate)') %>%
    mutate(activity = ifelse(activity == 'car wash (by hand - very rough estimate)', 'car wash', activity)) %>% 
    mutate(`water consumption (m^3)` = round(`water consumption (m^3)`, 3),
           `water saved(m^3)` = round(input$carInput[1] * `water consumption (m^3)`, 3))
  })
  
  laundry <- reactive({
    water_use %>% 
    filter(activity == 'laundry (1 wash)') %>%
    mutate(activity = ifelse(activity == 'laundry (1 wash)', 'laundry', activity)) %>% 
    mutate(`water consumption (m^3)` = round(`water consumption (m^3)`, 3),
           `water saved(m^3)` = round(52 * input$laundryInput[1] * `water consumption (m^3)`, 3))
  })
  
  full_table <- reactive({
    rbind(flush(), shower(), car(), laundry()) %>% 
      select(-`water consumption (m^3)`)
    })
  
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
  
  # Render Table
  output$table <- renderDataTable({
    datatable(full_table())
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

