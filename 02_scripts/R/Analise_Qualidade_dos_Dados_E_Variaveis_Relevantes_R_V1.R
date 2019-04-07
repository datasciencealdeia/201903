gc(reset=TRUE)

setwd("C:\\Users\\rafael.dias\\Documents\\Cursos e Palestras") 

# Instalação dos pacotes necessários para estudar a qualidade dos dados

install.packages("RMySQL")
install.packages("dplyr")
install.packages("data.table")
install.packages("lattice")
install.packages("Matrix")
install.packages("readxl")
install.packages("stringr")
install.packages("forecast")
install.packages("forecastHybrid")
install.packages("corrplot")


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



# Analisando a Qualidade dos Dados

## Nomes dos Campos

names(export_graos)



# Valores Máximos e Mínimos dos principais campos

## ANO

min(export_graos$CO_ANO)

max(export_graos$CO_ANO)



## Toneladas

min(export_graos$KG_LIQUIDO)

max(export_graos$KG_LIQUIDO)



  # Gráfico para entender melhor a distribuição, dado o alto valor de 1798445645 Toneladas

  plot(export_graos$KG_LIQUIDO)
  
  
  

## Valor em Dólares

min(export_graos$VL_FOB)

max(export_graos$VL_FOB)




## Cotação do Dólar

min(export_graos$Fechamento)

max(export_graos$Fechamento)





## Ou prode-se fazer isto no atacado

summary(export_graos)




## Como não existem problemas aparentes nos dados, eles serão explorados

## Qual é o maior pais Importador geral de Grãos em Valor?

import <- data.frame((export_graos %>%
                            group_by(CO_PAIS) %>%
                            dplyr::summarise(Dolares=sum(VL_FOB, na.rm = TRUE)
                            )),
                         row.names = NULL)

import



## Agrupamento gerou vários valores nulos, serão substituídos

import$Dolares[which(is.na(import$Dolares))] <- 0



## Armazenando e encontrando o Pais

m_v <- max(import)

import[import$Dolares == m_v,]



## Procurando o pais no arquivo/tabela referência

m_p_valor <- paises_import[paises_import$X.U.FEFF.CO_PAIS==764,]

m_p_valor




## E o maior importador em Toneladas?

## Qual é o maior pais Importador geral de Grãos em Valor?

import_2 <- data.frame((export_graos %>%
                        group_by(CO_PAIS) %>%
                        dplyr::summarise(Toneladas=sum(KG_LIQUIDO, na.rm = TRUE)
                        )),
                     row.names = NULL)

import_2


## Agrupamento gerou vários valores nulos, serão substituídos

import_2$Toneladas[which(is.na(import_2$Toneladas))] <- 0


## Encontrando e armazenando o Pais

m_v <- max(import_2)

import_2[import_2$Toneladas == m_v,]


## Procurando o pais no arquivo/tabela referência

m_p_ton <- paises_import[paises_import$X.U.FEFF.CO_PAIS==160,]

m_p_ton

## E os maiores em toneladas por tipo de grao?

import_3 <- data.frame((export_graos %>%
                          group_by(CO_PAIS,CO_NCM) %>%
                          dplyr::summarise(Toneladas=sum(KG_LIQUIDO, na.rm = TRUE)
                          )),
                       row.names = NULL)

import_3

ncm

m_i_soja <- data.frame(head(import_3 %>%
                            filter(CO_NCM==12019000) %>%  
                            group_by(CO_PAIS) %>%
                            arrange(desc(Toneladas)),1), 
                      row.names = NULL)

m_i_cafe <- data.frame(head(import_3 %>%
                              filter(CO_NCM==9011110) %>%  
                              group_by(CO_PAIS) %>%
                              arrange(desc(Toneladas)),1), 
                       row.names = NULL)


m_i_milho <- data.frame(head(import_3 %>%
                              filter(CO_NCM==10059010) %>%  
                              group_by(CO_PAIS) %>%
                              arrange(desc(Toneladas)),1), 
                       row.names = NULL)
m_i_soja
m_i_cafe
m_i_milho


m_i_ton_scm <- paises_import[paises_import$X.U.FEFF.CO_PAIS==160 | 
                               paises_import$X.U.FEFF.CO_PAIS==23 | 
                               paises_import$X.U.FEFF.CO_PAIS==372,]

m_i_ton_scm

# E os maiores estados exportadores de Graos em Valor?

