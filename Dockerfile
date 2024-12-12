FROM ubuntu:22.04

# Garantir que estamos usando UTF-8
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

# Adicionar repositório do QGIS primeiro
RUN apt-get update && apt-get install -y \
    software-properties-common \
    && add-apt-repository ppa:ubuntugis/ppa

# Instalar dependências necessárias
RUN apt-get update && apt-get install -y \
    python3.10 \
    python3.10-dev \
    python3-pip \
    python3-qgis \
    qgis-server \
    xvfb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Atualizar pip e instalar bibliotecas Python
RUN python3 -m pip install --upgrade pip && \
    pip3 install \
    pyqgis \
    requests \
    fastapi \
    uvicorn

# Criar diretório de trabalho
WORKDIR /app

# Copiar primeiro os requisitos (se existirem)
COPY requirements.txt* ./
RUN if [ -f "requirements.txt" ]; then pip install -r requirements.txt; fi

# Copiar o resto dos arquivos
COPY . .

# Expor porta para a API
EXPOSE 8000

# Script de inicialização
CMD ["python3", "-m", "uvicorn", "api:app", "--host", "0.0.0.0", "--port", "8000"]
