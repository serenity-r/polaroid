#' @import argonDash
#' @import argonR
#' @import colourpicker
#' @import ggplot2
#' @import grid
#' @import hexSticker
#' @import png
#' @import shiny
#' @import shinyWidgets

## Loading Google fonts (http://www.google.com/fonts)
#font_add_google("Quicksand", "QS")
## Automatically use showtext to render text for future devices
#showtext_auto()

library(argonDash)
library(argonR)
library(colourpicker)
library(ggplot2)
library(grid)
library(hexSticker)
library(png)
library(shiny)
library(shinyWidgets)

# action button with type : default, primary, info, success, danger, warning, secondary
myButton <- function (inputId, label, icon = NULL, width = NULL, type = 'default', ...) {
  value <- restoreInput(id = inputId, default = NULL)
  tags$button(id = inputId, style = if (!is.null(width))
    paste0("width: ", validateCssUnit(width), ";"),
    type = "button", class = paste0("btn btn-", type, " action-button"),
    `data-val` = value, list(icon, label),
    ...)
}

myDnButton <- function (outputId, label = "Download", type = 'default', ...) {
  aTag <- tags$a(
    id = outputId, href = "", target = "_blank",
    class = paste0("btn btn-", type, " shiny-download-link" ),
    download = NA, icon("download"), label, ...
  )
}

ui <- argonDashPage(
  title = "polaroid",
  description = "shiny application to make hex sticker",
  author = "jhk0530",
  sidebar = argonDashSidebar(
    vertical = TRUE,
    skin = "light",
    background = "white",
    size = "md",
    side = "left",
    id = "my_sidebar",
    brand_url = "https://github.com/jhk0530/polaroid",
    brand_logo = 'polaroid_sticker.png',
    argonSidebarDivider(),
    myButton(inputId = 'polaroid', label = 'Example', icon = argonIcon('favourite-28'), type = 'success'),
    argonSidebarDivider(),
    fileInput("file", "Background Image (PNG)", accept = ".png"),
    argonSidebarDivider(),
    myButton(inputId = 'play', label = 'Draw Again', icon = argonIcon('camera-compact'), type = 'primary'),
    argonSidebarDivider(),
    myDnButton("imgdn", type = 'danger')
  ),
  header = argonDashHeader(
    gradient = TRUE,
    color = "primary",
    separator = TRUE,
    separator_color = "default",
    top_padding = 5
  ),
  body = argonDashBody(
    tags$head(tags$style(type = "text/css", "#my_sidebar {overflow:inherit;}")),
    tags$head(tags$style(type = "text/css", "html, body, .main-content {height : 100%; }")),
    tags$head(tags$style(type = "text/css", "#tab-shot {background:#70390d !important}")),
    tags$head(tags$style(type = "text/css", "#img {margin:auto !important}")),
    tags$head(tags$style(type = "text/css", ".navbar-brand-img {height:8em; max-height:none !important;}")),
    tags$head(tags$style(type = "text/css", ".footer {background: #172b4d; bottom: 2em; border-radius: 1em; padding: 0.2rem; width: 95%; position: absolute;}")),
    tags$head(tags$style(type = "text/css", ".footer .nav .nav-item .nav-link, .font-weight-bold {font-size:1.5em; color:#FFFFFF !important; font-weight:bold; }")),
    setSliderColor(rep("#6772e5", 11), 1:11),
    shiny::fluidRow(
      shiny::column(
        argonCard(
          icon = argonIcon("check-bold"),
          plotOutput("img", width = 259, height = 300),
          width = 12
        ),
        style='text-align:center',
        width = 12
      ),

      shiny::column(
        argonCard( # img
          "Hexagon",
          shiny::fluidRow(
            shiny::column(colourInput(inputId = 'background_color', label = 'Background',value = '#172b4d'),width = 12) # background_color
          ),
          shiny::fluidRow(
            shiny::column(colourInput(inputId = 'border_color', label = 'Border',value = '#6772E5'),width = 12) # border_color
          ),
          width = 12
        ),
        width = 3
      ),
      shiny::column(
        argonCard( # img
          "Image",
          shiny::fluidRow(
            shiny::column(
              sliderInput(inputId = 'img_x', label = 'X', value = 0.5, step = 0.05, min = -2, max = 2), width = 6 # img_x
            ),
            shiny::column(
              sliderInput(inputId = 'img_y', label = 'Y', value = 0.4, step = 0.05, min = -2, max = 2), width = 6 # img_y
            )
          ),
          shiny::fluidRow(
            shiny::column(
              sliderInput(inputId = 'img_width', label = 'Width', value = 1, step = 0.1, min = 0, max = 10), width = 6 # img_width
            ),
            shiny::column(
              sliderInput(inputId = 'img_height', label = 'Height', value = 1, step = 0.1, min = 0, max = 10), width = 6 # img_height
            )
          ),
          width = 12
        ),
        width = 3
      ),
      shiny::column(
        argonCard( # url
          'URL',
          shiny::fluidRow(
            shiny::column(
              textInput(inputId = 'url', label = 'Name',value = 'jhk0530/polaroid', placeholder = 'jhk0530/polaroid'), # url
              width = 6
            ),
            shiny::column(
              colourInput(inputId = 'url_color', label = 'Color',value = '#FFFFFF'), # url color
              width = 6
            )
          ),
          shiny::fluidRow(
            shiny::column(
              sliderInput(inputId = 'url_x', label = 'X', value = 1, step = 0.01,min = 0, max = 5 ), width = 6# urlx
            ),
            shiny::column(
              sliderInput(inputId = 'url_y', label = 'Y', value = 0.08, step = 0.01,min = 0, max = 5), width = 6 # urly
            )
          ),
          shiny::fluidRow(
            shiny::column(
              sliderInput(inputId = 'url_size', label = 'Size', value = 15, min = 0, max = 40, step = 0.5), # url size
              width = 6
            ),
            shiny::column(
              sliderInput(inputId = 'url_angle',label = 'Angle', value = 30, min = 0, max = 360, step = 30), # url angle
              width = 6
            )
          ),
          width = 12,
        ),
        width = 3
      ),
      shiny::column(
        argonCard(
          'Package',
          shiny::fluidRow(
            shiny::column(
              textInput(inputId = 'pkg_name', label = 'Name', value = 'polaroid', placeholder = 'polaroid'), width = 6 # pkg
            ),
            shiny::column(
              colourInput(inputId = 'pkg_color', label = 'Color',value = '#FFFFFF'), # pkg color
              width = 6)
          ),
          shiny::fluidRow(
            shiny::column(
              sliderInput(inputId = 'pkg_x', label = 'X', value = 1, step = 0.1,min = 0, max = 3), width = 6# pkgx
            ),
            shiny::column(
              sliderInput(inputId = 'pkg_y', label = 'Y', value = 1.6, step = 0.1,min = 0, max = 3), width = 6 # pkgy
            )
          ),
          sliderInput(inputId = 'pkg_size', label = 'Size', value = 32, min = 0, max = 50, step = 0.5), # pkg size
          width = 12,
        ),
        width = 3
      )
    )
  ),
  footer = argonDashFooter(
    copyrights = "@jhk0530, 2020",
    src = "https://github.com/jhk0530",
    argonFooterMenu(
      argonFooterItem(argonIcon("app"), "hexSticker", src = "https://github.com/GuangchuangYu/hexSticker"),
      argonFooterItem(argonIcon("palette"), "Argon", src = "https://rinterface.github.io/argonDash/")
    )
  )
)

