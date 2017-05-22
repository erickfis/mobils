# Plataforma Mobills - Análise de Despesas Pessoais - WIP

*erickfis@gmail.com - 2017 maio, 22*



Análise de uma planilha de gastos domésticos registrados ao longo dos
meses e verificar a existência de tendências relacionadas à estações do
ano, datas comemorativas ou datas-chave.

Os dados foram gerados pela plataforma mobils, um app android que
registra despesas realizadas, armazena os dados na nuvem e permite a
posterior exportação destes dados.


<https://web.mobills.com.br>

<!-- # A plataforma Mobills -->


-   [Em progresso](#em-progresso)
-   [Objetivo](#objetivo)
-   [Processamento dos dados](#processamento-dos-dados)
    -   [Tratamento inicial dos dados](#tratamento-inicial-dos-dados)
    -   [Análise da qualidade dos
        dados](#analise-da-qualidade-dos-dados)
-   [Maiores Despesas por categoria](#maiores-despesas-por-categoria)
-   [Principais tipos de despesas](#principais-tipos-de-despesas)
    -   [Análise por tipo de despesa:
        Alimentação](#analise-por-tipo-de-despesa-alimentacao)
    -   [Análise por tipo de despesa:
        Pagamentos](#analise-por-tipo-de-despesa-pagamentos)
    -   [Análise por tipo de despesa:
        Corolla](#analise-por-tipo-de-despesa-corolla)
-   [Conclusão](#conclusao)
    -   [Plataforma Mobills:](#plataforma-mobills)
    -   [Gastos pessoais](#gastos-pessoais)

Em progresso
============

-   acessar API da plataforma - ainda não disponível



Processamento dos dados
=======================

O banco de dados é carregado e preparado para que possamos responder às
questões levantadas.

Tratamento inicial dos dados
----------------------------

Antes de fazer qualquer inferência, vamos primeiramente analisar os
dados exportados pela plataforma, procurando avaliar sua qualidade e
quais são as transformações necessárias para o seu uso.

<!-- tratar inicial.csv com sed+grep para filtrar 2015 e 2016 -->
<!-- Pega a 1a linha (1 a 5), para cabeçalho -->
<!-- $ sed -n "1,5p" inicial.csv > newData.csv -->
<!-- filtra 2015 e 2016 -->
<!-- $ grep -E "^(,2015|,2016)" inicial.csv >> newData.csv -->
Transformações necessárias:

-   as datas estão em formato char, então são convertidas através do
    lubridate
-   criadas as variáveis mês e ano, para agrupar os dados
-   valores estão em formato char, com $ e vírgula
-   calculadas as somas por categoria para cada mês e ano

Análise da qualidade dos dados
------------------------------

Analisando o primeiro gráfico, vemos que há problemas em março de 2015,
tipo pagamentos.

Vamos olhar este ponto fora do gráfico mais de perto:

<table>
<caption>categoria pagamentos, em março de 2015</caption>
<thead>
<tr class="header">
<th align="left">data</th>
<th align="left">ano</th>
<th align="left">mes</th>
<th align="left">tipo</th>
<th align="left">descrição</th>
<th align="right">valor</th>
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
</tr>
<tr class="even">
<td align="left">2015-03-10</td>
<td align="left">2015</td>
<td align="left">Mar</td>
<td align="left">pagamentos</td>
<td align="left">banco</td>
<td align="right">41</td>
</tr>
<tr class="odd">
<td align="left">2015-03-10</td>
<td align="left">2015</td>
<td align="left">Mar</td>
<td align="left">pagamentos</td>
<td align="left">saque</td>
<td align="right">90</td>
</tr>
<tr class="even">
<td align="left">2015-03-07</td>
<td align="left">2015</td>
<td align="left">Mar</td>
<td align="left">pagamentos</td>
<td align="left">saque</td>
<td align="right">230</td>
</tr>
</tbody>
</table>

Da tabela acima, podemos observar que consta um lançamento referente a
pagamento de cartão de crédito, mas não é assim que o restante dos
lançamentos foram feitos: não foram registrados totais. Este, portanto,
foi um erro de uso da plataforma. Vamos, portanto, retirar este ponto da
análise.

<table>
<caption>compras no crédito, registradas no dia 25</caption>
<thead>
<tr class="header">
<th align="left">data</th>
<th align="left">ano</th>
<th align="left">mes</th>
<th align="left">tipo</th>
<th align="left">descrição</th>
<th align="right">valor</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">2016-07-25</td>
<td align="left">2016</td>
<td align="left">Jul</td>
<td align="left">corolla</td>
<td align="left">webmotors (1/3)</td>
<td align="right">49.97</td>
</tr>
<tr class="even">
<td align="left">2016-07-25</td>
<td align="left">2016</td>
<td align="left">Jul</td>
<td align="left">saúde</td>
<td align="left">coop capuava (2/3)</td>
<td align="right">53.76</td>
</tr>
<tr class="odd">
<td align="left">2016-07-25</td>
<td align="left">2016</td>
<td align="left">Jul</td>
<td align="left">transporte</td>
<td align="left">auto posto miro</td>
<td align="right">30.00</td>
</tr>
<tr class="even">
<td align="left">2016-07-25</td>
<td align="left">2016</td>
<td align="left">Jul</td>
<td align="left">corolla</td>
<td align="left">mercadopago (1/3)</td>
<td align="right">52.04</td>
</tr>
<tr class="odd">
<td align="left">2016-07-25</td>
<td align="left">2016</td>
<td align="left">Jul</td>
<td align="left">alimentação</td>
<td align="left">coop capuava</td>
<td align="right">15.25</td>
</tr>
<tr class="even">
<td align="left">2016-07-25</td>
<td align="left">2016</td>
<td align="left">Jul</td>
<td align="left">alimentação</td>
<td align="left">compras pão de açúcar</td>
<td align="right">475.00</td>
</tr>
</tbody>
</table>

<table>
<caption>compras no crédito, registradas no dia 25</caption>
<thead>
<tr class="header">
<th align="left">data</th>
<th align="left">ano</th>
<th align="left">mes</th>
<th align="left">tipo</th>
<th align="left">descrição</th>
<th align="right">valor</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">2016-07-25</td>
<td align="left">2016</td>
<td align="left">Jul</td>
<td align="left">alimentação</td>
<td align="left">pao do marques</td>
<td align="right">10.34</td>
</tr>
<tr class="even">
<td align="left">2016-07-25</td>
<td align="left">2016</td>
<td align="left">Jul</td>
<td align="left">investimento</td>
<td align="left">uber*uber</td>
<td align="right">7.39</td>
</tr>
<tr class="odd">
<td align="left">2016-07-25</td>
<td align="left">2016</td>
<td align="left">Jul</td>
<td align="left">alimentação</td>
<td align="left">sacolao saude st</td>
<td align="right">88.82</td>
</tr>
<tr class="even">
<td align="left">2016-07-25</td>
<td align="left">2016</td>
<td align="left">Jul</td>
<td align="left">lazer</td>
<td align="left">bruti s cafe e lanches</td>
<td align="right">12.50</td>
</tr>
<tr class="odd">
<td align="left">2016-07-25</td>
<td align="left">2016</td>
<td align="left">Jul</td>
<td align="left">alimentação</td>
<td align="left">assai atacadista</td>
<td align="right">482.89</td>
</tr>
<tr class="even">
<td align="left">2016-07-25</td>
<td align="left">2016</td>
<td align="left">Jul</td>
<td align="left">fast food</td>
<td align="left">divino fogao c t da fa</td>
<td align="right">19.83</td>
</tr>
</tbody>
</table>

Além disso, verifica-se que todas as despesas pagas no cartão de crédito
ficaram registradas na data de vencimento do cartão, dia 25. Este é um
defeito da plataforma.

Desta forma, não é possível dizer se a despesa foi feita no mês anterior
ou no próprio mês. Ela apenas foi paga no mês onde é lançada.

Uma vez que a fatura deste cartão é fechada no dia 15, todas as compras
realizadas a partir do dia 16 são cobradas apenas na próxima fatura.

No entanto, como isso ocorre para todos os dados da mesma forma, não há
impacto impeditivo na análise.

Como podemos ver no gráfico 2, não há mais pontos obviamente fora do
gráfico, todos os erros de coleta dados foram filtrados.

O próximo passo é estudar os tipos de despesas que mais se destacam.

![Tratamento dos dados](readme_files/figure-markdown_strict/grid-1.png)

Maiores Despesas por categoria
==============================

Na tabela abaixo temos um ranking dos maiores tipos de despesa por ano:

<table>
<thead>
<tr class="header">
<th align="left">tipo</th>
<th align="right">media.total</th>
<th align="left">ano</th>
<th align="right">total.anual</th>
<th align="right">media.anual</th>
<th align="right">sd.anual</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">alimentação</td>
<td align="right">10413.72</td>
<td align="left">2015</td>
<td align="right">11317.11</td>
<td align="right">1028.83</td>
<td align="right">218.451669</td>
</tr>
<tr class="even">
<td align="left">alimentação</td>
<td align="right">10413.72</td>
<td align="left">2016</td>
<td align="right">13809.51</td>
<td align="right">1150.79</td>
<td align="right">264.265256</td>
</tr>
<tr class="odd">
<td align="left">alimentação</td>
<td align="right">10413.72</td>
<td align="left">2017</td>
<td align="right">6114.55</td>
<td align="right">1528.64</td>
<td align="right">409.415748</td>
</tr>
<tr class="even">
<td align="left">transporte</td>
<td align="right">5091.76</td>
<td align="left">2015</td>
<td align="right">5861.51</td>
<td align="right">532.86</td>
<td align="right">126.071060</td>
</tr>
<tr class="odd">
<td align="left">transporte</td>
<td align="right">5091.76</td>
<td align="left">2016</td>
<td align="right">7419.99</td>
<td align="right">618.33</td>
<td align="right">109.892028</td>
</tr>
<tr class="even">
<td align="left">transporte</td>
<td align="right">5091.76</td>
<td align="left">2017</td>
<td align="right">1993.77</td>
<td align="right">498.44</td>
<td align="right">85.329031</td>
</tr>
<tr class="odd">
<td align="left">saúde</td>
<td align="right">3537.84</td>
<td align="left">2015</td>
<td align="right">4170.79</td>
<td align="right">347.57</td>
<td align="right">73.603969</td>
</tr>
<tr class="even">
<td align="left">saúde</td>
<td align="right">3537.84</td>
<td align="left">2016</td>
<td align="right">4950.81</td>
<td align="right">412.57</td>
<td align="right">98.528588</td>
</tr>
<tr class="odd">
<td align="left">saúde</td>
<td align="right">3537.84</td>
<td align="left">2017</td>
<td align="right">1491.92</td>
<td align="right">372.98</td>
<td align="right">208.047493</td>
</tr>
<tr class="even">
<td align="left">pagamentos</td>
<td align="right">3172.63</td>
<td align="left">2015</td>
<td align="right">6266.99</td>
<td align="right">522.25</td>
<td align="right">333.768537</td>
</tr>
<tr class="odd">
<td align="left">pagamentos</td>
<td align="right">3172.63</td>
<td align="left">2016</td>
<td align="right">2501.00</td>
<td align="right">208.42</td>
<td align="right">87.059497</td>
</tr>
<tr class="even">
<td align="left">pagamentos</td>
<td align="right">3172.63</td>
<td align="left">2017</td>
<td align="right">749.90</td>
<td align="right">187.47</td>
<td align="right">94.964041</td>
</tr>
<tr class="odd">
<td align="left">corolla</td>
<td align="right">3137.90</td>
<td align="left">2015</td>
<td align="right">5313.14</td>
<td align="right">442.76</td>
<td align="right">310.598222</td>
</tr>
<tr class="even">
<td align="left">corolla</td>
<td align="right">3137.90</td>
<td align="left">2016</td>
<td align="right">2599.03</td>
<td align="right">288.78</td>
<td align="right">223.242858</td>
</tr>
<tr class="odd">
<td align="left">corolla</td>
<td align="right">3137.90</td>
<td align="left">2017</td>
<td align="right">1501.54</td>
<td align="right">375.38</td>
<td align="right">264.099645</td>
</tr>
<tr class="even">
<td align="left">moradia</td>
<td align="right">2637.11</td>
<td align="left">2015</td>
<td align="right">2749.32</td>
<td align="right">229.11</td>
<td align="right">62.570169</td>
</tr>
<tr class="odd">
<td align="left">moradia</td>
<td align="right">2637.11</td>
<td align="left">2016</td>
<td align="right">2934.00</td>
<td align="right">244.50</td>
<td align="right">54.251100</td>
</tr>
<tr class="even">
<td align="left">moradia</td>
<td align="right">2637.11</td>
<td align="left">2017</td>
<td align="right">2228.00</td>
<td align="right">557.00</td>
<td align="right">105.915060</td>
</tr>
<tr class="odd">
<td align="left">seguros</td>
<td align="right">2386.57</td>
<td align="left">2015</td>
<td align="right">2940.00</td>
<td align="right">294.00</td>
<td align="right">107.206965</td>
</tr>
<tr class="even">
<td align="left">seguros</td>
<td align="right">2386.57</td>
<td align="left">2016</td>
<td align="right">3139.90</td>
<td align="right">261.66</td>
<td align="right">5.744635</td>
</tr>
</tbody>
</table>

![](readme_files/figure-markdown_strict/unnamed-chunk-9-1.png)

Principais tipos de despesas
============================

Análise por tipo de despesa: Alimentação
----------------------------------------

![](readme_files/figure-markdown_strict/alimentacao-1.png)

Observa-se:

-   tendência a aumento de gastos em maio
-   tendência a aumento de gastos em julho
-   aumento da média em 2016
-   sobe e desce: as compras maiores não são feitas todo mês

Vamos analisar a tabela de dados:

<table>
<thead>
<tr class="header">
<th align="left">data</th>
<th align="left">ano</th>
<th align="left">mes</th>
<th align="left">tipo</th>
<th align="left">descrição</th>
<th align="right">valor</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">2015-05-25</td>
<td align="left">2015</td>
<td align="left">Mai</td>
<td align="left">alimentação</td>
<td align="left">18-04 mercado</td>
<td align="right">405.00</td>
</tr>
<tr class="even">
<td align="left">2015-05-25</td>
<td align="left">2015</td>
<td align="left">Mai</td>
<td align="left">alimentação</td>
<td align="left">12-04 feira</td>
<td align="right">130.00</td>
</tr>
<tr class="odd">
<td align="left">2015-05-25</td>
<td align="left">2015</td>
<td align="left">Mai</td>
<td align="left">alimentação</td>
<td align="left">25-04 feira</td>
<td align="right">103.00</td>
</tr>
<tr class="even">
<td align="left">2015-05-25</td>
<td align="left">2015</td>
<td align="left">Mai</td>
<td align="left">alimentação</td>
<td align="left">19-04 feira</td>
<td align="right">90.00</td>
</tr>
<tr class="odd">
<td align="left">2015-05-25</td>
<td align="left">2015</td>
<td align="left">Mai</td>
<td align="left">alimentação</td>
<td align="left">19-04 feira</td>
<td align="right">90.00</td>
</tr>
<tr class="even">
<td align="left">2015-05-25</td>
<td align="left">2015</td>
<td align="left">Mai</td>
<td align="left">alimentação</td>
<td align="left">09-05 feira</td>
<td align="right">89.00</td>
</tr>
<tr class="odd">
<td align="left">2015-05-25</td>
<td align="left">2015</td>
<td align="left">Mai</td>
<td align="left">alimentação</td>
<td align="left">25-04 camarao</td>
<td align="right">88.00</td>
</tr>
<tr class="even">
<td align="left">2015-05-25</td>
<td align="left">2015</td>
<td align="left">Mai</td>
<td align="left">alimentação</td>
<td align="left">02-05 feira</td>
<td align="right">86.00</td>
</tr>
<tr class="odd">
<td align="left">2015-05-25</td>
<td align="left">2015</td>
<td align="left">Mai</td>
<td align="left">alimentação</td>
<td align="left">09-05 mercado</td>
<td align="right">59.00</td>
</tr>
<tr class="even">
<td align="left">2015-07-27</td>
<td align="left">2015</td>
<td align="left">Jul</td>
<td align="left">alimentação</td>
<td align="left">16-06 compras</td>
<td align="right">566.00</td>
</tr>
<tr class="odd">
<td align="left">2015-07-27</td>
<td align="left">2015</td>
<td align="left">Jul</td>
<td align="left">alimentação</td>
<td align="left">04-07 feira</td>
<td align="right">138.00</td>
</tr>
<tr class="even">
<td align="left">2015-07-27</td>
<td align="left">2015</td>
<td align="left">Jul</td>
<td align="left">alimentação</td>
<td align="left">27-06 feira</td>
<td align="right">103.00</td>
</tr>
<tr class="odd">
<td align="left">2015-07-27</td>
<td align="left">2015</td>
<td align="left">Jul</td>
<td align="left">alimentação</td>
<td align="left">29-06 walmart</td>
<td align="right">85.00</td>
</tr>
<tr class="even">
<td align="left">2015-07-27</td>
<td align="left">2015</td>
<td align="left">Jul</td>
<td align="left">alimentação</td>
<td align="left">11-09 feira</td>
<td align="right">76.00</td>
</tr>
<tr class="odd">
<td align="left">2015-07-27</td>
<td align="left">2015</td>
<td align="left">Jul</td>
<td align="left">alimentação</td>
<td align="left">20-06 feira</td>
<td align="right">72.00</td>
</tr>
<tr class="even">
<td align="left">2016-05-25</td>
<td align="left">2016</td>
<td align="left">Mai</td>
<td align="left">alimentação</td>
<td align="left">assai atacadista</td>
<td align="right">430.14</td>
</tr>
<tr class="odd">
<td align="left">2016-05-25</td>
<td align="left">2016</td>
<td align="left">Mai</td>
<td align="left">alimentação</td>
<td align="left">sacolao saude st</td>
<td align="right">108.76</td>
</tr>
<tr class="even">
<td align="left">2016-05-25</td>
<td align="left">2016</td>
<td align="left">Mai</td>
<td align="left">alimentação</td>
<td align="left">sacolao saude st</td>
<td align="right">86.93</td>
</tr>
<tr class="odd">
<td align="left">2016-05-25</td>
<td align="left">2016</td>
<td align="left">Mai</td>
<td align="left">alimentação</td>
<td align="left">sacolao saude st</td>
<td align="right">85.80</td>
</tr>
<tr class="even">
<td align="left">2016-05-25</td>
<td align="left">2016</td>
<td align="left">Mai</td>
<td align="left">alimentação</td>
<td align="left">sacolao saude st</td>
<td align="right">83.42</td>
</tr>
<tr class="odd">
<td align="left">2016-05-25</td>
<td align="left">2016</td>
<td align="left">Mai</td>
<td align="left">alimentação</td>
<td align="left">coop capuava</td>
<td align="right">67.72</td>
</tr>
<tr class="even">
<td align="left">2016-05-25</td>
<td align="left">2016</td>
<td align="left">Mai</td>
<td align="left">alimentação</td>
<td align="left">coop capuava</td>
<td align="right">64.20</td>
</tr>
<tr class="odd">
<td align="left">2016-05-25</td>
<td align="left">2016</td>
<td align="left">Mai</td>
<td align="left">alimentação</td>
<td align="left">coop capuava</td>
<td align="right">60.53</td>
</tr>
<tr class="even">
<td align="left">2016-05-25</td>
<td align="left">2016</td>
<td align="left">Mai</td>
<td align="left">alimentação</td>
<td align="left">carrefour sto 248</td>
<td align="right">50.25</td>
</tr>
<tr class="odd">
<td align="left">2016-07-25</td>
<td align="left">2016</td>
<td align="left">Jul</td>
<td align="left">alimentação</td>
<td align="left">assai atacadista</td>
<td align="right">482.89</td>
</tr>
<tr class="even">
<td align="left">2016-07-25</td>
<td align="left">2016</td>
<td align="left">Jul</td>
<td align="left">alimentação</td>
<td align="left">compras pão de açúcar</td>
<td align="right">475.00</td>
</tr>
<tr class="odd">
<td align="left">2016-07-25</td>
<td align="left">2016</td>
<td align="left">Jul</td>
<td align="left">alimentação</td>
<td align="left">sacolao saude st</td>
<td align="right">117.15</td>
</tr>
<tr class="even">
<td align="left">2016-07-25</td>
<td align="left">2016</td>
<td align="left">Jul</td>
<td align="left">alimentação</td>
<td align="left">sacolao saude st</td>
<td align="right">92.55</td>
</tr>
<tr class="odd">
<td align="left">2016-07-25</td>
<td align="left">2016</td>
<td align="left">Jul</td>
<td align="left">alimentação</td>
<td align="left">sacolao saude st</td>
<td align="right">88.82</td>
</tr>
<tr class="even">
<td align="left">2016-07-25</td>
<td align="left">2016</td>
<td align="left">Jul</td>
<td align="left">alimentação</td>
<td align="left">sacolao saude st</td>
<td align="right">74.67</td>
</tr>
</tbody>
</table>

Da tabela acima, verifica-se que o aumento em maio ocorre porque as
compras para a páscoa são pagas em maio, no cartão de crédito.

Portanto, verifica-se que há tendência para gastos extras com a páscoa.

Além disso, o aumento em julho de 2016 ocorreu porque foram feitas 2
compras mensais, para aproveitar uma promoção. Vê-se que este gasto cai
até setembro, voltando a subir em outubro, próxima compra mensal.

O aumento da média em 2016 ocorre porque, além dos fatores acima, em
março 2015 os gastos não foram registrados.

Análise por tipo de despesa: Pagamentos
---------------------------------------

![](readme_files/figure-markdown_strict/plot-pagamentos-1.png)

Observa-se:

-   aumento significativo de de fevereiro a setembro de 2015.

Vamos analisar a tabela de dados, em especial para valores acima de
R$200,00:

<table>
<thead>
<tr class="header">
<th align="left">data</th>
<th align="left">ano</th>
<th align="left">mes</th>
<th align="left">tipo</th>
<th align="left">descrição</th>
<th align="right">valor</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">2015-02-26</td>
<td align="left">2015</td>
<td align="left">Fev</td>
<td align="left">pagamentos</td>
<td align="left">25-02 saque</td>
<td align="right">250</td>
</tr>
<tr class="even">
<td align="left">2015-03-07</td>
<td align="left">2015</td>
<td align="left">Mar</td>
<td align="left">pagamentos</td>
<td align="left">saque</td>
<td align="right">230</td>
</tr>
<tr class="odd">
<td align="left">2015-04-01</td>
<td align="left">2015</td>
<td align="left">Abr</td>
<td align="left">pagamentos</td>
<td align="left">defict mes anterior</td>
<td align="right">230</td>
</tr>
<tr class="even">
<td align="left">2015-05-01</td>
<td align="left">2015</td>
<td align="left">Mai</td>
<td align="left">pagamentos</td>
<td align="left">defict mes anterior</td>
<td align="right">230</td>
</tr>
<tr class="odd">
<td align="left">2015-06-01</td>
<td align="left">2015</td>
<td align="left">Jun</td>
<td align="left">pagamentos</td>
<td align="left">deficit mês anterior</td>
<td align="right">470</td>
</tr>
<tr class="even">
<td align="left">2015-07-01</td>
<td align="left">2015</td>
<td align="left">Jul</td>
<td align="left">pagamentos</td>
<td align="left">defict mes anterior</td>
<td align="right">766</td>
</tr>
<tr class="odd">
<td align="left">2015-08-03</td>
<td align="left">2015</td>
<td align="left">Ago</td>
<td align="left">pagamentos</td>
<td align="left">deficit mês anterior</td>
<td align="right">250</td>
</tr>
<tr class="even">
<td align="left">2015-09-01</td>
<td align="left">2015</td>
<td align="left">Set</td>
<td align="left">pagamentos</td>
<td align="left">deficit mês anterior</td>
<td align="right">490</td>
</tr>
</tbody>
</table>

Verifica-se que este aumento ocorreu porque a cada vez que as metas de
economia não eram alcançadas, o valor gasto acima da meta era lançado no
mês seguinte como déficit, atingindo o pico em agosto.

Por outro lado, verifica-se que nunca mais houve deficit.

Análise por tipo de despesa: Corolla
------------------------------------

![](readme_files/figure-markdown_strict/plot-corolla-1.png)

Observa-se:

-   valores altos de agosto a novembro de 2015
-   queda a partir de jul-16

Vamos analisar a tabela de dados:

<table>
<thead>
<tr class="header">
<th align="left">data</th>
<th align="left">ano</th>
<th align="left">mes</th>
<th align="left">tipo</th>
<th align="left">descrição</th>
<th align="right">valor</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">2015-08-23</td>
<td align="left">2015</td>
<td align="left">Ago</td>
<td align="left">corolla</td>
<td align="left">seguro corolla (1/4)</td>
<td align="right">577.00</td>
</tr>
<tr class="even">
<td align="left">2015-08-25</td>
<td align="left">2015</td>
<td align="left">Ago</td>
<td align="left">corolla</td>
<td align="left">suspensão corolla (2/3)</td>
<td align="right">166.66</td>
</tr>
<tr class="odd">
<td align="left">2015-08-25</td>
<td align="left">2015</td>
<td align="left">Ago</td>
<td align="left">corolla</td>
<td align="left">02-04 bateria (5/5)</td>
<td align="right">65.00</td>
</tr>
<tr class="even">
<td align="left">2015-08-19</td>
<td align="left">2015</td>
<td align="left">Ago</td>
<td align="left">corolla</td>
<td align="left">ducha</td>
<td align="right">10.50</td>
</tr>
<tr class="odd">
<td align="left">2015-09-23</td>
<td align="left">2015</td>
<td align="left">Set</td>
<td align="left">corolla</td>
<td align="left">seguro corolla (2/4)</td>
<td align="right">577.00</td>
</tr>
<tr class="even">
<td align="left">2015-09-25</td>
<td align="left">2015</td>
<td align="left">Set</td>
<td align="left">corolla</td>
<td align="left">manutenção corolla 190k (1/4)</td>
<td align="right">193.75</td>
</tr>
<tr class="odd">
<td align="left">2015-09-25</td>
<td align="left">2015</td>
<td align="left">Set</td>
<td align="left">corolla</td>
<td align="left">suspensão corolla (3/3)</td>
<td align="right">166.66</td>
</tr>
<tr class="even">
<td align="left">2015-09-01</td>
<td align="left">2015</td>
<td align="left">Set</td>
<td align="left">corolla</td>
<td align="left">lavagem carro</td>
<td align="right">30.00</td>
</tr>
<tr class="odd">
<td align="left">2015-09-23</td>
<td align="left">2015</td>
<td align="left">Set</td>
<td align="left">corolla</td>
<td align="left">lavagem carro</td>
<td align="right">10.00</td>
</tr>
<tr class="even">
<td align="left">2015-10-23</td>
<td align="left">2015</td>
<td align="left">Out</td>
<td align="left">corolla</td>
<td align="left">seguro corolla (3/4)</td>
<td align="right">577.00</td>
</tr>
<tr class="odd">
<td align="left">2015-10-25</td>
<td align="left">2015</td>
<td align="left">Out</td>
<td align="left">corolla</td>
<td align="left">manutenção corolla 190k (2/4)</td>
<td align="right">193.75</td>
</tr>
<tr class="even">
<td align="left">2015-11-23</td>
<td align="left">2015</td>
<td align="left">Nov</td>
<td align="left">corolla</td>
<td align="left">seguro corolla (4/4)</td>
<td align="right">577.00</td>
</tr>
<tr class="odd">
<td align="left">2015-11-25</td>
<td align="left">2015</td>
<td align="left">Nov</td>
<td align="left">corolla</td>
<td align="left">manutenção corolla 190k (3/4)</td>
<td align="right">193.75</td>
</tr>
<tr class="even">
<td align="left">2015-12-28</td>
<td align="left">2015</td>
<td align="left">Dez</td>
<td align="left">corolla</td>
<td align="left">manutenção corolla 190k (4/4)</td>
<td align="right">193.75</td>
</tr>
</tbody>
</table>

Verifica-se que isso ocorreu porque em agosto de 2015 foi renovado o
seguro, em 4x, isso explica as altas até novembro; em setembro foi feita
uma manutenção de 10k, também parcelada em 4x.

Por outro lado, a queda a partir de julho de 2016 é explicada pela venda
do carro neste mesmo mês.

Conclusão
=========

Plataforma Mobills:
-------------------

-   ainda não há API que permita o acesso direto aos dados
-   existe um problema com as datas das compras feitas em cartão de
    crédito: são registradas todas como se fossem feitas na data de
    vencimento do cartão
-   desta forma, ao registrar estas compras, anotar na descrição a data
    da transação

Gastos pessoais
---------------

-   os valores mais altos estão em alimentação, pagamentos e corolla
-   deve-se tomar cuidado com os gastos para a páscoa
-   havia um déficit em 2015, mas foi superado
-   o seguro do carro tinha um valor elevado e as manutenções mantinham
    as médias de gasto mensal na casa dos R$500, mas esse problema
    acabou com a venda do carro.
