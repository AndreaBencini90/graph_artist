from realesrgan import RealESRGAN
from PIL import Image

def upscale_image_realesrgan(image_path, output_path, scale=10):
    """
    Utilizza Real-ESRGAN per migliorare l'immagine e aumentare la risoluzione.
    
    :param image_path: Percorso dell'immagine di input.
    :param output_path: Percorso per salvare l'immagine di output.
    :param scale: Fattore di scala (default: 10).
    """
    # Carica il modello Real-ESRGAN
    model = RealESRGAN('cuda', scale=scale)
    model.load_weights('RealESRGAN_x4plus.pth')  # Scarica il modello da GitHub
    
    # Carica l'immagine
    image = Image.open(image_path).convert("RGB")
    
    # Migliora e ridimensiona l'immagine
    enhanced_image = model.predict(image)
    
    # Salva l'immagine migliorata
    enhanced_image.save(output_path)
    print(f"Immagine salvata in: {output_path}")

# Esempio di utilizzo
image_path = "Reingold_25k_pixel.png"
output_path = "Reingold_25k_pixel_rescale.jpg"

upscale_image_realesrgan(image_path, output_path)
