setwd('C:\\Users\\rafael.dias\\Documents\\Cursos e Palestras')

# Baixando e Instalando Pacotes

install.packages('dplyr') 

# Chamando os Pacotes

require(dplyr)

#Parte 1

# Tipos do Dados

## Caracter

caracter <- ("Exemplo Caracter")

class(caracter)

 # ou

is.character(caracter)

## Numérico

numerico <- 13

class(numerico)

 # ou

is.numeric(numerico)

## Data

data <- as.Date('2019-04-06')

class(data)

# Criando um objeto Caracter Simples

turma_ds <- ("A Melhor Turma de Todas!")

# Mostrar na tela o conteúdo do objeto

print(turma_ds)

# Criando objetos numéricos

dois <- 2

dez <- 10

vinte <- 20

# Funções matemáticas:

## Soma

dez + vinte

  # ou

10 + 20

## Menos

dez - vinte

## Divisão

vinte / dez

## Exponencial

dois ^ dez

## Raiz Quadrada

sqrt(vinte*dez)

  # ou

sqrt(20*10)

## Logarítmo

log(vinte)

## Média

(dois+dez+vinte)/3

 # ou

mean(c(dois,dez,vinte))

# Criando um vetor

x <- c(1,2,3,4,5,6)   

print(x)

# Elevando cada valor ao quadrado

y <- c(1^2,2^2,3^2,4^2,5^2,6^2)

y

# É o jeito mais fácil?


# Não!!!!

y <- x^2 

y   

# Somando todos os valores de cada vetor

sum(x)

sum(y)

# Criando um objeto com os valores somados

soma_x_y <- c(sum(x),sum(y))

print(soma_x_y)

# Calculando a média do Vetor

mean(y)               

# A variância

var(y)                

# O desvio padrão

sqrt(var(y))

 # ou

sd(y)

# Produto entre vetores

x*y

# Criando matrizes com vetores

## Vetores como colunas

z <- cbind(x,y)

z

class(z)

## Vetores como linhas

w <- rbind(x,y)

w

class(w)


## Operações com Matrizes

z + 1

z * 10

z / 10

## Operações entre Matrizes

z2 <- cbind(x*2,y*2)

z2

z + z2

z - z2

z * z2

z2 / z

# Criando Data Frames

a <- c(1,3,5,7,9,11)

b <- c(2,4,8,16,32,64)

d_f_1 <- data.frame(impares=a,potencia_2=b, row.names = NULL)

View(d_f)

d_f_2 <- data.frame(a=x,b=y,row.names = NULL)

View(d_f_2)

d_f_1 * d_f_2


# Criando Listas

lista <- list(z,d_f_1,"Locura")

lista

# Criando Gráficos

riqueza <- c(15,18,22,24,25,30,31,34,37,39,41,43)

area <- c(2,4.5,6,10,30,34,50,56,60,77.5,80,85)

area.cate <- rep(c("pequeno", "grande"), each=6)

plot(riqueza~area)

plot(area,riqueza) # o mesmo que o anterior

# Editando os gráficos

## Aumentando as margens

par(cex=1.2)

## Representação gráfica do diagrama dos cinco números

boxplot(riqueza~area.cate)

## Diagrama de Barras

barplot(riqueza)

## Histograma

hist(riqueza)

## Inserindo Cores

hist(rnorm(20000),col=c("blue","red","orange","green","pink"))

## Aumentando as marcações

plot(riqueza~area, cex=1)

plot(riqueza~area, cex=1.5)

plot(riqueza~area, cex=2)

plot(riqueza~area, cex=2.5)

plot(riqueza~area, cex=3)

## Inserindo dois gráficos no mesmo objeto

par(mfrow=c(2,1), cex=0.6)

plot(riqueza~area)

boxplot(riqueza~area.cate)

## Inserindo uma reta no gráfico

par(mfrow=c(1,1))

plot(riqueza~area)

abline(15,0.35)

## Inserindo quadrantes conforme a média 

plot(riqueza~area)

abline(v=mean(area))

abline(h=mean(riqueza))


## Inserindo texto

plot(riqueza~area)
text(55,43,"Ponto Mais Distante >>")


x11()

## Abrindo numa nova janela

x11()

plot(riqueza~area)
text(55,43,"Ponto Mais Distante >>")

## Salvando o gráfico em arquivo

jpeg(filename = "Grafico_R.jpg", width = 1080, height = 1080, 
     units = "px", pointsize = 12, quality = 100,
     bg = "white",  res = NA, restoreConsole = TRUE)

par(mfrow=c(1,2), cex=2)
par(mar=c(14,4,8,2), cex=2)
plot(riqueza~area)
boxplot(riqueza~area.cate)

dev.off()

# ETL Básico em R

## criando tabela com os valores abaixo:

vendas <- data.frame(vendedor=c(13,26,39,39,07,14,13,07,21),vendas=c(300,500,110,150,280,580,90,20,800))

vendas

metas <- data.frame(vendedor=c(07,13,14,21,26,39),meta=c(2000,800,1250,1050,1400,1550))

metas


# Junções

## Juntar informações numa única tabela

valida_metas <- merge(vendas,metas,"vendedor")

valida_metas

valida_metas_2 <- left_join(vendas,metas,"vendedor")

valida_metas_2

# Agrupamentos
## Somando as vendas


result_mes <- data.frame((valida_metas %>%
                            group_by(vendedor) %>%
                            dplyr::summarise(meta=max(meta, na.rm = TRUE),
                                             vendas= sum(vendas, na.rm = TRUE)
                            )),
                         row.names = NULL)
 
View(result_mes)

 
# Transformações
## A meta está em reais e as vendas em dolares

result_mes$vendas <- result_mes$vendas*3.9

result_mes

# Criação de Variáveis
## Criar campo para que seja validado quem atingiu a meta

result_mes$ating_meta <- ifelse(result_mes$vendas>=result_mes$meta,"SIM","NÃO")

result_mes

#-----------------------------------------------------------#

# Cálculos mais complexos

## Correlação entre duas variáveis

cor.test(x,y)

# Ajustando um modelo de regreção linear >> "y = f(x)" or "y = B0 + (B1 * x)"

## E guardando as informações na variável lm_1

lm_1<-lm(y ~ x)    

## Mostrando o modelo construído

print(lm_1)           

## Verificando detalhes do modelo

summary(lm_1)          

## Dimensionando uma janela 2 por 2 (4 Gráficos)

par(mfrow=c(2, 2))    

## Explicação Gráfica do Modelo

plot(lm_1)   

#-----------------------------------------------------------#

# Verificando o poder gráfico do R

library(caTools)        # external package providing write.gif function 
jet.colors<-colorRampPalette(c("#00007F", "blue", "#007FFF", "cyan", "#7FFF7F", "yellow", "#FF7F00", "red", "#7F0000"))
m<-1200                # define size
C<-complex( real=rep(seq(-1.8,0.6, length.out=m), each=m ),
             imag=rep(seq(-1.2,1.2, length.out=m), m ) )
C<-matrix(C,m,m)       # reshape as square matrix of complex numbers
Z<-0                   # initialize Z to zero
X<-array(0, c(m,m,50)) # initialize output 3D array 
for (k in 1:50) {       # loop with 50 iterations
  Z<-Z^2+C             # the central difference equation
  X[,,k]<-exp(-abs(Z)) # capture results
}
write.gif(X, "Data_Science_Aldeia.gif", col=jet.colors, delay=100)
