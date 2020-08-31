# ------------------------------------------------------------------------------
# Author:  SLC
# Date:    2020-08-11
# Summary: Helper script with relevant functions
# Source:  https://stackoverflow.com/questions/61281600/how-to-do-3d-line-plots-grouped-by-two-factors-with-the-plotly-package-in-r
# ------------------------------------------------------------------------------

library(magrittr)
library(plotly)

calculate_color <- function(df, z_column = "exvac_material") {
  df$color <- character(nrow(df))
  my_colorpalette <- grDevices::colorRamp(c("red", "orange","green3", "blue", "darkviolet"))
  # my_colorpalette <- grDevices::colorRamp(c("red", "blue"))
  for (i in sort(unique(df$scenario))) {
    cond <- df$scenario == i
    my_min <- min(df[cond, z_column])
    my_max <- max(df[cond, z_column])
    my_range <- my_max - my_min
    cols <- my_colorpalette((df[cond, z_column] - my_min)/my_range)
    df$color[cond] <- rgb(red = cols[,1], green = cols[,2], blue = cols[,3], maxColorValue = 255)
  }
  return(df)
}


plot3d <- function(df, z_column = "exvac_material",
                   scenarios = seq(1,4), policies = seq(1,9),
                   stretch_x = 2,
                   z_lim = NULL) {
  assertthat::assert_that(z_column %in% c("exvac_material", "self_sufficiency", "recyc_quota"))
  df <- df[df$scenario %in% scenarios & df$policy %in% policies, ]
  df <- calculate_color(df, z_column = z_column)

  if (z_column == "exvac_material") {
    z_label <- "asdfasdf"
  } else if (z_column == "self_sufficiency") {
    z_label <- "self_sufficiency"
  } else if (z_column == "recyc_quota") {
    z_label <- "recyc_quota"
  }


  annotation_list <- list()
  pos <- 1
  for (i in scenarios) {
    annotation_list[[pos]] <- list(showarrow = F,
                                        x = -i-median(0.1*policies),
                                        y = 40,
                                        z = ifelse(is.null(z_lim), yes = 0, no = z_lim[1]),
                                        text = paste("Scenario", i))
    pos <- pos + 1
  }

  p <- plot_ly(df, x = ~-x, y = ~year, z = ~get(z_column),
               type = 'scatter3d', mode = 'lines',
               color = I(df$color),
               transforms = list(list(type = 'groupby', groups = ~x)),
               line = list(width = 5),
               hoverinfo = 'text',
               text = ~paste("Scenario:", scenario,
                             '<br>Policy: ', policy,
                             '<br>Year: ', year,
                             '<br>', z_column, ": " , round(df[,z_column]))) %>%
    layout(title = paste("Development of", z_label," over 75 years"),
           scene = list(xaxis = list(title = '',
                                     ticktext = as.list(rep(paste("Policy", policies), length(scenarios))),
                                     tickvals = as.list(as.numeric(paste0(rep(-scenarios, each = length(policies)), ".", policies))),
                                     tickmode = "array"),
                        yaxis = list(title = 'Year',
                                     ticktext = list("10", "20", "30", "40", "50", "60", "70"),
                                     tickvals = as.list(seq(10,70,10)),
                                     tickmode = "array"),
                        zaxis = list(title = z_label,
                                     range = z_lim),
                        camera = list(eye = list(x = 2, y = 2, z = 1.25),
                                      # up = list(x = 0, y = 0, z = 1),
                                      center = list(x = 0, y = 0, z = -0.2)),
                        aspectmode = "manual", aspectratio = list(x=stretch_x, y=1, z=1),
                        annotations = annotation_list
                        ))
  return(p)
}


