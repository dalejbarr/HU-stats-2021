library("shiny")
library("ggplot2")

ui <- shinyUI(fluidPage(  
  titlePanel("Logistic Regression"),
  sidebarLayout(position = "left",
                sidebarPanel("Parameters",
                             sliderInput("b0", "beta_0 (Intercept)", -4, 4, 0, step = .1),
                             sliderInput("b1", "beta_1 (slope)", -4, 4, 0, step = .1),
                             textOutput("or")),
                mainPanel(fluidRow(
                  splitLayout(cellWidths = c("47%", "47%"),
                              plotOutput("logit"),
                              plotOutput("prob"))))
                )
))

server <- shinyServer(function(input, output, session) {
  
  output$logit <- renderPlot({
    ggplot(tibble::tibble(x = c(-4, 4), y = c(-4, 4)), aes(x, y)) +
      stat_function(fun = function(x) {input$b0 + input$b1 * x}, geom = "line") +
      coord_cartesian(xlim = c(-4, 4), ylim = c(-12, 12)) +
      ggtitle(expression(log(frac(p , 1-p)) == beta[0] + beta[1] * x)) +
      ylab("log odds")
  })

  output$prob <- renderPlot({
    ggplot(tibble::tibble(x = c(-4, 4), y = c(0, 1)), aes(x, y)) +
      stat_function(fun = function(x) {1 / (1 + exp(-(input$b0 + input$b1 * x)))},
                    geom = "line") +
      coord_cartesian(xlim = c(-4, 4), ylim = c(0, 1)) +
      ggtitle(expression(p == frac(1, 1 + exp(-(beta[0] + beta[1] * x))))) +
      ylab("probability")
  })

  output$or <- renderText({
    sprintf("Odds Ratio (exp(beta_1)) = %0.3f", exp(input$b1))
  })
})

shinyApp(ui, server)
