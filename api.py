from fastapi import FastAPI, BackgroundTasks
from pydantic import BaseModel
import qgis.core
from qgis.core import QgsApplication
import os

# Criar a instância do FastAPI - IMPORTANTE: deve se chamar 'app'
app = FastAPI()

# Inicializar QGIS
QgsApplication.setPrefixPath('/usr', True)
qgs = QgsApplication([], False)
qgs.initQgis()

# Rota de teste/healthcheck
@app.get("/")
async def root():
    return {"status": "healthy", "qgis_version": qgis.core.Qgis.QGIS_VERSION}

# Rota para verificar se está funcionando
@app.get("/health")
async def health_check():
    return {"status": "healthy"}