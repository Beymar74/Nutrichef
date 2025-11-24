from fastapi import FastAPI, File, UploadFile
from ultralytics import YOLO
import uvicorn
import io
from PIL import Image
import json
import easyocr          # <--- NUEVO
import numpy as np      # <--- NUEVO (Necesario para convertir la imagen para OCR)

# 1. Inicializamos la App
app = FastAPI()

# 2. CARGA DE MODELOS (YOLO + OCR)
print("-----------------------------------------")
print("🚀 INICIANDO SISTEMA DE IA NUTRICHEF...")

# --- Cargar YOLO ---
try:
    print("... Cargando cerebro visual (YOLOv8)...")
    model = YOLO('yolov8m.pt') 
    print("✅ YOLO CARGADO.")
except Exception as e:
    print(f"❌ ERROR CARGANDO YOLO: {e}")

# --- Cargar EasyOCR ---
try:
    print("... Cargando lector de texto (EasyOCR)...")
    # 'es' = español, 'en' = inglés. gpu=False para asegurar compatibilidad en laptop
    reader = easyocr.Reader(['es', 'en'], gpu=False) 
    print("✅ EASYOCR CARGADO.")
except Exception as e:
    print(f"❌ ERROR CARGANDO EASYOCR: {e}")

print("✅ SISTEMA LISTO PARA RECIBIR PETICIONES.")
print("-----------------------------------------")


@app.post("/detectar")
async def detectar_ingredientes(file: UploadFile = File(...)):
    try:
        # 3. Leer la imagen
        contents = await file.read()
        image_pil = Image.open(io.BytesIO(contents)) # Imagen formato PIL (Para YOLO)
        
        # --- PARTE 1: YOLO (VISUAL) ---
        results = model.predict(image_pil, conf=0.25, save=False, verbose=False)
        result = results[0]
        detectados = {}
        
        for box in result.boxes:
            class_id = int(box.cls[0])
            nombre = model.names[class_id]
            if nombre in detectados:
                detectados[nombre] += 1
            else:
                detectados[nombre] = 1

        lista_visual = []
        for ingrediente, cantidad in detectados.items():
            lista_visual.append({
                "ingrediente": ingrediente,
                "cantidad": cantidad,
                "unidad_estimada": "unidad(es)"
            })

        # --- PARTE 2: EASYOCR (TEXTO) ---
        # Convertimos la imagen PIL a un array de NumPy porque EasyOCR no lee PIL directo
        image_np = np.array(image_pil) 
        
        # detail=0 devuelve solo la lista de strings encontrados
        textos_crudos = reader.readtext(image_np, detail=0)
        
        # Limpieza inicial: todo a minúsculas para facilitar el trabajo a tu Backend
        textos_limpios = [t.lower().strip() for t in textos_crudos]

        # 6. Crear el JSON de respuesta COMBINADO
        response_data = {
            "visual": lista_visual,      # Lo que vio YOLO (ej: tomate, botella)
            "etiquetas": textos_limpios  # Lo que leyó OCR (ej: "grano de oro", "peso neto")
        }
            
        return {"success": True, "data": response_data}

    except Exception as e:
        print(f"Error en el procesamiento: {e}")
        return {"success": False, "error": str(e)}

# 7. Arrancar el servidor
if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=5000)