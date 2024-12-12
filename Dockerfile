FROM ubuntu:22.04

# Garantir que estamos usando UTF-8
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

# Instalar dependências do sistema e Xvfb
RUN apt-get update && apt-get install -y \
    software-properties-common \
    xvfb \
    x11-utils \
    libxkbcommon-x11-0 \
    libxcb-icccm4 \
    libxcb-image0 \
    libxcb-keysyms1 \
    libxcb-randr0 \
    libxcb-render-util0 \
    libxcb-shape0 \
    libxcb-xinerama0

# Adicionar repositórios do QGIS
RUN add-apt-repository ppa:ubuntugis/ppa \
    && add-apt-repository ppa:ubuntugis/ubuntugis-unstable

# Instalar dependências necessárias
RUN apt-get update && apt-get install -y \
    python3-pip \
    python3-qgis \
    qgis \
    qgis-server \
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

# Configurar variáveis de ambiente para X11
ENV DISPLAY=:99
ENV QT_QPA_PLATFORM=offscreen

# Instalar script de inicialização
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expor porta para a API
EXPOSE 8000

# Script de inicialização
CMD ["/start.sh"]