export <- data.frame((export_graos %>%
                          group_by(SG_UF_NCM,CO_NCM) %>%
                          dplyr::summarise(Dolares=sum(VL_FOB, na.rm = TRUE)
                          )),
                       row.names = NULL)

export

ncm

m_e_soja <- data.frame(head(export %>%
                              filter(CO_NCM==12019000) %>%  
                              group_by(SG_UF_NCM) %>%
                              arrange(desc(Dolares)),1), 
                       row.names = NULL)

m_e_cafe <- data.frame(head(export %>%
                              filter(CO_NCM==9011110) %>%  
                              group_by(SG_UF_NCM) %>%
                              arrange(desc(Dolares)),1), 
                       row.names = NULL)


m_e_milho <- data.frame(head(export %>%
                               filter(CO_NCM==10059010) %>%  
                               group_by(SG_UF_NCM) %>%
                               arrange(desc(Dolares)),1), 
                        row.names = NULL)
m_e_soja
m_e_cafe
m_e_milho


## Agora vamos verificar quais variáveis são mais relevantes para continuarmos com o estudo:

# Correlação entre quantidade de exportação e variação do dólar

cor.test(export_graos$QT_ESTAT,export_graos$Fechamento)


## Verifica-se uma correlação direta entre estas variáveis

corrplot.mixed(cor(data.frame(Quantidade=export_graos$QT_ESTAT,Dolar=export_graos$Fechamento)), 
               number.cex = 1.5, upper = 'ellipse')


## Como a variável dolar explica a quantidade exportada?

qt_vs_dolar <- lm(export_graos$QT_ESTAT~export_graos$Fechamento)

print(qt_vs_dolar)

summary(qt_vs_dolar)


## Estão faltando variáveis para explicar esta relação, vamos em frente

## Relação entre pais importador e quantidade exportada

cor.test(export_graos$QT_ESTAT,export_graos$CO_PAIS)

## Verifica-se uma correlação direta entre estas variáveis

corrplot.mixed(cor(data.frame(Quantidade=export_graos$QT_ESTAT,Pais=export_graos$CO_PAIS)), number.cex = 1.5, upper = 'ellipse')

## Como uma variável explica a quantidade importada?

qt_vs_paisr <- lm(export_graos$QT_ESTAT~export_graos$CO_PAIS)

print(qt_vs_dolar)

summary(qt_vs_dolar)




## Como a variável CO_PAIS é nominal, não é possivel fazer esta análise

## Quantidade exportada e valor do grão no momento da venda


cor.test(export_graos$QT_ESTAT,export_graos$VL_FOB)


corrplot.mixed(cor(data.frame(Quantidade=export_graos$QT_ESTAT,Valor=export_graos$VL_FOB)), number.cex = 1.5, upper = 'ellipse')


qt_vs_valor <- lm(export_graos$QT_ESTAT~export_graos$VL_FOB)

print(qt_vs_dolar)

summary(qt_vs_dolar)





# E se verificarmos Valor e dolar juntos com quantidade?


corrplot.mixed(cor(data.frame(Quantidade=export_graos$QT_ESTAT,Valor=export_graos$VL_FOB, Dolar=export_graos$Fechamento)), number.cex = 1.5, upper = 'ellipse')


qt_vs_valor_e_dolar <- lm(export_graos$QT_ESTAT~export_graos$VL_FOB+export_graos$Fechamento)

print(qt_vs_valor_e_dolar)

summary(qt_vs_valor_e_dolar)





# Conseguimos cruzar todas as variáveis e validar todas de uma única vez
## Basta separar todas as variáveis numéricas numa única tabela


tab_cor <- data.frame(Quantidade=export_graos$QT_ESTAT,
                      Valor=export_graos$VL_FOB, 
                      Dolar=export_graos$Fechamento, 
                      Toneladas=export_graos$KG_LIQUIDO)


## E fazer a análise de correlação

corrplot.mixed(cor(tab_cor), number.cex = 1.5, upper = 'ellipse')




## Aqui verifica-se que existe relação direta entre toneladas comercializadas e o valor do dolar

ton_vs_dolar <- lm(export_graos$KG_LIQUIDO~export_graos$Fechamento)

print(ton_vs_dolar)

summary(ton_vs_dolar)





## Neste caso uma variável não é suficiente para explicar a outra

# Conclusão: Existem outras variáveis que necessitam ser encontradas e anexadas para explicar as vendas de grãos