server <- function(input, output, session) {
  mysticker <- function(im, img_x, img_y, img_width, img_height,
                        pkg_name, pkg_x, pkg_y, pkg_color, pkg_size,
                        background_color , border_color,
                        url, urlx, urly, url_color, url_size, url_angle, font_family = "Aller_Rg") {
    border_width = 1.5

    ggplot() +
      geom_hexagon(border_width, background_color, border_color) +
      geom_pkgname(pkg_name, pkg_x, pkg_y, pkg_color, font_family, pkg_size) +
      geom_url(url, urlx, urly, font_family, url_size, url_color, url_angle) +
      annotation_custom(rasterGrob(im, interpolate = FALSE), img_x, img_x + img_width, img_y, img_y + img_height) +
      theme_sticker(size = h_size)
  }

  observeEvent(input$polaroid, {
    im <<- readPNG('nut.png')
    s <- mysticker(im, input$img_x, input$img_y, input$img_width, input$img_height,
                   input$pkg_name, input$pkg_x, input$pkg_y, input$pkg_color, (input$pkg_size*2/5),
                   input$background_color, input$border_color,
                   input$url, input$url_x, input$url_y, input$url_color, (input$url_size*2/5), input$url_angle)
    output$img <- renderPlot(s, width = 259, height = 300, res = 72, execOnResize = TRUE)

    output$imgdn <- downloadHandler(
      filename = "my_polaroid_sticker.png",
      content = function(file = filename) {
        save_sticker(filename = file, sticker =  s)
      }
    )
  })

  observeEvent(input$file, {
    infile <- input$file
    if (is.null(infile)) {
      return(NULL)
    }
    im <<- readPNG(infile$datapath)
    s <- mysticker(im, input$img_x, input$img_y, input$img_width, input$img_height,
                   input$pkg_name, input$pkg_x, input$pkg_y, input$pkg_color, (input$pkg_size*2/5),
                   input$background_color, input$border_color,
                   input$url, input$url_x, input$url_y, input$url_color, (input$url_size*2/5), input$url_angle)

    output$img <- renderPlot(s, width = 259, height = 300, res = 72, execOnResize = TRUE)

    output$imgdn <- downloadHandler(
      filename = "my_polaroid_sticker.png",
      content = function(file = filename) {
        save_sticker(filename = file, sticker =  s)
      }
    )
  })

  observeEvent(input$play,{
    infile <- input$file
    if (is.null(infile)) {
      return(NULL)
    }
    im <<- readPNG(infile$datapath)
    s <- mysticker(im, input$img_x, input$img_y, input$img_width, input$img_height,
                   input$pkg_name, input$pkg_x, input$pkg_y, input$pkg_color, (input$pkg_size*2/5),
                   input$background_color, input$border_color,
                   input$url, input$url_x, urly = input$url_y, input$url_color, (input$url_size*2/5), input$url_angle)
    output$img <- renderPlot(s, width = 259, height = 300)
    output$imgdn <- downloadHandler(
      filename = "my_polaroid_sticker.png",
      content = function(file = filename) {
        save_sticker(filename = file, s)
      }
    )
  })

}

shinyApp(ui, server)
