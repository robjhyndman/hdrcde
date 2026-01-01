library(cropcircles)
library(magick)
library(tibble)
library(ggplot2)
library(ggpath)
library(showtext)
library(hdrcde)

# choose a font from Google Fonts
font_add_google("Fira Sans", "firasans")
showtext_auto()

# Melbourne maximum temperatures
#x <- maxtemp[1:3649]
#y <- maxtemp[2:3650]
#maxtemp.cde <- cde(x, y,
#  x.name = "Today's max temperature", y.name = "Tomorrow's max temperature"
#)
#plot(maxtemp.cde, plot.fn="hdr", border = FALSE, yaxt="n",xaxt="n", ylab="",xlab="",bty="n")

img_padded <- image_border(
  image_read(here::here("hex/hdrcde.png")),
  color    = "#eff4f7",
  geometry = "140x140"       # border size in pixels (x- and y-direction)
)

# Write padded image to a temporary file (or a real file if you prefer)
padded_path <- here::here("hex/hdrcde_padded.png")
image_write(img_padded, padded_path)

img_cropped <- hex_crop(
  images = padded_path,
  bg_fill = "#eff4f7",
  border_colour = "#2297e6",
  border_size = 50
)

ggplot() +
  geom_from_path(aes(0.5, 0.5, path = img_cropped)) +
  annotate(
    "text",
    x = 0.33,
    y = 0.16,
    label = "hdrcde",
    family = "firasans",
    size = 24,
    colour = "#0570b7",
    angle = 0,
    hjust = 0,
    fontface = "bold"
  ) +
  xlim(0, 1) +
  ylim(0, 1) +
  theme_void() +
  coord_fixed()

ggsave("./man/figures/hdrcde-hex.png", height = 3, width = 3)

# Trim transparent edges
img <- image_read("./man/figures/hdrcde-hex.png")
img_trim <- image_trim(img)

image_write(img_trim, "./man/figures/hdrcde-hex.png")
