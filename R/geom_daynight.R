#' Add Day/Night Pattern to ggplot
#'
#' Adds a day/night pattern to a ggplot object. Daytime is represented by
#' rectangles filled with the specified `day_fill` color and nighttime by
#' rectangles filled with the specified `night_fill` color.
#' The pattern is created along the x-axis, which must be a datetime variable.
#'
#' @param day_fill The fill color for daytime rectangles. Defaults to "white".
#' @param night_fill The fill color for nighttime rectangles. Defaults to "grey30".
#' @param sunrise The hour at which daytime starts. Defaults to 6 (6 AM).
#' @param sunset The hour at which nighttime starts. Defaults to 18 (6 PM).
#' @inheritParams ggplot2::geom_rect
#' @param ... Additional arguments passed to `geom_rect`.
#' @return A ggplot2 layer representing the day/night pattern.
#' @examples
#' data <- open_pneumatron_data("path/to/your/datafile.csv") # add example data
#' ggplot(data, aes(datetime, as.factor(id))) +
#'   geom_daily_pattern(day_fill = "yellow", night_fill = "blue",
#'                      sunrise = 6, sunset = 18, alpha = 0.2) +
#'   geom_line(aes(group = id))
#' @export
geom_daynight <- function(mapping = NULL, data = NULL, stat = "identity",
                          position = "identity", na.rm = FALSE,
                          show.legend = NA, inherit.aes = TRUE,
                          day_fill = "white", night_fill = "grey30",
                          sunrise = 6, sunset = 18, ...) {
  layer <- ggplot2::layer(
    geom = GeomDayNight,
    mapping = mapping,
    data = data,
    stat = stat,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      day_fill = day_fill,
      night_fill = night_fill,
      sunrise = sunrise,
      sunset = sunset,
      ...
    )
  )
  return(layer)
}

# Function to create day/night pattern data
daynight_table <- function(min_datetime, max_datetime, sunrise = 6, sunset = 18) {
  is_daytime <- function(datetime) {
    hour <- as.numeric(format(datetime, "%H"))
    return(hour >= sunrise & hour < sunset)
  }

  datetime_sequence <- seq(from = min_datetime, to = max_datetime, by = "hour")

  daynight <- data.frame(
    datetime = as.numeric(datetime_sequence),
    daytime = is_daytime(datetime_sequence)
  )

  return(daynight)
}

draw_panel_daynight <- function(data, panel_params, coord, day_fill,
                                night_fill, sunrise, sunset) {

  if (!inherits(panel_params$x$scale, "ScaleContinuousDatetime")) {
    warning("In geom_daynight(): 'x' must be a datetime, ignoring output.", call. = FALSE)
    return(grid::nullGrob())
  }

  datetime_range <- panel_params$x$get_limits()
  tz <- panel_params$x$scale$timezone
  datetime_range <- as.POSIXct(datetime_range, tz = tz)

  daynight <- daynight_table(datetime_range[1], datetime_range[2], sunrise, sunset)

  if (!is.na(unique(data[["fill"]]))) {
    message("Ignoring argument 'fill' in geom_daynight, use day_fill and night_fill.")
  }

  common_aes <- c("PANEL", "linewidth", "linetype", "alpha")

  common <- unique(data[, common_aes])
  common$colour = NA
  rownames(common) <- NULL


  if (nrow(daynight) < 2) {
    return(grid::nullGrob())
  }

  day_subset <- daynight[daynight$daytime == TRUE,]$datetime
  data_day <- merge(
    data.frame(
      xmin = day_subset,
      xmax = day_subset + 3600,
      ymin = -Inf,
      ymax = Inf,
      fill = day_fill
    ),
    common
  )

  night_subset <- daynight[daynight$daytime == FALSE,]$datetime
  data_night <- merge(
    data.frame(
      xmin = night_subset,
      xmax = night_subset + 3600,
      ymin = -Inf,
      ymax = Inf,
      fill = night_fill
    ),
    common
  )

  grid::gList(
    GeomRect$draw_panel(data_day, panel_params, coord),
    GeomRect$draw_panel(data_night, panel_params, coord)
  )
}

# ggproto object for day/night pattern geom
GeomDayNight <- ggplot2::ggproto(
  "GeomDayNight", ggplot2::Geom,
  required_aes = "x",
  default_aes = ggplot2::aes(
    colour = NA,
    fill = NA,
    linewidth = 0,
    linetype = 1,
    alpha = 0.3
  ),
  draw_key = ggplot2::draw_key_rect,
  draw_panel = draw_panel_daynight
)
