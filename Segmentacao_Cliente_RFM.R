# Segmentação de Clientes com Análise RFM

# Este estudo está sendo realizado a partir de dados obtidos do Kaggle, segue url para
# download/leitura do csv:
# https://www.kaggle.com/datasets/datacertlaboratoria/proyecto-3-segmentacin-de-clientes-en-ecommerce

setwd('~/Documents/PROJECTS/SEGMENTACAO_CLIENTE_ANALISE_RFM/')
getwd()

#Carregando pacotes
library(readr)
library(ggplot2)
library(plotly)
library(rfm)
library(caret)
library(stats)
library(readxl)
library(factoextra)

# Carregando nosso dataset
carrega_dados <- read.csv('dados/ventas-por-factura.csv')
View(carrega_dados)
dim(carrega_dados)
str(carrega_dados)

# Verificando se há valores ausentes por coluna
df1 <- carrega_dados
colSums(is.na(df1))  # ID.Cliente = 3724

# Removendo valores vazios
df1 <- na.omit(df1)
sum(is.na(df1))
dim(df1)

# Converte a coluna "Monto" para numérica
df1$Monto <- gsub(",", ".", df1$Monto)
df1$Monto <- as.numeric(df1$Monto)
str(df1)

# Excluindo valores negativas
df1 <- df1[df1$Cantidad >= 0, ] 
df1 <- df1[df1$Monto >= 0, ]
dim(df1)

# De acordo com o manual do dataset, há na coluna N° Fatura
# valores que começam com "C", indicando o cancelamento de compra.
df1 <- df1[!grepl("C",df1$N..de.factura),]
View(df1) 
dim(df1)

# Vericando e removendo valores duplicados de "N° de fatura"
  #verifica
  verifica_duplicado <- duplicated(df1$N..de.factura)
  print(df1[verifica_duplicado, ])
  sum(duplicated(df1$N..de.factura))
  
  #remove
  dados <- df1[!verifica_duplicado, ]
  sum(duplicated(dados$N..de.factura))
 
  dim(dados)
 
 
 # Limpeza e Pré-processamento dos dados
  
  # Adicionando uma nova coluna com o total gasto por item
 dataset <- dados
 str(dataset)
 
 dataset$MontoTotal <- (dataset$Cantidad * dataset$Monto)
 View(dataset)
 
# Verificando o número de transações feitas e o número total de clientes
length(dataset$ID.Cliente)
length(unique(dataset$ID.Cliente))

# Total gasto por cliente
total_gasto <- dataset %>%
  group_by(ID.Cliente) %>%
  summarise(Sum = sum(MontoTotal))

View(total_gasto)


# Renomeando as colunas do dataset
dataset2 <- dataset

dataset2 = dataset %>% 
  summarise(
      Numero_fatura = N..de.factura,
      Data_transacao = Fecha.de.factura,
      ID_cliente = ID.Cliente,
      Quantidade = Cantidad,
      Valor_fatura = Monto,
      Valor_total_fatura = MontoTotal
  )

head(dataset2)

# Converte a coluna da data da transação 
options(digits.secs = 3)
dataset2$Data_transacao <- as.Date(as.POSIXct(dataset2$Data_transacao, format = "%m/%d/%Y %H:%M:%S"))
View(dataset2)


# Verificando a data mais atual e criando a data referência
max(dataset2$Data_transacao)
date_ref = as.Date.character("12/31/2021","%m/%d/%Y")
date_ref

# RFM

x <- dataset2 %>% 
        group_by(ID_cliente) %>% 
        summarise(
                  Recencia = as.numeric(date_ref - max(Data_transacao)),
                  Frequencia = aggregate(ID_cliente ~ ID_cliente, FUN = length),
                  Monetario = sum(Valor_total_fatura),
                  Primeira_Compra = min(Data_transacao)
  )

View(x)

# Importante tratar os dados que podem ser outliers, ou seja, que esteja
# abaixo do 1º quartil e acima do 3° quartil.
# Importante calcular o intervalo interquartil para podermos tratar de forma
# eficiente os nossos dados.
Q1 <- quantile(x$Monetario, .25)
Q3 <- quantile(x$Monetario, .75)
IQR <- IQR(x$Monetario)
x <- subset(x, x$Monetario >= (Q1 - 1.5 * IQR) & x$Monetario <= (Q3 + 1.5 * IQR))


# Segmentação do cliente
segmenta_cliente <- function(rfm)
{
  # Cria uma lista
  resultados <- list()
  
  # Obtém os valores RFM
  dados_rfm <- select(rfm, c('Recencia','Frequencia','Monetario'))
  
  # Cria o modelo
  modelo_kmeans <- kmeans(dados_rfm, center = 5, iter.max = 50)
  
  # Plot do modelo
  resultados$plot <- fviz_cluster(modelo_kmeans, 
                                  data = dados_rfm, 
                                  geom = c('point'), 
                                  ellipse.type = 'euclid')
  
  # Organiza os dados
  dados_rfm$`Customer ID` <- rfm$ID_cliente
  dados_rfm$clusters <- modelo_kmeans$cluster
  resultados$data <- dados_rfm
  
  return(resultados)
}

grafico <- segmenta_cliente(x)[1]
grafico

tabela <- segmenta_cliente(x)[2]
View(as.data.frame(tabela))

