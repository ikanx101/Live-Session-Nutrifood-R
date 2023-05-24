library(shiny)
library(openxlsx)

ui <- fluidPage(
  # Survey form components
  textInput("name", "Name:"),
  selectInput("gender", "Gender:", choices = c("Male", "Female", "Other")),
  checkboxInput("agree", "I agree to the terms and conditions."),
  
  # Submit button
  actionButton("submit", "Submit"),
  
  # Download button
  downloadButton("downloadData", "Download Data")
)

server <- function(input, output, session) {
  # Store the survey data
  surveyData <- reactive({data = data.frame(Name = character(),
                                                 Gender = character(),
                                                 Agree = logical())
                               return(data)
                               })
  
  # Submit button observer
  observeEvent(input$submit, {
    # Store the form data
    data <- rbind(surveyData(), data.frame(Name   = input$name,
                                     Gender = input$gender,
                                     Agree  = input$agree))
    # Clear the form inputs
    updateTextInput(session, "name", value = "")
    updateSelectInput(session, "gender", selected = "")
    updateCheckboxInput(session, "agree", value = FALSE)
  })
  
  
  # Download button observer
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("Sales Survey Jotform ", Sys.time(), ".xlsx", sep="")
    },
    content = function(file) {
      openxlsx::write.xlsx(data(), file)
    }
  )

}

shinyApp(ui, server)
