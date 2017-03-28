Objetivo
========

Analisar uma planilha de gastos domésticos registrados ao longo dos anos
e verificar a existência de tendências relacionadas à estações do ano,
datas comemorativas ou datas-chave.

Os dados foram gerados pela plataforma mobils, um app android que
registra despesas realizadas, armazena os dados na núvem e permite a
posterior exportação destes dados.

<https://web.mobills.com.br>

Análise dos dados
=================

Tratamento inicial dos dados
----------------------------

Antes de procurar estabelecer qualquer correlação, vamos primeiramente
analizar os dados exportados pela plataforma, procurando avaliar sua
qualidade e quais são as transformações necessárias para o seu uso.

### Gráfico 1

![](analise_files/figure-markdown_strict/unnamed-chunk-43-1.png)

    ## png 
    ##   3

    ## png 
    ##   2

Analisando o primeiro gráfico, vemos que há problemas em março de 2015,
tipo pagamentos.

Vamos olhar este ponto fora do gráfico mais de perto:

<table>
<thead>
<tr class="header">
<th align="left">data</th>
<th align="left">ano</th>
<th align="left">mes</th>
<th align="left">tipo</th>
<th align="left">descrição</th>
<th align="right">valor</th>
<th align="left">cartao</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">2015-03-25</td>
<td align="left">2015</td>
<td align="left">Mar</td>
<td align="left">pagamentos</td>
<td align="left">pagamento parcial-visa</td>
<td align="right">4077</td>
<td align="left"></td>
</tr>
<tr class="even">
<td align="left">2015-03-10</td>
<td align="left">2015</td>
<td align="left">Mar</td>
<td align="left">pagamentos</td>
<td align="left">banco</td>
<td align="right">41</td>
<td align="left"></td>
</tr>
<tr class="odd">
<td align="left">2015-03-10</td>
<td align="left">2015</td>
<td align="left">Mar</td>
<td align="left">pagamentos</td>
<td align="left">saque</td>
<td align="right">90</td>
<td align="left"></td>
</tr>
<tr class="even">
<td align="left">2015-03-07</td>
<td align="left">2015</td>
<td align="left">Mar</td>
<td align="left">pagamentos</td>
<td align="left">saque</td>
<td align="right">230</td>
<td align="left"></td>
</tr>
</tbody>
</table>

Da tabela acima, podemos observar que consta um lançamento referente a
pagamento de cartão de crédito, mas não é assim que o restante dos
lançamentos foram feitos: não foram registrados totais. Este, portanto,
foi um erro de uso da plataforma. Vamos retirar este ponto da análise e
passar para a próxima etapa.

### Gráfico 2

![](analise_files/figure-markdown_strict/unnamed-chunk-46-1.png)

    ## png 
    ##   3

    ## png 
    ##   2

Como podemos ver no gráfico 2, não há mais pontos obviamente fora do
gráfico, todos os erros de coleta dados foram filtrados.

O próximo passo é estudar os tipos de despesas que mais se destacam:
alimentação, pagamentos e corolla.

Análise por tipo de despesa: Alimentação
----------------------------------------

    ##             tipo  ano mes   total     media
    ##   1: alimentação 2015 Jan 1318.00 1028.8282
    ##   2: alimentação 2015 Feb  834.00 1028.8282
    ##   3: alimentação 2015 Apr  785.00 1028.8282
    ##   4: alimentação 2015 May 1332.00 1028.8282
    ##   5: alimentação 2015 Jun  726.00 1028.8282
    ##  ---                                       
    ## 380:  transporte 2016 Aug  552.64  618.3325
    ## 381:  transporte 2016 Sep  598.25  618.3325
    ## 382:  transporte 2016 Oct  555.98  618.3325
    ## 383:  transporte 2016 Nov  643.91  618.3325
    ## 384:  transporte 2016 Dec  492.34  618.3325

