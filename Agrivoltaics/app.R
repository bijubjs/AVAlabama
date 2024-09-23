# Load required libraries
library(arrow, warn.conflicts = FALSE, quietly = TRUE)
library(tidyverse, warn.conflicts = FALSE, quietly = TRUE)
library(shiny, warn.conflicts = FALSE, quietly = TRUE)
library(DT, warn.conflicts = FALSE, quietly = TRUE)
library(moments) # For skewness and kurtosis calculations

# Load the datasets

# Tomato AV:
tav <- as.data.frame(read_feather(file = "Data/tav_profit.feather")) %>% 
  rename(avprofit = tav_profit) %>% 
  mutate(
    avtype = "tav",
    avprofit = round(avprofit, 0),
    yield = round(yield, 0)
  )

# Strawberry AV:
sbav <- as.data.frame(read_feather(file = "Data/sbav_profit.feather")) %>% 
  rename(avprofit = sbav_profit) %>% 
  mutate(
    avtype = "sbav",
    avprofit = round(avprofit, 0),
    yield = round(yield, 0)
  )

# Squash AV:
sqav <- as.data.frame(read_feather(file = "Data/sqav_profit.feather")) %>% 
  rename(avprofit = sqav_profit) %>% 
  mutate(
    avtype = "sqav",
    avprofit = round(avprofit, 0),
    yield = round(yield, 0)
  )

# Combine datasets
combined_data <- bind_rows(tav, sbav, sqav)

