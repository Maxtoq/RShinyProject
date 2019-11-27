library(shiny)
library(leaflet)

# From http://leafletjs.com/examples/choropleth/us-states.js
states <- geojsonio::geojson_read("json/us-states-clear.geojson", what = "sp")
data("USArrests")

bins_Murder <- c(0, 2, 4, 6, 8, 10, 12, 14, 16, Inf)
pal_Murder <- colorBin("YlOrRd", domain = USArrests$Murder, bins = bins_Murder)

bins_Assault <- c(0, 50, 100, 150, 200, 250, 300, 350, Inf)
pal_Assault <- colorBin("YlOrRd", domain = USArrests$Assault, bins = bins_Assault)

bins_Rape <- c(0, 5, 10, 15, 20, 25, 30, 35, 40, Inf)
pal_Rape <- colorBin("YlOrRd", domain = USArrests$Rape, bins = bins_Rape)

ui <- fluidPage(
  titlePanel("US Arrests"),
  mainPanel(
    tabsetPanel(
      tabPanel("Murder",
               leafletOutput("map_Murder")
               ), 
      tabPanel("Assault",
               leafletOutput("map_Assault")
               ), 
      tabPanel("Rape",
               leafletOutput("map_Rape")
               )
    ),
    sidebarLayout(
      sidebarPanel(
        radioButtons("x", "Select X-axis:", 
                     list("Muder"='Murder', "Assault"='Assault', "Rape"='Rape')),
        radioButtons("y", "Select Y-axis:", 
                     list("Muder"='Murder', "Assault"='Assault', "Rape"='Rape'))
      ), 
      mainPanel(
        plotOutput("plot")
      )
    )
  )
)

server <- function(input, output, session) {
  
  output$map_Murder <- renderLeaflet({
    labels <- sprintf(
      "<strong>%s</strong><br/>%g murder arrests / 100 000",
      rownames(USArrests), USArrests$Murder
    ) %>% lapply(htmltools::HTML)
    
    leaflet(states) %>%
      setView(-96, 37.8, 4) %>%
      addProviderTiles("MapBox", options = providerTileOptions(
        id = "mapbox.light",
        accessToken = Sys.getenv('MAPBOX_ACCESS_TOKEN'))) %>%
      addPolygons(
        fillColor = ~pal_Murder(USArrests$Murder),
        weight = 2,
        opacity = 1,
        color = "white",
        dashArray = "3",
        fillOpacity = 0.7,
        highlight = highlightOptions(
          weight = 5,
          color = "#666",
          dashArray = "",
          fillOpacity = 0.7,
          bringToFront = TRUE),
        label = labels,
        labelOptions = labelOptions(
          style = list("font-weight" = "normal", padding = "3px 8px"),
          textsize = "15px",
          direction = "auto")) %>%
      
    addLegend(pal = pal_Murder, values = ~density, opacity = 0.7, title = NULL,
              position = "bottomright")
    
  })
  
  output$map_Assault <- renderLeaflet({
    labels <- sprintf(
      "<strong>%s</strong><br/>%g assault arrests / 100 000",
      rownames(USArrests), USArrests$Assault
    ) %>% lapply(htmltools::HTML)
    
    leaflet(states) %>%
      setView(-96, 37.8, 4) %>%
      addProviderTiles("MapBox", options = providerTileOptions(
        id = "mapbox.light",
        accessToken = Sys.getenv('MAPBOX_ACCESS_TOKEN'))) %>%
      addPolygons(
        fillColor = ~pal_Assault(USArrests$Assault),
        weight = 2,
        opacity = 1,
        color = "white",
        dashArray = "3",
        fillOpacity = 0.7,
        highlight = highlightOptions(
          weight = 5,
          color = "#666",
          dashArray = "",
          fillOpacity = 0.7,
          bringToFront = TRUE),
        label = labels,
        labelOptions = labelOptions(
          style = list("font-weight" = "normal", padding = "3px 8px"),
          textsize = "15px",
          direction = "auto")) %>%
      
      addLegend(pal = pal_Assault, values = ~density, opacity = 0.7, title = NULL,
                position = "bottomright")
    
  })
  
  output$map_Rape <- renderLeaflet({
    labels <- sprintf(
      "<strong>%s</strong><br/>%g rape arrests / 100 000",
      rownames(USArrests), USArrests$Rape
    ) %>% lapply(htmltools::HTML)
    
    leaflet(states) %>%
      setView(-96, 37.8, 4) %>%
      addProviderTiles("MapBox", options = providerTileOptions(
        id = "mapbox.light",
        accessToken = Sys.getenv('MAPBOX_ACCESS_TOKEN'))) %>%
      addPolygons(
        fillColor = ~pal_Rape(USArrests$Rape),
        weight = 2,
        opacity = 1,
        color = "white",
        dashArray = "3",
        fillOpacity = 0.7,
        highlight = highlightOptions(
          weight = 5,
          color = "#666",
          dashArray = "",
          fillOpacity = 0.7,
          bringToFront = TRUE),
        label = labels,
        labelOptions = labelOptions(
          style = list("font-weight" = "normal", padding = "3px 8px"),
          textsize = "15px",
          direction = "auto")) %>%
      
      addLegend(pal = pal_Rape, values = ~density, opacity = 0.7, title = NULL,
                position = "bottomright")
    
  })
  
  output$plot <- renderPlot({
    plot(USArrests[, input$x], USArrests[, input$y], xlab=input$x, ylab=input$y)
  })
}

shinyApp(ui, server)



