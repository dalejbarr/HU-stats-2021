#' A jet black ggplot2 theme with inverted colors
#'
#' @param base_size Base font size
#' @param base_family Base font family
#' @param ... Passed to \code{\link[ggplot2]{theme}}
#'
#' @importFrom ggplot2 ggplot rel element_text element_rect element_line
#' @importFrom ggplot2 element_blank margin "%+replace%"
#'
#' @export
#'
#' @return An object as returned by \code{\link[ggplot2]{theme}}
#'
#' @examples
#' library(ggplot2)
#' p <- ggplot(mtcars, aes(y = mpg, x = disp, color = factor(cyl)))
#' p <- p + geom_point() + theme_jetblack()
#' p
#' @seealso
#' \code{\link[ggplot2]{theme}}
#
theme_jetblack <- function(base_size = 12, base_family = "") {
  ggplot2::theme_grey(base_size = base_size, base_family = base_family) %+replace%
    ggplot2::theme(
      # Specify axis options
      axis.line = ggplot2::element_blank(),
      axis.text.x = ggplot2::element_text(
        size = base_size * 0.8,
        color = "white",
        lineheight = 0.9
      ),
      axis.text.y = ggplot2::element_text(
        size = base_size * 0.8,
        color = "white",
        lineheight = 0.9
      ),
      axis.ticks = ggplot2::element_line(
        color = "white",
        size = 0.2
      ),
      axis.title.x = ggplot2::element_text(
        size = base_size,
        color = "white",
        margin = margin(
          0, 10, 0,
          0
        )
      ),
      axis.title.y = ggplot2::element_text(
        size = base_size,
        color = "white", angle = 90,
        margin = margin(
          0, 10, 0,
          0
        )
      ),
      axis.ticks.length = ggplot2::unit(0.3, "lines"),
      # Specify legend options
      legend.background = ggplot2::element_rect(
        color = NA,
        fill = "black"
      ),
      legend.key = ggplot2::element_rect(
        color = "white",
        fill = "black"
      ),
      legend.key.size = ggplot2::unit(1.2, "lines"),
      legend.key.height = NULL,
      legend.key.width = NULL,
      legend.text = ggplot2::element_text(
        size = base_size * 0.8,
        color = "white"
      ),
      legend.title = ggplot2::element_text(
        size = base_size * 0.8,
        face = "bold", hjust = 0,
        color = "white"
      ),
      legend.position = "right",
      legend.text.align = NULL,
      legend.title.align = NULL,
      legend.direction = "vertical",
      legend.box = NULL,

      # Specify panel options
      panel.background = ggplot2::element_rect(
        fill = "black",
        color = NA
      ),
      panel.border = ggplot2::element_rect(fill = NA, color = "white"),
      panel.grid.major = ggplot2::element_line(color = "grey35"),
      panel.grid.minor = ggplot2::element_line(color = "grey20"),
      # panel.margin = ggplot2::unit(0.5, "lines"),

      # Specify facetting options
      strip.background = ggplot2::element_rect(
        fill = "grey30",
        color = "grey10"
      ),
      strip.text.x = ggplot2::element_text(
        size = base_size * 0.8,
        color = "white"
      ),
      strip.text.y = ggplot2::element_text(
        size = base_size * 0.8,
        color = "white",
        angle = -90
      ),
      # Specify plot options
      plot.background = ggplot2::element_rect(
        color = "black",
        fill = "black"
      ),
      plot.title = ggplot2::element_text(
        size = base_size * 1.2,
        color = "white"
      ),
      plot.margin = ggplot2::unit(rep(1, 4), "lines")
    )
}

scale_colour_discrete <- function(...) {
  scale_colour_manual(..., values = viridis::viridis(2))
}

options(ggplot2.continuous.colour="viridis")
options(ggplot2.continuous.fill = "viridis")