# Define UI
ui <- fluidPage(
  titlePanel("Specialty Crop Agrivoltaics in Alabama, USA"),
  titlePanel("Authors: Mishra, B., Miao, R., Musa, N., 
             Mwbaze P., McCall, J., Khanna, M."),
  titlePanel("App Developer: Bijesh Mishra"),
  
  sidebarLayout(
    sidebarPanel(
      width = 2,
      selectInput("dataset", "Select Dataset", 
                  choices = c("Tomato AV" = "tav", 
                              "Strawberry AV" = "sbav",
                              "Summer Squash AV" = "sqav")),
      
      selectInput("al_regs", "Alabama Regions", 
                  choices = unique(combined_data$al_regs), 
                  selected = NULL, multiple = TRUE),
      
      selectInput("array", "Panel Arrays", 
                  choices = unique(combined_data$array), 
                  selected = NULL, multiple = TRUE),
      
      selectInput("panels", "Total Panels", 
                  choices = unique(combined_data$panels), 
                  selected = NULL, multiple = TRUE),
      
      selectInput("elcprc", "Electricity Price ($)", 
                  choices = unique(combined_data$elcprc), 
                  selected = NULL, multiple = TRUE),
      
      selectInput("height", "Panel Height (Ft.)",
                  choices = unique(combined_data$height), 
                  selected = NULL, multiple = TRUE),
      
      selectInput("crop_yield", "Crop Yield", 
                  choices = NULL,  # Start with no choices
                  selected = NULL, multiple = TRUE),
      
      selectInput("crop_price", "Crop Price ($)", 
                  choices = NULL,  # Start with no choices
                  selected = NULL, multiple = TRUE),
      selectInput("group_by", "Group By", 
                  choices = c("Regions" = "al_regs",
                              "Solar Arrays" = "array",
                              "Solar Panels" = "panels",
                              "Electricity Price" = "elcprc",
                              "Panel Height" = "height",
                              "Crop Yield" = "crop_yield",
                              "Crop Price" = "crop_price"),
                  selected = NULL, 
                  multiple = TRUE),
      actionButton("submit", "RUN"),
      actionButton("reset", "RESET"),  # Reset Data button
      downloadButton("download_data", "SAVE")
    ),
    
    mainPanel(
      width = 10,
      tabsetPanel(
        # Filtered Data:
        tabPanel("Result", 
          DTOutput("filtered_data")),
        # Summary of Filtered Data:
        tabPanel("Summary", 
                 DTOutput("summary_table"))
      )
    )
  )
)

# Define server logic
server <- function(input, output, session) {
  
  # Store filtered data in reactiveValues
  rv <- reactiveValues(filtered_data = NULL)  # Initialize as NULL
  
  # Initialize input selections to NULL
  observe({
    updateSelectInput(session, "al_regs", selected = NULL)
    updateSelectInput(session, "array", selected = NULL)
    updateSelectInput(session, "panels", selected = NULL)
    updateSelectInput(session, "elcprc", selected = NULL)
    updateSelectInput(session, "height", selected = NULL)
    updateSelectInput(session, "crop_price", selected = NULL)
    updateSelectInput(session, "crop_yield", selected = NULL)
  })
  
  # Update crop price choices based on dataset selection
  observe({
    if (input$dataset == "tav") {
      updateSelectInput(session, "crop_price", 
                        choices = unique(tav$price), 
                        selected = NULL)
    } else if (input$dataset == "sbav") {
      updateSelectInput(session, "crop_price", 
                        choices = unique(sbav$price), 
                        selected = NULL)
    } else if (input$dataset == "sqav") {
      updateSelectInput(session, "crop_price", 
                        choices = unique(sqav$price), 
                        selected = NULL)
    }
  })
  
  # Update crop yield choices based on dataset selection
  observe({
    if (input$dataset == "tav") {
      updateSelectInput(session, "crop_yield", 
                        choices = unique(tav$yield), 
                        selected = NULL)
    } else if (input$dataset == "sbav") {
      updateSelectInput(session, "crop_yield", 
                        choices = unique(sbav$yield), 
                        selected = NULL)
    } else if (input$dataset == "sqav") {
      updateSelectInput(session, "crop_yield", 
                        choices = unique(sqav$yield), 
                        selected = NULL)
    }
  })

  observeEvent(input$submit, {
    filtered <- combined_data
    if (!is.null(input$al_regs) && length(input$al_regs) > 0) {
      filtered <- filtered %>% filter(al_regs %in% input$al_regs)
    }
    if (!is.null(input$array) && length(input$array) > 0) {
      filtered <- filtered %>% filter(array %in% input$array)
    }
    if (!is.null(input$panels) && length(input$panels) > 0) {
      filtered <- filtered %>% filter(panels %in% input$panels)
    }
    if (!is.null(input$elcprc) && length(input$elcprc) > 0) {
      filtered <- filtered %>% filter(elcprc %in% input$elcprc)
    }
    if (!is.null(input$height) && length(input$height) > 0) {
      filtered <- filtered %>% filter(height %in% input$height)
    }
    if (!is.null(input$crop_yield) && length(input$crop_yield) > 0) {
      filtered <- filtered %>% filter(yield %in% input$crop_yield)
    }
    if (!is.null(input$crop_price) && length(input$crop_price) > 0) {
      filtered <- filtered %>% filter(price %in% input$crop_price)
    }
    # Filter by avtype based on dataset selection
    filtered <- filtered %>% filter(avtype == input$dataset)
    
# rv$filtered_data <- filtered %>% 
#   dplyr::select(
#     Regions = al_regs,
#     `Total Panels` = panels,
#     Arrays = array,
#     `Panel Height` = height,
#     `Electricity Price` = elcprc,
#     `Crop Yield` = yield,
#     `Crop Price` = price,
#     `AV Profit` = avprofit
#   )

  })
  
  output$filtered_data <- renderDT({
    req(rv$filtered_data)  # Only render if filtered_data is not NULL
    rv$filtered_data
    }, options = list(
      pageLength = 10,
      autoWidth = TRUE,
      columnDefs = list(
        list(width = '100px', targets = 0),  # Regions
        list(width = '100px', targets = 1),  # Arrays
        list(width = '100px', targets = 2),  # Total Panels
        list(width = '100px', targets = 3),  # Panel Height
        list(width = '100px', targets = 4),  # Electricity Price
        list(width = '100px', targets = 5),  # Crop Yield
        list(width = '100px', targets = 6),  # Crop Price
        list(width = '100px', targets = 7)   # AV Profit
        )
      )
    )
  
  # CSV Download Handler
  output$download_data <- downloadHandler(
    filename = function() {
      paste(
        "AV_", Sys.Date(),
        ".csv",
        sep = ""
        )
      },
    content = function(file) {
      write.csv(rv$filtered_data,
                file,
                row.names = FALSE)
    }
  )

  # rv$filtered_data <- filtered %>% 
  #   dplyr::select(
  #     Regions = al_regs,
  #     `Total Panels` = panels,
  #     Arrays = array,
  #     `Panel Height` = height,
  #     `Electricity Price` = elcprc,
  #     `Crop Yield` = yield,
  #     `Crop Price` = price,
  #     `AV Profit` = avprofit
  #   )

output$summary_table <- renderDT({
  req(rv$filtered_data)
  data_filtered <- rv$filtered_data
  
  if (nrow(data_filtered) == 0) {
    return(NULL)
  }
  
  # Dynamically group by the selected input column
  group_col <- input$group_by  # Use the reactive 'input' within render block
  
  # Ensure that the selected grouping column exists in the data
  if (!group_col %in% colnames(data_filtered)) {
    stop("Selected grouping column does not exist in the data.")
  }
})
  
  grouped_data <- data_filtered %>%
    group_by(across(all_of(group_col))) %>%  # Group by the selected column
    summarise(
      Mean_Profit = mean(`AV Profit`, na.rm = TRUE),
      Median_Profit = median(`AV Profit`, na.rm = TRUE),
      Mode_Profit = as.numeric(names(sort(table(`AV Profit`),
                                          decreasing = TRUE)[1])),
      Skewness_Profit = skewness(`AV Profit`, na.rm = TRUE),
      Kurtosis_Profit = kurtosis(`AV Profit`, na.rm = TRUE),
      .groups = "drop"  # Ungroup immediately after summarizing
      )
  
  # Render the grouped summary table
  datatable(grouped_data,
            options = list(
              pageLength = 5,
              autoWidth = TRUE
              )
            )
    
  observeEvent(input$reset, {
    # Reset all inputs to their defaults (or NULL)
    updateSelectInput(session, "al_regs", selected = NULL)
    updateSelectInput(session, "array", selected = NULL)
    updateSelectInput(session, "panels", selected = NULL)
    updateSelectInput(session, "elcprc", selected = NULL)
    updateSelectInput(session, "height", selected = NULL)
    updateSelectInput(session, "crop_price", selected = NULL)
    updateSelectInput(session, "crop_yield", selected = NULL)
    
    # Reset the filtered data to NULL
    rv$filtered_data <- NULL
  })
}

# Run the application 
shinyApp(ui = ui, server = server)