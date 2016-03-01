library(shiny)
library(dynamicTreeCut)
library(dbscan)
library(ggplot2)

shinyServer(function(input, output) {
  # Create a spot where we can store additional
  # reactive values for this session
  val <- reactiveValues(x = NULL, y = NULL)
  
  # Listen for clicks
  observe({
    # Initially will be empty
    if (is.null(input$clusterClick)) {
      return()
    }
    
    isolate({
      val$x <- c(val$x, input$clusterClick$x)
      val$y <- c(val$y, input$clusterClick$y)
    })
  })
  
  # Count the number of points
  output$numPoints <- renderText({
    length(val$x)
  })
  
  # add points on button click
  observe({
    if (input$add > 0) {
      isolate({
        val$x <- c(val$x,
                   runif(
                     n = input$addpoints,
                     min = -2,
                     max = 2
                   ))
        val$y <-
          c(val$y,
            runif(
              n = input$addpoints,
              min = -2,
              max = 2
            ))
      })
    }
  })
  
  # Clear the points on button click
  observe({
    if (input$clear > 0) {
      val$x <- NULL
      val$y <- NULL
    }
  })
  
  # Generate the plot of the clustered points
  output$clusterPlot <- renderPlot({
    tryCatch({
      # Format the data as a matrix
      data <- data.frame(x = val$x, y = val$y)
      
      # Try to cluster
      # if (length(val$x) <= 1){
      #     stop("We can't cluster less than 2 points")
      # }
      suppressWarnings({
        if (input$method == "kmeans")
          clusterID <-
            kmeans(data, input$kmeans_centers)$cluster+1
        if (input$method == "hclust") {
          if (input$hclust_hork == "hclust_byk")
            clusterID <-
              cutree(hclust(dist(data)), k = input$hclust_k)+1
          if (input$hclust_hork == "hclust_byh")
            clusterID <-
              cutree(hclust(dist(data)), h = input$hclust_h)+1
          if (input$hclust_hork == "hclust_hybrid")
            clusterID <-
              dynamicTreeCut::cutreeDynamic(hclust(dist(data)), distM = as.matrix(dist(data))) +
              1
          if (input$hclust_hork == "hclust_tree")
            clusterID <-
              dynamicTreeCut::cutreeDynamic(hclust(dist(data)), method = "tree") +
              1
        }
        if (input$method == "dbscan")
          clusterID <-
            dbscan(data,
                   eps = input$dbscan_eps,
                   minPts = input$dbscan_minPts)$cluster + 1
        
      })
      # Count the number of clusters
      output$numClusters <-
        renderText({
          length(unique(clusterID))
        })
      
      ggplot(data = data, aes(data$x, data$y)) +
        geom_point(color = clusterID,
                   shape = clusterID,
                   size = 5) +
        coord_cartesian(xlim = c(-2, 2), ylim = c(-2, 2))
    }, error = function(warn) {
      # Otherwise just plot the points and instructions
      valDF <- data.frame(x = val$x, y = val$y)
      ggplot(data = valDF, aes(valDF$x, valDF$y)) +
        geom_point() +
        coord_cartesian(xlim = c(-2, 2), ylim = c(-2, 2)) +
        annotate("text",
                 x = 0,
                 y = 0,
                 label = "Unable to create clusters.\nClick to add more points.")
    })
  })
})