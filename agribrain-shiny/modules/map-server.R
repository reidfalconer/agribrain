map <- function(input, output, session) {
  ns <- session$ns
  
  ############### --------------- Reactives --------------- ###############
  ### filter data
  filter_data <- reactive({
    sites[which(sites$Station == station$location), ]
  })
  
  ### reactive labels
  station_label <- reactive({
    filter_data()$Station
  })
  
  ### reactive labels
  plot_label <- reactive({
    filter_data()$Names
  })
  
  pretty_label <- reactive({
    strsplit(station_label(), ",")[[1]][1] %>%
      sub(" ", "", .)
  })
  
  unit_label <- reactive({
    if(input$units == "Index") {
      return("Soil Moisture Index")
    }
    "Soil Moisture Millimeters"
  })
  
  tide_data <- reactive({
    req(station$location)
    data <- filter_data()
    station <- station_label()
    tz <- data$TZ
    
    data <- rtide::tide_height(
      station, from = input$from, to = input$to,
      minutes = input$interval, tz = tz)
    
    data$TideHeight %<>% round(2)
    data$TimeZone <- tz
    
    if(input$units == "Index"){
      return(data)
    } 
    data$TideHeight <- round(data$TideHeight * 3.3333, 2)
    data
  })
  
  download_data <- reactive({
    data <- tide_data()
    data$DateTime <- as.character(data$DateTime) 
    if(input$units == "Index"){
      return(data %>% setNames(c("Station", "DateTime", "Soil_Moisture_Index", "TimeZone")))
    } 
    data %>% setNames(c("Station", "DateTime", "Soil_Moisture_MM", "TimeZone"))
  })
  
  tide_plot <- reactive({
    data <- tide_data()
    time <- Sys.time()
    time %<>% lubridate::with_tz(tz = data$TimeZone[1])
    
    pad <- (max(data$TideHeight) - min(data$TideHeight))/7
    padrange <- c(min(data$TideHeight) - pad, max(data$TideHeight) + pad)
    
    data  <- data[,c('TideHeight', 'DateTime')] %>%
      setNames(c(unit_label(), "Date-Time"))
    xtsdata <- xts::xts(data, order.by = data$`Date-Time`) 
    xtsdata$`Date-Time` <- NULL
    
    dygraph(xtsdata, height = "10px") %>%
      dyOptions(strokeWidth = 1.5, drawGrid = F, includeZero = F,
                useDataTimezone = T, drawGapEdgePoints = T, rightGap = 15) %>%
      dyRangeSelector() %>%
      dyAxis("y", valueRange = padrange,
             label = unit_label()) %>%
      dyEvent(x = time, label = "Current time", labelLoc = "bottom") %>%
      dyLegend()
  })
  
  tide_table <- reactive({
    data <- tide_data() 
    data$Time <- strftime(data$DateTime, format = "%H:%M %p")
    data$Date <- strftime(data$DateTime, format = "%B %d, %Y")
    data[,c("Date", "Time", "TideHeight")] %>% 
      setNames(c("Date", "Time", unit_label()))
  })
  
  ############### --------------- Reactive Values --------------- ###############
  station <- reactiveValues(location = NULL)
  
  observeEvent(input$search, {
    station$location <- input$search
  })

  observeEvent(input$leaflet_marker_click, {
    station$location <- input$leaflet_marker_click$id
  })

  ############### --------------- Observers --------------- ###############
  observeEvent(c(input$leaflet_marker_click, input$search), {
    req(station$location)
    toggleModal(session, "modal", "open")
  })
  
  # zoom to site on click or search
  observeEvent(input$zoom_to,
               {if(nrow(filter_data()) == 0L){return()}
                 leafletProxy('leaflet') %>%
                   setView(lat = filter_data()$Y, lng = filter_data()$X, zoom = click_zoom)})
  
  ############### --------------- Leaflet --------------- ###############
  # Zoom control 
  observeEvent(input$map_zoom_out ,{
    leafletProxy("leaflet") %>% 
      setView(lat  = (input$leaflet_bounds$north + input$leaflet_bounds$south) / 2,
              lng  = (input$leaflet_bounds$east + input$leaflet_bounds$west) / 2,
              zoom = input$leaflet_zoom - 1)
  })
  observeEvent(input$map_zoom_in ,{
    leafletProxy("leaflet") %>% 
      setView(lat  = (input$leaflet_bounds$north + input$leaflet_bounds$south) / 2,
              lng  = (input$leaflet_bounds$east + input$leaflet_bounds$west) / 2,
              zoom = input$leaflet_zoom + 1)
  })
  
  # map
  output$leaflet <- leaflet::renderLeaflet({
    leaflet(options = leafletOptions(zoomControl = FALSE)) %>%
      
      setView(lat = initial_lat, lng = initial_long, zoom = initial_zoom) %>%
      
      addProviderTiles("Esri.WorldImagery", options = providerTileOptions(opacity = 1), group = "Satelite") %>%
      addTiles(urlTemplate = mapbox_moon, group = "Basemap") %>%
      
      addLayersControl(
        baseGroups = c("Satelite", "Basemap"),
        options = layersControlOptions(collapsed = TRUE),
        position = leaf.pos) %>%
      
      addMarkers(
        data = sites,
        lng = sites$Y, 
        lat = sites$X,
        label = sites$Names,
        layerId = sites$Station,
        icon = makeIcon(
          iconUrl = "input/marker.png",
          iconWidth = 40, iconHeight = 40
        ),
        group = 'sites',
        clusterOptions = markerClusterOptions(showCoverageOnHover = F)
      ) %>%
      addEasyButton(easyButton(icon = "ion-arrow-shrink", position = leaf.pos,
                               title = "Reset View", onClick = JS(paste0("function(btn, map){ map.setView(new L.LatLng(", initial_lat, ", ", initial_long, "), ", initial_zoom, ", { animation: true });}")))) 
    # leaflet::addMiniMap(position = "bottomleft",
    #                     zoomLevelOffset = -8,
    #                     toggleDisplay = T, 
    #                     autoToggleDisplay = T, aimingRectOptions = list(weight = 1),
    #                     tiles =  mapbox_moon)  %>%
  })
  
  ############### --------------- Outputs --------------- ###############
  # plot
  output$plot <- renderDygraph({
    tide_plot()
  })
  
  # table
  output$table <- renderDataTable({
    datatable(tide_table(), options = list(
      pageLength = 500
    ))
  })
  output$uiModal <- renderUI({
    bsModal(ns('modal'), title = div(id = ns('modalTitle'), plot_label()), trigger = 'click2', size = "large",
            div(id = ns("top_row"),
                    sidebarLayout(
                      sidebarPanel(width = 3, id = ns('sidebar'),
                                   div(class = 'control',
                                       div(class = 'label', p("From")),
                                       dateInput(ns("from"), NULL, format = "M d, yyyy"),
                                       div(class = 'label', p("To")),
                                       dateInput(ns("to"), NULL, format = "M d, yyyy", 
                                                 value = Sys.Date() + 1)
                                       ),
                                   div(class = 'control',
                                       div(class = 'label', p("Interval (minutes)")),
                                       numericInput(ns("interval"), NULL, 
                                                    value = 10, min = 0, max = 60, step = 5)),
                                   div(class = 'control',
                                       div(class = 'label', p("Units")),
                                       selectInput(ns("units"), label = NULL, 
                                                   choices = c("Index", "Millimeters"), selected = "meters")),
                                   div(class = 'control',
                                       hr(),
                                       downloadButton(outputId = ns("download"), 
                                                      label = "Download data (csv)", class = 'small-dl'))
                                   ),
                      mainPanel(width = 9,
                                tabsetPanel(id = ns("tabs"),
                                            tabPanel(title = "Plot",
                                                     br(),
                                                     dygraphOutput(ns("plot"), height = "375px")),
                                            tabPanel(title = "Table",
                                                     br(),
                                                     wellPanel(class = 'wellpanel',
                                                       DT::dataTableOutput(ns('table'))
                                                     )
                                                     )))
                      )))
  })
  ############### --------------- Download handlers --------------- ###############
  output$download <- downloadHandler(
    filename = function() {
      paste0(plot_label(), "_", gsub("-", "", as.character(input$from)), "_", gsub("-", "", as.character(input$to)), ".csv")
    },
    content <- function(file) {
      readr::write_csv(download_data(), file)
    }
  )
  
}
