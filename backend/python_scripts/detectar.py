from fastapi import FastAPI, File, UploadFile
from ultralytics import YOLO
import uvicorn
import io
from PIL import Image
import json
import easyocr          
import numpy as np      

app = FastAPI()


try:
    model = YOLO('yolov8m.pt') 
except Exception as e:
    print(f"❌ ERROR CARGANDO YOLO: {e}")

try:
    print("... Cargando lector de texto (EasyOCR)...")
    reader = easyocr.Reader(['es', 'en'], gpu=False) 
except Exception as e:
    print(f"❌ ERROR CARGANDO EASYOCR: {e}")

print("SISTEMA LISTO PARA RECIBIR PETICIONES.")

@app.post("/detectar")
async def detectar_ingredientes(file: UploadFile = File(...)):
    try:
        contents = await file.read()
        image_pil = Image.open(io.BytesIO(contents))
        
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

        image_np = np.array(image_pil) 
        
        textos_crudos = reader.readtext(image_np, detail=0)
        
        textos_limpios = [t.lower().strip() for t in textos_crudos]

        response_data = {
            "visual": lista_visual,      
            "etiquetas": textos_limpios  
        }
            
        return {"success": True, "data": response_data}

    except Exception as e:
        print(f"Error en el procesamiento: {e}")
        return {"success": False, "error": str(e)}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=5000)