![](analise_files/figure-markdown_strict/unnamed-chunk-47-1.png)

    ## png 
    ##   3

    ## png 
    ##   2

<!-- dados.alim <- dadosFil %>% filter(mes %in% c("May","Jul") & tipo=="alimentação") %>% -->
<!--         arrange(ano, mes, desc(valor)) -->
<!-- View(dados.alim) -->
<!-- #pagamentos -->
<!-- dt.pag <- dt[dt$tipo=="pagamentos",] -->
<!-- dt.pag[, erro := desvio/sqrt(length(unique(total))), by = list(ano)] -->
<!-- plt.pag <- ggplot(dt.pag, aes(x=mes, y=total, group=ano, colour=ano)) -->
<!-- (plt.pag +  geom_line() +  -->
<!--                 geom_point(size=0.5, alpha=0.5) + -->
<!--                 # facet_grid(ano ~., scale="free") + -->
<!--                 # geom_smooth(colour="black", linetype=3, alpha=0.2) + -->
<!--                 # geom_errorbar(aes(ymin=total-erro, ymax=total+erro), width=.1) + -->
<!--                 geom_hline(aes(yintercept = media, colour = ano), linetype=2) + -->
<!--                 labs(title="Gastos com pagamentos", y="Total (R$)") +  -->
<!--                 theme(plot.title = element_text(hjust = 0.5))  -->
<!-- ) -->
<!-- dev.copy(png, file="plot-pag2.png") -->
<!-- dev.off() -->
<!-- #analisar 2015 - pagamentos -->
<!-- dados.pag <- dadosFil %>% filter(ano %in% c(2015) & tipo=="pagamentos") %>% -->
<!--         arrange(ano, mes, desc(valor)) -->
<!-- View(dados.pag) -->
<!-- #corolla -->
<!-- dt.cor <- dt[dt$tipo=="corolla",] -->
<!-- dt.cor[, erro := desvio/sqrt(length(unique(total))), by = list(ano)] -->
<!-- plt.cor <- ggplot(dt.cor, aes(x=mes, y=total, group=ano, colour=ano)) -->
<!-- (plt.cor +  geom_line() +  -->
<!--                 geom_point(size=0.5, alpha=0.5) + -->
<!--                 # facet_grid(ano ~., scale="free") + -->
<!--                 # geom_smooth(colour="black", linetype=3, alpha=0.2) + -->
<!--                 # geom_errorbar(aes(ymin=total-erro, ymax=total+erro), width=.1) + -->
<!--                 geom_hline(aes(yintercept = media, colour = ano), linetype=2) + -->
<!--                 labs(title="Gastos com carro", y="Total (R$)") +  -->
<!--                 theme(plot.title = element_text(hjust = 0.5))  -->
<!-- ) -->
<!-- dev.copy(png, file="plot-cor.png") -->
<!-- dev.off() -->
<!-- #analisar 2015 -->
<!-- dados.cor <- dadosFil %>% filter(ano %in% c(2015) & tipo=="corolla") %>% -->
<!--         arrange(ano, mes, desc(valor)) -->
<!-- View(dados.cor) -->
<!-- ############## -->
<!-- # o plot abaixo arrancaria os pontos fora na unha: -->
<!-- #  -->
<!-- # plt <- ggplot(totais, aes(x=mes, y=total, group=tipo, colour=tipo)) -->
<!-- #  -->
<!-- # (plt +  geom_line() + geom_point() + ylim(0,1750) + -->
<!-- #                 scale_colour_manual(values = getPalette(colourCount))+ -->
<!-- #                 facet_grid(ano ~.) +  -->
<!-- #                 labs(title="Gastos por categoria", y="Total (R$)") +  -->
<!-- #                 theme(plot.title = element_text(hjust = 0.5))  -->
<!-- #         # guides(fill=FALSE) -->
<!-- # ) -->
render("analise.Rmd", output\_format = "md\_document")
======================================================
