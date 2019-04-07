gc(reset=TRUE)

setwd("C:\\Users\\rafael.dias\\Documents\\Cursos e Palestras") 

# Instalação dos pacotes necessários para estudar a qualidade dos dados
# 
# install.packages("RMySQL")
# install.packages("dplyr")
# install.packages("data.table")
# install.packages("lattice")
# install.packages("Matrix")
# install.packages("readxl")
# install.packages("stringr")
# install.packages("forecast")
# install.packages("forecastHybrid")
# install.packages("corrplot")
#

# Carregando os pacotes

library(RMySQL)
library(dplyr)
require(data.table)
library(lattice)
library(Matrix)
library(DMwR)
library(readxl)
library(corrplot)
library(stringr)
library(forecast)
library(forecastHybrid)



# Importando o arquivo proviniente da ETL para Análise da qualidade do dado

export_graos <- data.table(read.csv2("https://raw.githubusercontent.com/datasciencealdeia/201903/master/03_dados/auxiliares/Base_AgroXP_0504.csv", header = T, sep=";"))

View(export_graos)



# Importando o arquivo com os Paises Importadores

paises_import <- data.table(read.table("https://raw.githubusercontent.com/datasciencealdeia/201903/master/03_dados/auxiliares/Paises_Importadores.txt", header = T, sep=";", encoding = "UTF-8"))

View(paises_import)



# Criando Informações das NCM de soja, milho e café

ncm <- data.table(CO_NCM=c(12019000,9011110,10059010), Nome=c("Soja","Cafe","Milho"))

View(ncm)



# Recomenda-se a utilização do tempo e da variável resposta para modelar a previsão
## Serão utilizados os modelos de Séries Temporais - ARIMA e Hybrid

# Agrupando as informações de vendas de grãos, mes a mes, para cada tipo de produto

soja_inf <- data.frame((export_graos[export_graos$CO_NCM==12019000,] %>%
                          group_by(CO_NCM,CO_ANO_MES) %>%
                                     dplyr::summarise(Toneladas=sum(KG_LIQUIDO, na.rm = TRUE)
                                     )),
                                  row.names = NULL)
View(soja_inf)


cafe_inf <- data.frame((export_graos[export_graos$CO_NCM==9011110,] %>%
                          group_by(CO_NCM,CO_ANO_MES) %>%
                          dplyr::summarise(Toneladas=sum(KG_LIQUIDO, na.rm = TRUE)
                          )),
                       row.names = NULL)
View(cafe_inf)



milho_inf <- data.frame((export_graos[export_graos$CO_NCM==10059010,] %>%
                          group_by(CO_NCM,CO_ANO_MES) %>%
                          dplyr::summarise(Toneladas=sum(KG_LIQUIDO, na.rm = TRUE)
                          )),
                       row.names = NULL)
View(milho_inf)


# Separando informações para teste dos Modelos

soja_teste    <- soja_inf[soja_inf$CO_ANO_MES >= 201901,]

cafe_teste    <- cafe_inf[cafe_inf$CO_ANO_MES >= 201901,]

milho_teste  <- milho_inf[milho_inf$CO_ANO_MES >= 201901,]

soja_teste



# Separando dados para construção dos Modelos de Séries Temporais

soja_treino    <- soja_inf[soja_inf$CO_ANO_MES < 201901,]

cafe_treino    <- cafe_inf[cafe_inf$CO_ANO_MES < 201901,]

milho_treino  <- milho_inf[milho_inf$CO_ANO_MES >= 201201 & milho_inf$CO_ANO_MES < 201901,]

milho_treino



# Transformando as informações em Objetos de Séries Temporais

## Soja

min(soja_treino$CO_ANO_MES)

max(soja_treino$CO_ANO_MES)

soja_st <-  ts(soja_treino$Toneladas, frequency = 12, start = c(2012,01), end = c(2018,12))



## Café

min(cafe_treino$CO_ANO_MES)

max(cafe_treino$CO_ANO_MES)

cafe_st <-  ts(cafe_treino$Toneladas, frequency = 12, start = c(1997,01), end = c(2018,12))



## Milho

min(milho_treino$CO_ANO_MES)

max(milho_treino$CO_ANO_MES)

milho_st <-  ts(milho_treino$Toneladas, frequency = 12, start = c(2012,01), end = c(2018,12))

## Analisando os gráficos de Séries Temporais

x11()

par(mfrow=c(3, 1))  

plot(soja_st)

plot(cafe_st)

plot(milho_st)


