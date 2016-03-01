library(shiny)

shinyUI(navbarPage(
  title = "Clustering Playground",
  tabPanel("Application",
           
           # Create a bootstrap fluid layout
           fluidPage(
             sidebarLayout(
               # Create a panel for additional information
               sidebarPanel(
                 width = 3,
                 h3("1st step - DATA"),
                 sliderInput(
                   "addpoints",
                   "number of random points to add",
                   value = 40,
                   min = 1,
                   max = 200,
                   step = 1
                 ),
                 actionButton("add", "add random points", inline = FALSE),
                 actionButton("clear", "clear points", inline = FALSE),
                 h3("2nd step - METHOD"),
                 radioButtons(
                   "method",
                   "Clustering method:",
                   c(
                     "Hierarchical - hclust" = "hclust",
                     "Centroid     - kmeans" = "kmeans",
                     "Density      - dbscan" = "dbscan"
                     #"Distribution - gaussian" = "gaussian",
                     #"BigData      - clarans" = "clarans",
                     #"BigData      - birch" = "birch"
                   )
                 ),
                 h3("3rd step - PARAMETERS"),
                 conditionalPanel(
                   condition = "input.method=='hclust'",
                   radioButtons(
                     "hclust_hork",
                     "Clustering by h or k:",
                     c(
                       "h - distance limit (cutree on hclust)" = "hclust_byh",
                       "k - number of clusters (cutree on hclust)" = "hclust_byk",
                       "auto - hybrid (dynamicTreeCut on hclust)" = "hclust_hybrid",
                       "auto - tree (dynamicTreeCut on hclust)" = "hclust_tree"
                     )
                   ),
                   conditionalPanel(
                     condition = "input.hclust_hork=='hclust_byh'",
                     sliderInput(
                       "hclust_h",
                       "hclust cutree h",
                       value = 1.5,
                       min = 0.1,
                       max = 6,
                       step = 0.1
                     )
                   ),
                   conditionalPanel(
                     condition = "input.hclust_hork=='hclust_byk'",
                     sliderInput(
                       "hclust_k",
                       "hclust cutree k",
                       value = 4,
                       min = 1,
                       max = 10,
                       step = 1
                     )
                   )
                 ),
                 conditionalPanel(
                   condition = "input.method=='kmeans'",
                   sliderInput(
                     "kmeans_centers",
                     "kmeans centers",
                     value = 4,
                     min = 1,
                     max = 10,
                     step = 1
                   )
                 ),
                 conditionalPanel(
                   condition = "input.method=='dbscan'",
                   sliderInput(
                     "dbscan_eps",
                     "dbscan eps",
                     value = 0.5,
                     min = 0.1,
                     max = 3,
                     step = 0.1
                   ),
                   sliderInput(
                     "dbscan_minPts",
                     "dbscan minPts",
                     value = 5,
                     min = 1,
                     max = 15,
                     step = 1
                   )
                 )
               ),
               
               # Add a panel for the main content
               mainPanel(width = 12 - 3,
                         fluidRow(column(
                           7,
                           h3("points: ", textOutput("numPoints", inline = TRUE), align = "center")
                         ),
                         column(
                           4,
                           h3("clusters: ", textOutput("numClusters", inline = TRUE), align = "center")
                         )),
                         # Create a space for the plot output
                         fluidRow(
                           plotOutput("clusterPlot", "100%", "700px", click = "clusterClick")
                         ))
             )
           )),
  tabPanel(
    "Documentation",
    h1("overview"),
    p("Application is a Playgroud for testing most clustering ethods in R."),
    h1("how to use"),
    p("Usage is split into 3 steps:"),
    h2("STEP 1 - Prepare the data"),
    p("Prepare data for clustering. Following options are available:"),
    p(" - just click on plotting area to add points - or by screen touching on tablets and othern touchable screens"),
    p(" - add bunch of random points using button 'add random points' (You can choose number of points to add using slider)"),
    p(" - if You need to clear points just press button 'clear points'"),
    h2("STEP 2 - Choose clustering method"),
    p("Choose one of possible clustering methods:"),
    p(" - hierarchical clustering with", a(href="https://stat.ethz.ch/R-manual/R-devel/library/stats/html/hclust.html","hclust()")),
    p(" - centroid clustering with", a(href="https://stat.ethz.ch/R-manual/R-devel/library/stats/html/kmeans.html","kmeans()")),
    p(" - density clustering with", a(href="https://cran.r-project.org/web/packages/dbscan/index.html","dbscan()")),
    h2("STEP 3 - Set-up parameters"),
    p("Choose parameters for choosen clustering methods:"),
    p(" - hierarchical - ", a(href="https://stat.ethz.ch/R-manual/R-devel/library/stats/html/hclust.html","hclust()")),
    p(" - - using ", a(href="https://stat.ethz.ch/R-manual/R-devel/library/stats/html/hclust.html","cutree()")," with h parameter	- numeric scalar or vector with heights where the tree should be cut"),
    p(" - - using ", a(href="https://stat.ethz.ch/R-manual/R-devel/library/stats/html/hclust.html","cutree()")," with k parameter	- an integer scalar or vector with the desired number of groups"),
    p(" - - using cutreeDynamic() (", a(href="https://cran.r-project.org/web/packages/dynamicTreeCut/index.html","dynamicTreeCut")," package) with 'hybrid' method"),
    p(" - - using cutreeDynamic() (", a(href="https://cran.r-project.org/web/packages/dynamicTreeCut/index.html","dynamicTreeCut")," package) with 'tree' method"),
    p(" - centroid - ", a(href="https://stat.ethz.ch/R-manual/R-devel/library/stats/html/kmeans.html","kmeans()")),
    p(" - - using centers parameter	- either the number of clusters, say k, or a set of initial (distinct) cluster centres. If a number, a random set of (distinct) rows in x is chosen as the initial centres"),
    p(" - density - ", a(href="https://cran.r-project.org/web/packages/dbscan/index.html","dbscan()")),
    p(" - - using eps parameter	- size of the epsilon neighborhood"),
    p(" - - using minPts parameter	- number of minimum points in the eps region (for core points)."),
    h2("FINAL STEP - See the results"),
    p("on plotting area You will see results. Each cluster is marekd with different color and shape"),
    p("points marked with black circle are not clustered)")
  )
))