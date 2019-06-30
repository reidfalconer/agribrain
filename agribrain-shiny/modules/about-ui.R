aboutUI <- function(id, label = 'About') {
  ns <- NS(id)
  fluidRow(
    column(1,
           HTML("")),
    column(10,
           h4(paste("AgriBrain")),
           br(),
           p("AgriBrain is an agriculture and irrigation management system that integrates monitoring, analysis and automation into a single platform, enabling farmers to maximize productivity any time, from anywhere."),

           p("AgriBrain provides farmers with real-time recommendations based on data pertaining to plant, soil and weather conditions obtained from both sensors in the field and external sources. This data is analyzed in the cloud, using AgriBrains' proprietary crop modelling software."),

           p("Based entirely on IOT technology, AgriBrain was developed in collaboration with Accenture Advanced Intelligence. AgriBrain is the first platform of its kind to integrate monitoring, analysis and automation in one system, controlled by the farmer through a friendly and straightforward user interface, that provides optimization and smart recommendations throughout all stages of the crop lifecycle, saving water, fertilizer and other inputs and improving profitability."),

           p("AgriBrain is an innovative company that is continuously looking for creative technology solutions that help the world grow more food with fewer resources. Adoption of advanced agricultural technologies, including innovative digital solutions, is becoming increasingly necessary to address the growing need for greater food production while ensuring more efficient use of natural resources. From companies cultivating large areas of land to smallholder farmers in developing countries, AgriBrain gives every farmer a way to maximize results and enjoy an accessible, friendly and advanced interface."))
    ### the rest of your code
  )
}