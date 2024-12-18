# Análise RFM utilizando K-means para Segmentação de Clientes

## Descrição do Projeto

O projeto de análise RFM (Recência, Frequência e Monetização) tem como objetivo segmentar clientes de um e-commerce para entender melhor os comportamentos de compra e otimizar as estratégias de marketing. A segmentação é realizada utilizando o algoritmo K-means para identificar grupos de clientes com comportamentos semelhantes.

A análise é baseada no dataset do Kaggle: [Projeto 3 - Segmentación de Clientes en Ecommerce](https://www.kaggle.com/datasets/datacertlaboratoria/proyecto-3-segmentacin-de-clientes-en-ecommerce). A partir desse conjunto de dados, aplicamos a técnica RFM para calcular os três principais indicadores e, em seguida, usamos o K-means para realizar a segmentação de clientes.

## Objetivos

1. **Aplicar a análise RFM**: Calcular Recência, Frequência e Valor Monetário para cada cliente.
2. **Segmentação de clientes**: Usar o algoritmo K-means para segmentar os clientes em grupos com comportamentos semelhantes.
3. **Exploração de resultados**: Visualizar e interpretar os clusters gerados para tomar decisões estratégicas.

## Etapas do Processo

1. **Carregamento e Pré-processamento de Dados**
   - Importação do dataset.
   - Tratamento de valores ausentes e dados inconsistentes.
   - Criação das métricas RFM (Recência, Frequência e Monetização).

2. **Análise RFM**
   - **Recência (R)**: Tempo desde a última compra.
   - **Frequência (F)**: Número de compras feitas.
   - **Monetização (M)**: Total gasto pelos clientes.

3. **Aplicação do K-means**
   - Definição do número de clusters.
   - Treinamento do modelo K-means.
   - Análise dos clusters gerados.

4. **Visualização dos Resultados**
   - Gráficos para analisar a distribuição dos clusters.
   - Interpretação dos clusters para entender o comportamento dos clientes.

## Colunas do Dataset

Abaixo estão as colunas do dataset que foram usadas na análise:

1. **`ID`**: Identificador único do cliente.
2. **`Date`**: Data da compra feita pelo cliente.
3. **`Product`**: Produto comprado.
4. **`Quantity`**: Quantidade de produtos comprados.
5. **`Price`**: Preço unitário do produto.
6. **`Total_Price`**: Preço total da compra (Quantity * Price).
7. **`Customer_ID`**: Identificador único do cliente (pode ser igual a `ID` em alguns casos, mas foi mantido para facilitar a referência).
8. **`Transaction_ID`**: Identificador único da transação de compra.
9. **`Purchase_Amount`**: Quantidade total de compras feitas por cada cliente.
10. **`First_Purchase`**: Data da primeira compra realizada pelo cliente.
11. **`Last_Purchase`**: Data da última compra realizada pelo cliente.

## Conclusões

A análise e segmentação de clientes com a técnica RFM e o algoritmo K-means permitem entender melhor os comportamentos de compra e identificar grupos de clientes com características semelhantes. Esses resultados podem ser usados para personalizar campanhas de marketing, promover produtos de forma estratégica e aumentar a retenção de clientes.
