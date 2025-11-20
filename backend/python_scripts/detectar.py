from fastapi import FastAPI, File, UploadFile
from ultralytics import YOLO
import uvicorn
import io
from PIL import Image
import json

# 1. Inicializamos la App (El Servidor)
app = FastAPI()

# 2. Cargamos el modelo UNA SOLA VEZ al arrancar
# Esto es clave: ya no carga el modelo en cada foto, así que será ultra rápido (milisegundos)
print("-----------------------------------------")
print("🚀 CARGANDO MODELO EN MEMORIA (GPU/CPU)...")
try:
    model = YOLO('yolov8m.pt') 
    print("✅ MODELO CARGADO Y LISTO PARA RECIBIR PETICIONES.")
except Exception as e:
    print(f"❌ ERROR CARGANDO MODELO: {e}")

@app.post("/detectar")
async def detectar_ingredientes(file: UploadFile = File(...)):
    try:
        # 3. Leer la imagen que nos manda Laravel desde la memoria RAM
        contents = await file.read()
        image = Image.open(io.BytesIO(contents))

        # 4. Inferencia (Detectar cosas)
        results = model.predict(image, conf=0.25, save=False, verbose=False)
        
        # 5. Procesar resultados
        result = results[0]
        detectados = {}
        
        for box in result.boxes:
            class_id = int(box.cls[0])
            nombre = model.names[class_id]
            
            if nombre in detectados:
                detectados[nombre] += 1
            else:
                detectados[nombre] = 1

        # 6. Crear el JSON de respuesta
        lista_final = []
        for ingrediente, cantidad in detectados.items():
            lista_final.append({
                "ingrediente": ingrediente,
                "cantidad": cantidad,
                "unidad_estimada": "unidad(es)"
            })
            
        return {"success": True, "data": lista_final}

    except Exception as e:
        return {"success": False, "error": str(e)}

# 7. Arrancar el servidor en el puerto 5000
if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=5000)