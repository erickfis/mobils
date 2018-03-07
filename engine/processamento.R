library(knitr)
library(rmarkdown)
library(magrittr)
library(here)
library(lubridate)
library(readxl)
library(dplyr)
library(ggplot2)
library(RColorBrewer)
library(scales)
library(stringr)
library(grid)
library(gridExtra)
library(plotly)
library(DT)


# gatilho tem.novidade futuramente vai ser ativado a partir de comparação com o servidor
tem.novidade <- 0

# verifica se os arquivos disponíveis são os mesmos que já foram utilizados anteriormente. Se não, dispara um novo processamento

#arquivos.atual <- dir("../data/")
arquivos.atual <- dir(here::here("data"))
arquivos.atual <- arquivos.atual[grep("mobils", arquivos.atual)]

# if (file.exists("../data/lista.txt")) {
#         data.previous <- readLines("../data/lista.txt")
#                 if (identical(data.previous,arquivos.atual)) {
#                         tem.novidade <- 0
#                 } else {
#                         tem.novidade <- 1
#                         writeLines(arquivos.atual, "../data/lista.txt")
#                 }
#         
# } else {
#         tem.novidade <- 1
#         writeLines(arquivos.atual, "../data/lista.txt")
# }
# 



# procurando por db pronto, salvo em rds
tem.rda <- file.exists(here::here("data", "dados-ok.rda"))

# se tem novidade ou falta o rds, processar do começo:
if(tem.novidade==1|!tem.rda) {

        dados <- read_excel(
                paste0(here::here("data/"), arquivos.atual[1]),
                1, col_types = "text", range = cell_cols("B:F")
                )
                        
                        
        if (length(arquivos.atual) > 1) {

        for (i in 2:length(arquivos.atual)) {
                dados <- bind_rows(dados, read_excel(
                        paste0(here::here("data/"), arquivos.atual[i]),
                        1, col_types = "text", range = cell_cols("B:F")
                        )
                )

        }
        }        

        dados <- tbl_df(dados)
        
        
        names(dados) %<>% make.names(unique = TRUE, allow_ = TRUE) %>% 
                tolower() %>% {gsub(" ", ".", .)}
                
                
        
        # Além disso, transformar tudo para lowercase, converter formato de datas,
        # renomear variáveis, selecionar as que interessam, criar variável mês
        real <- dollar_format(prefix = "R$ ")
        
                
        
        dados$valor.raw <- dados$valor %>% {gsub(",00|\\.", "", .)} %>% 
                {gsub(",", ".", .)} %>% 
                {gsub("R\\$", "", .)} %>% as.numeric(.)
        
        #View(dados[,c("valor", "valorr")])
         
        #View(dados[dados$valorr>2000, ])       
        
        dadosT <- dados %>% 
                rename(tipo = categoria) %>%
                mutate(data = parse_date_time(data, "dmY"),
                       descrição = tolower(as.character(descrição)),
                       tipo = factor(tolower(as.character(tipo))),
                      
                       valor = real(valor.raw),
                       mes = factor(format(data, "%b"),
                                     levels = c("Jan", "Fev", "Mar",
                                                "Abr", "Mai","Jun",
                                                "Jul", "Ago", "Set",
                                                "Out", "Nov", "Dez"),
                                     ordered=TRUE),
                       ano = factor(format(data, "%Y")),
                       mes.ano = format(data, '%Y-%m')
                ) %>%
                select(data, ano, mes, mes.ano, tipo, descrição, 
                        valor.raw,valor)
        
} else {
        load(here::here("data", "dados-ok.rda"))
}


### filtros
if(!tem.rda) {

        # Filtros
        
        subs <- "defic.|reserva|complemento pet|previs."
        ## deficit
        indices <- grep(subs, dadosT$descrição)
        #View(dadosT[indices,])
        dadosT <- dadosT[-indices,]

        # uber é transporte
        indices <- grep("uber", dadosT$descrição)
        #View(dadosT[indices,])
        dadosT$tipo[indices] <- "transporte"
        
        # removendo bomba de combustível  
        indices <- which(dadosT$tipo == "investimento" & 
                                 grepl("^bomba", dadosT$descrição))
        #View(dadosT[indices,])
        dadosT <- dadosT[-indices,]  
        
        # revomendo dev. pet
        indices <- which(dadosT$descrição == "devolução pet")
        #View(dadosT[indices,])
        dadosT <- dadosT[-indices,] 
}


## analise rápida


# indices <- which(dadosT$tipo == "corolla" & 
#                          dadosT$data >= format(as.POSIXct("2015-11-01")))
# 
# indices <- which(dadosT$tipo == "corolla")
# View(dadosT[indices,])
# dadosT <- dadosT[-indices,] 
# 
# indices <- grep("ipva", dadosT$descrição)
# indices <- grep("licen", dadosT$descrição)
# View(dadosT[indices,])
# dadosT$tipo[indices] <- "transporte"



#dados$data > format(as.POSIXct("2016-01-01"))                


# Vamos agrupar os dados por tipo de gasto, ano e mes, e depois calcular 
# o total de gastos em cada categoria
dadosT %<>% group_by(tipo, ano, mes)

if(!tem.rda) {
        save(dadosT, file = here::here("data", "dados-ok.rda"))
        rm(dados)
}



real <- dollar_format(prefix = "R$ ")
totais <- summarise(dadosT, total.raw=sum(valor.raw)) %>%
        mutate(total = real(total.raw))

