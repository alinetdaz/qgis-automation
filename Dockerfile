FROM ubuntu:22.04

# Garantir que estamos usando UTF-8
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

# Adicionar repositório do QGIS primeiro
RUN apt-get update && apt-get install -y \
    software-properties-common \
    wget \
    gnupg \
    && wget -qO - https://qgis.org/downloads/qgis-2023.gpg.key | gpg --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/qgis-archive.gpg --import \
    && chmod a+r /etc/apt/trusted.gpg.d/qgis-archive.gpg \
    && add-apt-repository "deb https://qgis.org/ubuntu $(lsb_release -c -s) main"

# Instalar dependências necessárias
RUN apt-get update && apt-get install -y \
    python3-qgis \
    qgis-server \
    python3-pip \
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

# Copiar primeiro os requisitos (se existirem)
COPY requirements.txt* ./
RUN if [ -f "requirements.txt" ]; then pip install -r requirements.txt; fi

# Copiar o resto dos arquivos
COPY . .

# Expor porta para a API
EXPOSE 8000

# Script de inicialização
CMD ["python3", "-m", "uvicorn", "api:app", "--host", "0.0.0.0", "--port", "8000"]