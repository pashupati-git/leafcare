from fastapi import FastAPI, File, UploadFile, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from PIL import Image
import io
import tensorflow as tf
import numpy as np
import os

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Adjust in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
MODEL_PATH = os.path.abspath(os.path.join(BASE_DIR, "..", "..", "assets", "plant_disease_model.tflite"))

# Load TFLite model
try:
    interpreter = tf.lite.Interpreter(model_path=MODEL_PATH)
    interpreter.allocate_tensors()
    print(f"✅ TFLite model loaded from: {MODEL_PATH}")
except Exception as e:
    interpreter = None
    print(f"❌ Failed to load TFLite model: {e}")

input_details = interpreter.get_input_details() if interpreter else None
output_details = interpreter.get_output_details() if interpreter else None

print("📥 Input details:", input_details)
print("📤 Output details:", output_details)

# 39 class names (one for each output index)
class_names = [
    'Apple___Apple_scab',
    'Apple___Black_rot',
    'Apple___Cedar_apple_rust',
    'Apple___healthy',
    'Blueberry___healthy',
    'Cherry_(including_sour)___Powdery_mildew',
    'Cherry_(including_sour)___healthy',
    'Corn___Cercospora_leaf_spot Gray_leaf_spot',
    'Corn___Common_rust_',
    'Corn___Northern_Leaf_Blight',
    'Corn___healthy',
    'Grape___Black_rot',
    'Grape___Esca_(Black_Measles)',
    'Grape___Leaf_blight_(Isariopsis_Leaf_Spot)',
    'Grape___healthy',
    'Orange___Haunglongbing_(Citrus_greening)',
    'Peach___Bacterial_spot',
    'Peach___healthy',
    'Pepper,_bell___Bacterial_spot',
    'Pepper,_bell___healthy',
    'Potato___Early_blight',
    'Potato___Late_blight',
    'Potato___healthy',
    'Raspberry___healthy',
    'Soybean___healthy',
    'Squash___Powdery_mildew',
    'Strawberry___Leaf_scorch',
    'Strawberry___healthy',
    'Tomato___Bacterial_spot',
    'Tomato___Early_blight',
    'Tomato___Late_blight',
    'Tomato___Leaf_Mold',
    'Tomato___Septoria_leaf_spot',
    'Tomato___Spider_mites Two-spotted_spider_mite',
    'Tomato___Target_Spot',
    'Tomato___Tomato_Yellow_Leaf_Curl_Virus',
    'Tomato___Tomato_mosaic_virus',
    'Tomato___healthy'
]

def preprocess_image(image: Image.Image) -> np.ndarray:
    if not input_details:
        raise RuntimeError("Model input details not found.")
    height, width = input_details[0]['shape'][1:3]
    image = image.resize((width, height))
    image_array = np.array(image).astype(np.float32) / 255.0

    # If image has an alpha channel (RGBA), discard the alpha
    if image_array.shape[-1] == 4:
        image_array = image_array[..., :3]

    image_array = np.expand_dims(image_array, axis=0)  # [1, 160, 160, 3]
    return image_array

@app.get("/")
async def root():
    return {"message": "🌿 Plant Disease Detection API is running."}

@app.post("/predict/")
async def predict(file: UploadFile = File(...)):
    if interpreter is None:
        raise HTTPException(status_code=503, detail="Model not loaded.")

    if file.content_type not in ["image/jpeg", "image/png", "image/jpg"]:
        raise HTTPException(status_code=400, detail="Invalid image format. Upload JPEG or PNG.")

    contents = await file.read()
    if not contents:
        raise HTTPException(status_code=400, detail="Empty file uploaded.")

    try:
        image = Image.open(io.BytesIO(contents)).convert("RGB")
        processed_image = preprocess_image(image)

        interpreter.set_tensor(input_details[0]['index'], processed_image)
        interpreter.invoke()

        output_data = interpreter.get_tensor(output_details[0]['index'])  # [1, 39]
        prediction = output_data[0]
        predicted_index = int(np.argmax(prediction))
        confidence = float(prediction[predicted_index]) * 100
        survivability = 100 - confidence

        disease = class_names[predicted_index] if predicted_index < len(class_names) else "Unknown"

        return {
            "status": "success",
            "disease": disease,
            "confidence": round(confidence, 2),
            "survivability": round(survivability, 2)
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error processing image: {e}")
