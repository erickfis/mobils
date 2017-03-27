library(xlsx)
library(data.table)
library(dplyr)
library(lubridate)
library(ggplot2)
library(RColorBrewer)
library(gridExtra)




#versão excel
arquivo <- "data/start-2017-03-25.xls"
dados <- read.xlsx(arquivo, sheetName = "Despesa", startRow = 2)

# tratando o banco de dados

##removendo NA, que neste caso só corresponde às linhas que não possuem data, são 
## formatação do excel

dadosT <- dados[complete.cases(dados),]



str(dadosT) #dar uma olhada
dadosT <- tbl_df(dadosT) #para usar dplyr

names(dadosT) <- tolower(names(dadosT)) # para facilitar o uso das vars

## acertando formatos de data e descrição
## também adiciona as cols mes e ano, para facilitar o plot por painéis

dadosM <- dadosT %>%    rename(tipo = tipo.de.despesa) %>%
        mutate(data = parse_date_time(data, "dmY"), 
               descrição = tolower(as.character(descrição)),
               tipo = factor(tolower(as.character(tipo))),
               mes = month(data, label=TRUE),
               ano = factor(year(data))
        ) %>%
        
        # filtrando as informações que interessam, ou seja, somente da conta itau
        # e datas acima de 01-01-15, vamos considerar que eu não usava bem o app antes disso
        # e abaixo de 25-03-2017, quando o arquivo foi gerado (pq o db tem dados de 
        # "previsão de gastos" até o fim do ano
        
        filter(conta=="itau" &  data >= as.Date("2015-01-01") &
                       data <= as.Date("2017-03-25")) %>%
        ## remove as colunas indesejadas
        select(data, ano, mes, tipo, descrição, valor)


########fim da preparação do df, vamos começar #######


dadosM <- tbl_df(dadosM)

dadosM <- group_by(dadosM, tipo, ano, mes)

write.csv(dadosM, "dadosM.csv")


totais <- summarise(dadosM, total=sum(valor))

# o gráfico

# as cores:
# Neste caso, temos 20 cat, mas somente 9 cores na paleta brewer padrao

colourCount = length(unique(totais$tipo))
getPalette = colorRampPalette(brewer.pal(9, "Set1"))


plt <- ggplot(totais, aes(x=mes, y=total, group=tipo, colour=tipo))

(plt +  geom_line() + geom_point() +
                scale_colour_manual(values = getPalette(colourCount))+
                facet_grid(ano ~.) + 
                labs(title="Gastos por categoria", y="Total (R$)") + 
                theme(plot.title = element_text(hjust = 0.5)) 
        # guides(fill=FALSE)
)


dev.copy(png, file="plot1.png")
dev.off()

# olhando para o gráfico, vemos problemas em mar-2015, pagamentos
# e em jan/mar-2017 - alimentação, 
#vamos ver do q se trata, para talvez remover do gráfico

sub1 <- with(dadosM, ano==2017 & tipo=="alimentação" & mes %in% c("Jan", "Mar"))
sub2 <- with(dadosM, ano==2015 & mes=="Mar" & tipo=="pagamentos")

arrange(dadosM[which(sub1),], desc(valor))
# isso mostra que os valores de previsão não foram retirados após o final do mês,
# podemos tirar do gráfico
# vou filtrar os dados novamente para retirar todas as lihas onde 
# descrição contenha "previsão"


dadosM[which(sub2),]
# consta um lançamento referente a pagamento de cc, mas não é assim que eu uso o programa
# podemos tirar do gráfico limitando
# vou filtrar os dados novamente para retirar todas as lihas onde 
# descrição contenha "visa"


dadosFil <- dadosM


##teste do grep
fonte <- c("previsao de gastos", "visa", "gastos", "gastos com visa")
filtro <- which(!(grepl("[Pp]revisão", fonte) | grepl("[Vv]isa", fonte)))
fonte[filtro] # grep ok

fonte <- dadosFil$descrição
filtro <- which(!(grepl("[Pp]revisão", fonte) | grepl("[Vv]isa", fonte)))

#aplicando o filtro
dadosFil <- dadosFil[filtro,]

#agora podemos repetir o processo que vai gerar o plot

dadosFil <- group_by(dadosFil, tipo, ano, mes)

totais <- summarise(dadosFil, total=sum(valor))





###novo gráfico
# as cores:
# Neste caso, temos 20 cat, mas somente 9 cores na paleta brewer padrao

colourCount = length(unique(totais$tipo))
getPalette = colorRampPalette(brewer.pal(9, "Set1"))


plt <- ggplot(totais, aes(x=mes, y=total, group=tipo, colour=tipo))

(plt +  geom_line() + geom_point() +
                scale_colour_manual(values = getPalette(colourCount))+
                facet_grid(ano ~.) + 
                labs(title="Gastos por categoria", y="Total (R$)") + 
                theme(plot.title = element_text(hjust = 0.5)) 
        # guides(fill=FALSE)
)


dev.copy(png, file="plot2.png")
dev.off()

