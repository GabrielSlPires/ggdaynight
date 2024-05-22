# Ignore vdiffr test on CI
if ((nzchar(Sys.getenv("CI")) ||
     !nzchar(Sys.getenv("NOT_CRAN"))) &&
    identical(Sys.getenv("VDIFFR_RUN_TESTS"), 'false')) {
  #if we are running tests remotely AND
  # we are opting out of using vdiffr
  # assigning a dummy function

  expect_doppelganger <- function(...) {
    testthat::skip("`VDIFFR_RUN_TESTS` set to false on this remote check")
  }
} else {
  expect_doppelganger <- vdiffr::expect_doppelganger
}

# Test for basic usage with default parameters
test_that("Basic usage with default parameters", {
  skip_if(getRversion() < numeric_version("4.4"))
  p <- ggplot2::ggplot(daynight_temperature, ggplot2::aes(datetime, temperature)) +
    geom_daynight() +
    ggplot2::geom_point()

  expect_doppelganger("Basic usage with default parameters", p)
})

# Test for basic usage with faceting by sensor
test_that("Basic usage with faceting by sensor", {
  skip_if(getRversion() < numeric_version("4.4"))
  p <- ggplot2::ggplot(daynight_temperature, ggplot2::aes(datetime, temperature)) +
    geom_daynight() +
    ggplot2::geom_point() +
    ggplot2::facet_wrap(ggplot2::vars(sensor))

  expect_doppelganger("Basic usage with faceting by sensor", p)
})

# Test for usage with lines and color by sensor
test_that("Usage with lines and color by sensor", {
  skip_if(getRversion() < numeric_version("4.4"))
  p <- ggplot2::ggplot(daynight_temperature, ggplot2::aes(datetime, temperature, color = sensor)) +
    geom_daynight() +
    ggplot2::geom_line()

  expect_doppelganger("Usage with lines and color by sensor", p)
})

# Test for custom day and night fill colors, custom sunrise and sunset times, and adjusted alpha
test_that("Custom day and night fill colors, custom sunrise and sunset times, and adjusted alpha", {
  skip_if(getRversion() < numeric_version("4.4"))
  p <- ggplot2::ggplot(daynight_temperature, ggplot2::aes(datetime, temperature, color = sensor)) +
    geom_daynight(
      day_fill = "yellow", night_fill = "blue",
      sunrise = 5, sunset = 20, alpha = 0.5
    ) +
    ggplot2::geom_line(linewidth = 1)

  expect_doppelganger("Custom day and night fill colors", p)
})

# Test for custom day and night fill colors, custom sunrise and sunset times, and adjusted alpha
test_that("Custom day and night fill colors, custom sunrise and sunset times, and adjusted alpha", {
  skip_if(getRversion() < numeric_version("4.4"))
  p <- ggplot2::ggplot(daynight_temperature, ggplot2::aes(datetime, temperature, color = sensor)) +
    geom_daynight(
      day_fill = "yellow", night_fill = "blue",
      sunrise = 5, sunset = 20, alpha = 0.5
    ) +
    ggplot2::geom_line(linewidth = 1)

  expect_doppelganger("Custom day and night fill colors", p)
})

# Test only daytime plot
test_that("Test only daytime plot", {
  skip_if(getRversion() < numeric_version("4.4"))
  data <- daynight_temperature[
    daynight_temperature$datetime > as.POSIXct("2024-04-23 11:00") &
      daynight_temperature$datetime < as.POSIXct("2024-04-23 12:00"),
  ]
  p <- ggplot2::ggplot(data, ggplot2::aes(datetime, temperature, color = sensor)) +
    geom_daynight(
      day_fill = "yellow", night_fill = "blue",
      sunrise = 5, sunset = 20, alpha = 0.5
    ) +
    ggplot2::geom_line(linewidth = 1)

  expect_doppelganger("Only daytime", p)
})

# Test only nighttime plot
test_that("Test only nighttime plot", {
  skip_if(getRversion() < numeric_version("4.4"))
  data <- daynight_temperature[
    daynight_temperature$datetime > as.POSIXct("2024-04-23 19:00") &
      daynight_temperature$datetime < as.POSIXct("2024-04-23 20:00"),
  ]
  p <- ggplot2::ggplot(data, ggplot2::aes(datetime, temperature, color = sensor)) +
    geom_daynight(
      day_fill = "yellow", night_fill = "blue",
      sunrise = 5, sunset = 20, alpha = 0.5
    ) +
    ggplot2::geom_line(linewidth = 1)

  expect_doppelganger("Only nighttime", p)
})