## Analisando os gráficos Vê-se a oportunidade de colocar todos na mesma medida temporal
# Havendo tempo fazer junto com a turma

## Gerando os modelos para cada série

# Arima

soja_mod_arima <- auto.arima(soja_st, seasonal = TRUE, stepwise = FALSE, parallel = TRUE)

cafe_mod_arima <- auto.arima(cafe_st, seasonal = TRUE, stepwise = FALSE, parallel = TRUE)

milho_mod_arima <- auto.arima(milho_st, seasonal = FALSE, stepwise = FALSE, parallel = TRUE)


## Previsão

soja_prev <- forecast(soja_mod_arima,level = 80, h = 6)

cafe_prev <- forecast(cafe_mod_arima,level = 80, h = 6)

milho_prev <- forecast(milho_mod_arima,level = 80, h = 6)



# Modelo Hybrid

soja_mod_hybrid <- hybridModel(soja_st, errorMethod = 'RMSE')

cafe_mod_hybrid <- hybridModel(cafe_st, errorMethod = 'RMSE')

milho_mod_hybrid <- hybridModel(milho_st, errorMethod = 'RMSE')


## Previsão

soja_prev_h <- forecast(soja_mod_hybrid,level = 80, h = 6)

cafe_prev_h <- forecast(cafe_mod_hybrid,level = 80, h = 6)

milho_prev_h <- forecast(milho_mod_hybrid,level = 80, h = 6)


## Analisando os gráficos das Previsões ARIMA

x11()

par(mfrow=c(3, 1))  

plot(soja_prev, showgap = FALSE, xlab = 'SOJA')

plot(cafe_prev, showgap = FALSE, xlab = 'CAFÉ')

plot(milho_prev, showgap = FALSE, xlab = 'MILHO')


## Analisando os gráficos das Previsões Hybrid

x11()

par(mfrow=c(3, 1))  

plot(soja_prev_h, showgap = FALSE, xlab = 'SOJA')

plot(cafe_prev_h, showgap = FALSE, xlab = 'CAFÉ')

plot(milho_prev_h, showgap = FALSE, xlab = 'MILHO')


## Preparação das infomações para validar qual foi o melhor modelo


soja_teste$Prev_Arima <- c(soja_prev[["mean"]][1],soja_prev[["mean"]][2])
soja_teste$Prev_Hybrid <- c(soja_prev_h[["mean"]][1],soja_prev_h[["mean"]][2])
soja_teste$MAPE_ARIMA <- abs(soja_teste$Prev_Arima-soja_teste$Toneladas)/soja_teste$Toneladas
soja_teste$MAPE_Hybrid <- abs(soja_teste$Prev_Hybrid-soja_teste$Toneladas)/soja_teste$Toneladas


cafe_teste$Prev_Arima <- c(cafe_prev[["mean"]][1],cafe_prev[["mean"]][2])
cafe_teste$Prev_Hybrid <- c(cafe_prev_h[["mean"]][1],cafe_prev_h[["mean"]][2])
cafe_teste$MAPE_ARIMA <- abs(cafe_teste$Prev_Arima-cafe_teste$Toneladas)/cafe_teste$Toneladas
cafe_teste$MAPE_Hybrid <- abs(cafe_teste$Prev_Hybrid-cafe_teste$Toneladas)/cafe_teste$Toneladas


milho_teste$Prev_Arima <- c(milho_prev[["mean"]][1],milho_prev[["mean"]][2])
milho_teste$Prev_Hybrid <- c(milho_prev_h[["mean"]][1],milho_prev_h[["mean"]][2])
milho_teste$MAPE_ARIMA <- abs(milho_teste$Prev_Arima-milho_teste$Toneladas)/milho_teste$Toneladas
milho_teste$MAPE_Hybrid <- abs(milho_teste$Prev_Hybrid-milho_teste$Toneladas)/milho_teste$Toneladas



# AND NOW, THE OSCAR GOES TO...



soja_teste

cafe_teste

milho_teste



#   M O D E L O    H Y B R I D  ! ! ! ! ! ! !






















































# E qual o melhor commodities para investir neste semestre?

## Gráficos das Previsões ARIMA

x11()

par(mfrow=c(3, 1))  

plot(soja_prev, showgap = FALSE, xlab = 'SOJA')

plot(cafe_prev, showgap = FALSE, xlab = 'CAFÉ')

plot(milho_prev, showgap = FALSE, xlab = 'MILHO')

## Recomenda-se que o investimento seja realizado em SOJA!!