# analisando o 2nd gráfico, vemos que ainda há problemas com os lançamentos de 2017
# vou ter que verificar os dados no servidor, para exportar novamente e recomeçar.
# por hora, vamos apenas remover 2017

totais <- totais[which(totais$ano %in% c(2015,2016)),]
dadosFil <- dadosFil[which(dadosFil$ano %in% c(2015,2016)),]


####caminho diferente para os sumarios:

dt <- data.table(dadosFil)
dt[, total := sum(valor), by = list(tipo,ano,mes)]
dt[, media := mean(total), by = list(tipo,ano)]
dt[, desvio := sd(total), by = list(tipo,ano)]


###novo gráfico

plt <- ggplot(totais, aes(x=mes, y=total, group=tipo, colour=tipo))


(plt +  geom_line() + geom_point() +
                scale_colour_manual(values = getPalette(colourCount))+
                facet_grid(ano ~.) + 
                labs(title="Gastos por categoria", y="Total (R$)") + 
                theme(plot.title = element_text(hjust = 0.5)) 
)


dev.copy(png, file="plot3.png")
dev.off()
#  tudo ok, vamos salvar os dados

write.csv(dadosFil, "dados-filtrados.csv")

write.csv(totais, "totais.csv")


# # o próximo passo é estudar a variança, para ver quais categorias (tipos) 
# devem ser analisadas com mais detalhe
# por hora, vamos apenas olhar para as categorias mais promissoras, 
# alimentação, pagamentos e corolla




# alimentação

#devidos subsets

dt.alim <- dt[dt$tipo=="alimentação",]
dt.alim[, erro := desvio/sqrt(length(unique(total))), by = list(ano)]

plt.alim <- ggplot(dt.alim, aes(x=mes, y=total, group=ano, colour=ano))


(plt.alim +  geom_line() + 
                geom_point(size=0.5, alpha=0.5) +
                facet_grid(ano ~.) +
                geom_smooth(colour="black", linetype=3, alpha=0.2) +
                geom_errorbar(aes(ymin=total-erro, ymax=total+erro), width=.1) +
                geom_hline(aes(yintercept = media, colour = ano), linetype=2) +
                labs(title="Gastos por categoria", y="Total (R$)") + 
                theme(plot.title = element_text(hjust = 0.5)) 
)


dev.copy(png, file="plot-alim.png")
dev.off()



#analisar maio e julho

dados.alim <- dadosFil %>% filter(mes %in% c("May","Jul") & tipo=="alimentação") %>%
        arrange(ano, mes, desc(valor))

View(dados.alim)


#pagamentos

dt.pag <- dt[dt$tipo=="pagamentos",]
dt.pag[, erro := desvio/sqrt(length(unique(total))), by = list(ano)]

plt.pag <- ggplot(dt.pag, aes(x=mes, y=total, group=ano, colour=ano))


(plt.pag +  geom_line() + 
                geom_point(size=0.5, alpha=0.5) +
                facet_grid(ano ~.) +
                geom_smooth(colour="black", linetype=3, alpha=0.2) +
                geom_errorbar(aes(ymin=total-erro, ymax=total+erro), width=.1) +
                geom_hline(aes(yintercept = media, colour = ano), linetype=2) +
                labs(title="Gastos por categoria", y="Total (R$)") + 
                theme(plot.title = element_text(hjust = 0.5)) 
)

dev.copy(png, file="plot-pag.png")
dev.off()


#analisar 2015 - pagamentos

dados.pag <- dadosFil %>% filter(ano %in% c(2015) & tipo=="pagamentos") %>%
        arrange(ano, mes, desc(valor))

View(dados.pag)

#corolla

dt.cor <- dt[dt$tipo=="corolla",]
dt.cor[, erro := desvio/sqrt(length(unique(total))), by = list(ano)]

plt.cor <- ggplot(dt.cor, aes(x=mes, y=total, group=ano, colour=ano))


(plt.cor +  geom_line() + 
                geom_point(size=0.5, alpha=0.5) +
                facet_grid(ano ~.) +
                geom_smooth(colour="black", linetype=3, alpha=0.2) +
                geom_errorbar(aes(ymin=total-erro, ymax=total+erro), width=.1) +
                geom_hline(aes(yintercept = media, colour = ano), linetype=2) +
                labs(title="Gastos por categoria", y="Total (R$)") + 
                theme(plot.title = element_text(hjust = 0.5)) 
)

dev.copy(png, file="plot-cor.png")
dev.off()


#analisar 2015

dados.cor <- dadosFil %>% filter(ano %in% c(2015) & tipo=="corolla") %>%
        arrange(ano, mes, desc(valor))

View(dados.cor)





##############
# o plot abaixo arrancaria os pontos fora na unha:
# 
# plt <- ggplot(totais, aes(x=mes, y=total, group=tipo, colour=tipo))
# 
# (plt +  geom_line() + geom_point() + ylim(0,1750) +
#                 scale_colour_manual(values = getPalette(colourCount))+
#                 facet_grid(ano ~.) + 
#                 labs(title="Gastos por categoria", y="Total (R$)") + 
#                 theme(plot.title = element_text(hjust = 0.5)) 
#         # guides(fill=FALSE)
# )




