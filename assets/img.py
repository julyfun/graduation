import os
import cv2
import numpy as np
from pathlib import Path

def crop_images_by_percentage(input_dir, output_dir, start_percent, end_percent, 
                             brightness_factor=1.3, contrast_factor=1.2, 
                             saturation_factor=1.2, sharpen=False, sharpen_strength=0.5,
                             gamma=1.0, smooth_skin=True, smooth_strength=0.7):
    """
    Crops all images in input_dir from start_percent to end_percent of height, 
    enhances the image with multiple parameters, and saves them to output_dir.
    
    Args:
        input_dir: Directory containing images to crop
        output_dir: Directory to save cropped images
        start_percent: Starting height percentage for cropping (0-100)
        end_percent: Ending height percentage for cropping (0-100)
        brightness_factor: Factor to increase brightness (>1 brightens, <1 darkens)
        contrast_factor: Factor to adjust contrast (>1 increases contrast, <1 decreases)
        saturation_factor: Factor to adjust color saturation (>1 increases, <1 decreases)
        sharpen: Whether to apply sharpening filter
        sharpen_strength: Strength of sharpening effect (0.0-1.0)
        gamma: Gamma correction value (>1 brightens shadows, <1 darkens midtones)
        smooth_skin: Whether to apply skin smoothing
        smooth_strength: Strength of skin smoothing (0.0-1.0)
    """
    # Create output directory if it doesn't exist
    os.makedirs(output_dir, exist_ok=True)
    
    # Get all image files in the input directory
    image_extensions = ['.jpg', '.jpeg', '.png', '.bmp', '.tiff', '.gif']
    image_files = []
    
    for ext in image_extensions:
        image_files.extend(list(Path(input_dir).glob(f'*{ext}')))
        image_files.extend(list(Path(input_dir).glob(f'*{ext.upper()}')))
    
    if not image_files:
        print(f"No image files found in {input_dir}")
        return
    
    print(f"Found {len(image_files)} images to process...")
    
    # Process each image
    for img_path in image_files:
        try:
            # Read the image
            img = cv2.imread(str(img_path))
            if img is None:
                print(f"Failed to read {img_path}")
                continue
            
            # Get image dimensions
            height, width = img.shape[:2]
            
            # Calculate crop coordinates
            start_y = int(height * (start_percent / 100))
            end_y = int(height * (end_percent / 100))
            
            # Crop the image
            cropped_img = img[start_y:end_y, 0:width]
            
            # Apply skin smoothing (bilateral filter preserves edges while smoothing)
            if smooth_skin:
                # Calculate filter parameters based on smooth_strength
                d = int(9 * smooth_strength)  # Filter size
                sigma_color = 75 * smooth_strength  # Color sigma
                sigma_space = 75 * smooth_strength  # Space sigma
                
                # Apply bilateral filter
                cropped_img = cv2.bilateralFilter(cropped_img, d, sigma_color, sigma_space)
            
            # Apply gamma correction
            if gamma != 1.0:
                inv_gamma = 1.0 / gamma
                table = np.array([((i / 255.0) ** inv_gamma) * 255 for i in range(256)]).astype("uint8")
                cropped_img = cv2.LUT(cropped_img, table)
            
            # Increase brightness and contrast
            enhanced_img = cv2.convertScaleAbs(cropped_img, alpha=brightness_factor, beta=0)
            
            # Adjust contrast
            if contrast_factor != 1.0:
                mean = np.mean(enhanced_img)
                enhanced_img = cv2.convertScaleAbs(enhanced_img, alpha=contrast_factor, beta=(1.0 - contrast_factor) * mean)
            
            # Convert to HSV to adjust saturation
            if saturation_factor != 1.0:
                hsv = cv2.cvtColor(enhanced_img, cv2.COLOR_BGR2HSV)
                hsv = hsv.astype('float32')
                hsv[:,:,1] = hsv[:,:,1] * saturation_factor
                hsv[:,:,1] = np.clip(hsv[:,:,1], 0, 255)
                hsv = hsv.astype('uint8')
                enhanced_img = cv2.cvtColor(hsv, cv2.COLOR_HSV2BGR)
            
            # Apply sharpening filter with adjustable strength
            if sharpen:
                # Create a custom kernel with adjustable strength
                strength = sharpen_strength * 8
                kernel = np.array([[-1, -1, -1],
                                  [-1, 9 + strength, -1],
                                  [-1, -1, -1]]) / (1 + strength)
                enhanced_img = cv2.filter2D(enhanced_img, -1, kernel)
            
            # Save the enhanced image
            output_path = os.path.join(output_dir, img_path.name)
            cv2.imwrite(output_path, enhanced_img)
            print(f"Processed: {img_path.name}")
            
        except Exception as e:
            print(f"Error processing {img_path}: {str(e)}")
    
    print("Processing complete!")

if __name__ == "__main__":
    input_directory = "img1"  # Change this to the path of your input directory if needed
    output_directory = "img1_cropped"  # Change this to your desired output directory
    start_percent = 33  # Starting percentage of height to crop from
    end_percent = 83  # Ending percentage of height to crop to
    
    # Image enhancement parameters
    brightness_factor = 1.3  # Increase brightness by 30%
    contrast_factor = 1.1    # Slight contrast increase (reduced from 1.2)
    saturation_factor = 1.1  # Slight saturation increase (reduced from 1.2)
    sharpen = False          # Disable sharpening by default
    sharpen_strength = 0.3   # Lower sharpening strength when enabled
    gamma = 1.1              # Slight gamma correction (reduced from 1.2)
    smooth_skin = True       # Enable skin smoothing
    smooth_strength = 0.7    # Medium-high smoothing strength
    
    crop_images_by_percentage(
        input_directory, output_directory, 
        start_percent, end_percent, 
        brightness_factor, contrast_factor,
        saturation_factor, sharpen, sharpen_strength,
        gamma, smooth_skin, smooth_strength
    )