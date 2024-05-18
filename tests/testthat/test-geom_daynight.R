# Test for basic usage with default parameters
test_that("Basic usage with default parameters", {
  p <- ggplot2::ggplot(daynight_temperature, ggplot2::aes(datetime, temperature)) +
    geom_daynight() +
    ggplot2::geom_point()

  vdiffr::expect_doppelganger("Basic usage with default parameters", p)
})

# Test for basic usage with faceting by sensor
test_that("Basic usage with faceting by sensor", {
  p <- ggplot2::ggplot(daynight_temperature, ggplot2::aes(datetime, temperature)) +
    geom_daynight() +
    ggplot2::geom_point() +
    ggplot2::facet_wrap(ggplot2::vars(sensor))

  vdiffr::expect_doppelganger("Basic usage with faceting by sensor", p)
})

# Test for usage with lines and color by sensor
test_that("Usage with lines and color by sensor", {
  p <- ggplot2::ggplot(daynight_temperature, ggplot2::aes(datetime, temperature, color = sensor)) +
    geom_daynight() +
    ggplot2::geom_line()

  vdiffr::expect_doppelganger("Usage with lines and color by sensor", p)
})

# Test for custom day and night fill colors, custom sunrise and sunset times, and adjusted alpha
test_that("Custom day and night fill colors, custom sunrise and sunset times, and adjusted alpha", {
  p <- ggplot2::ggplot(daynight_temperature, ggplot2::aes(datetime, temperature, color = sensor)) +
    geom_daynight(
      day_fill = "yellow", night_fill = "blue",
      sunrise = 5, sunset = 20, alpha = 0.5
    ) +
    ggplot2::geom_line(linewidth = 1)

  vdiffr::expect_doppelganger("Custom day and night fill colors", p)
})
