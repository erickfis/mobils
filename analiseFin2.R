# # o próximo passo é estudar a variança, para ver quais categorias (tipos) 
# devem ser analisadas com mais detalhe
# por hora, vamos apenas olhar para as categorias mais promissoras, 
# alimentação, pagamentos e corolla

library(xlsx)
library(data.table)
library(dplyr)
library(lubridate)
library(ggplot2)
library(RColorBrewer)
library(gridExtra)

dt <- readRDS("dt.rds")






# alimentação

#devidos subsets

dt.alim <- dt[dt$tipo=="alimentação",]
dt.alim[, erro := desvio/sqrt(length(unique(total))), by = list(ano)]

plt.alim <- ggplot(dt.alim, aes(x=mes, y=total, group=ano, colour=ano))


(plt.alim +  geom_line() + 
                geom_point(size=0.5, alpha=0.5) +
                # facet_grid(ano ~., scale="free") +
                # geom_smooth(colour="black", linetype=3, alpha=0.2) +
                # geom_errorbar(aes(ymin=total-erro, ymax=total+erro), width=.1) +
                geom_hline(aes(yintercept = media, colour = ano), linetype=2) +
                labs(title="Gastos com alimentação", y="Total (R$)") + 
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
                # facet_grid(ano ~., scale="free") +
                # geom_smooth(colour="black", linetype=3, alpha=0.2) +
                # geom_errorbar(aes(ymin=total-erro, ymax=total+erro), width=.1) +
                # geom_hline(aes(yintercept = media, colour = ano), linetype=2) +
                labs(title="Gastos com pagamentos", y="Total (R$)") + 
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
                # facet_grid(ano ~., scale="free") +
                # geom_smooth(colour="black", linetype=3, alpha=0.2) +
                # geom_errorbar(aes(ymin=total-erro, ymax=total+erro), width=.1) +
                geom_hline(aes(yintercept = media, colour = ano), linetype=2) +
                labs(title="Gastos com carro", y="Total (R$)") + 
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




