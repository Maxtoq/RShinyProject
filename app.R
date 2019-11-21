library(shiny)
library(leaflet)

# From http://leafletjs.com/examples/choropleth/us-states.js
states <- geojsonio::geojson_read("json/us-states-clear.geojson", what = "sp")
data("USArrests")

bins <- c(0, 2, 4, 6, 8, 10, 12, 14, 16, Inf)
pal <- colorBin("YlOrRd", domain = USArrests$Murder, bins = bins)

ui <- fluidPage(
  leafletOutput("mymap"),
  p()
)

server <- function(input, output, session) {
  
  output$mymap <- renderLeaflet({
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
        fillColor = ~pal(USArrests$Murder),
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
      addLegend(pal = pal, values = ~density, opacity = 0.7, title = NULL,
                position = "bottomright")
  })
}

shinyApp(ui, server)



