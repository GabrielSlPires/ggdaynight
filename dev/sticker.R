library(ggplot2)
library(ggdaynight)
library(hexSticker)

daynight_temperature

sticker_data <- daynight_temperature[
  daynight_temperature$sensor == "B" &
  daynight_temperature$datetime > lubridate::ymd_h("24-04-23 11") &
  daynight_temperature$datetime < lubridate::ymd_h("24-04-29 14"),]

p <- ggplot(sticker_data,
       aes(datetime, temperature)) +
  geom_daynight(alpha = 0.3, day_fill = "yellow", night_fill = "navy") +
  geom_line(linewidth = 0.25) +
  xlab("") +
  ylab("") +
  theme_classic() +
  theme_transparent() +
  scale_x_datetime(expand = c(0, 0)) +
  theme(axis.text = element_blank(),
        axis.ticks.length = unit(0, "cm"))
p

sticker(
  p,
  s_x = 0.95,
  s_y = 1.05,
  s_width = 1.7,
  s_height = 1,
  package = "ggdaynight",
  p_x = 1,
  p_y = 0.6,
  p_color = "black",
  p_size = 20,
  h_fill = "grey90",
  h_color = "black",
  filename = "inst/figures/ggdaynight.png"
)
