FROM ubuntu:22.04

# Garantir que estamos usando UTF-8
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

# Adicionar repositório do QGIS usando uma abordagem mais simples
RUN apt-get update && apt-get install -y \
    software-properties-common \
    && add-apt-repository ppa:ubuntugis/ppa \
    && add-apt-repository ppa:ubuntugis/ubuntugis-unstable

# Instalar dependências necessárias
RUN apt-get update && apt-get install -y \
    python3-pip \
    python3-qgis \
    qgis \
    qgis-server \
    xvfb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Atualizar pip e instalar bibliotecas Python
RUN python3 -m pip install --upgrade pip && \
    pip3 install \
    requests \
    fastapi \
    uvicorn

# Criar diretório de trabalho
WORKDIR /app

# Copiar o resto dos arquivos
COPY . .

# Expor porta para a API
EXPOSE 8000

# Script de inicialização
CMD ["python3", "-m", "uvicorn", "api:app", "--host", "0.0.0.0", "--port", "8000"]