import os

from flask_cors import CORS
from keras.models import load_model
from flask import Flask, jsonify, request
import base64
import io
from keras.utils.image_utils import img_to_array
import numpy as np

import time
from keras.utils.image_utils import save_img
import tensorflow as tf
from PIL import Image
from flask_restful import Resource, Api, reqparse
import cv2

app = Flask(__name__)
api = Api(app)
CORS(app)

model = load_model('10000epochs.h5')
print('* Model Loaded')

def prepare_image(image, target):
    if image.mode != "RGB":
        image = image.convert("RGB")

    image = image.resize(target)
    image = img_to_array(image)

    image = (image - 127.5) / 127.5
    image = np.expand_dims(image, axis=0)
    return image


class Predict(Resource):
    def post(self):
        json_data = request.get_json()
        img_data = json_data['Image']


        image = base64.b64decode(str(img_data))
        save_folder = "./output/"
        # Save the image to the folder
        with open(os.path.join(save_folder, 'sketch.png'), 'wb') as f:
            f.write(image)
        img = Image.open(io.BytesIO(image))
        prepared_image = prepare_image(img, target=(256, 256))
        preds = model.predict(prepared_image)
        outputfile = 'output.png'
        savepath = "./output/"
        output = tf.reshape(preds, [256, 256, 3])
        output = (output + 1) / 2
        save_img(savepath + outputfile, img_to_array(output))
        imagenew = Image.open(savepath + outputfile)
        imagenew = imagenew.resize((50, 50))
        imagenew.save(savepath + "new_" + outputfile)
        with open(savepath + outputfile, "rb") as image_file:
            encoded_string = base64.b64encode(image_file.read())
        outputdata = {
            "Image": str(encoded_string),
        }

        return outputdata

class Sketchify(Resource):
    def post(self):
        try:
            json_data = request.get_json()
            if 'Image' not in json_data:
                return {"error": "Missing 'Image' key in request"}, 400

            img_data = base64.b64decode(json_data['Image'])
            img = Image.open(io.BytesIO(img_data)).convert('RGB')
            img = img.resize((256, 256))
            img_np = np.array(img)

            gray = cv2.cvtColor(img_np, cv2.COLOR_RGB2GRAY)
            edges = cv2.Canny(gray, 120, 150)

            generate_for_model = json_data.get('generate_for_model', False)

            if generate_for_model:
                result_img = Image.fromarray(edges)
            else:
                inverted = cv2.bitwise_not(edges)
                result_img = Image.fromarray(inverted)

            # Convert to base64
            buffered = io.BytesIO()
            result_img.save(buffered, format="PNG")
            encoded_img = base64.b64encode(buffered.getvalue()).decode("utf-8")

            return {"Image": encoded_img}

        except Exception as e:
            return {"error": str(e)}, 500


api.add_resource(Predict, '/predict')
api.add_resource(Sketchify, '/sketchify')

if __name__ == '__main__':
    app.run(debug=True, port=4000, host='0.0.0.0')

