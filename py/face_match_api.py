from flask import Flask, request, jsonify
from PIL import Image
import numpy as np
import face_recognition
import base64

app = Flask(__name__)
app.config["DEBUG"] = True


@app.route('/', methods=['GET'])
def home():
    return "<h1>QID Selfie Match</h1><p>QID Selfie Match API. use /runMatch POST method</p>"

@app.route('/runMatch', methods=['POST'])
def runMatch():
    j = request.get_json(force=True)
    imgstring = j['qid-image']
    imgdata = base64.b64decode(imgstring)
    filename = 'qid.jpg'
    with open(filename, 'wb') as f:
        f.write(imgdata)
    
    imgstring = j['selfie-image']
    imgdata = base64.b64decode(imgstring)
    filename = 'selfie.jpg'
    with open(filename, 'wb') as f:
        f.write(imgdata)
    
    match_output = runMatchAlgorithm()[0]
    
    status = "NO"

    if match_output:
        status = "YES"

    return status

def runMatchAlgorithm():

    known_image = face_recognition.load_image_file("id.jpg")
    unknown_image = face_recognition.load_image_file("selfie.jpg")

    try:
        known_encoding = face_recognition.face_encodings(known_image)
        unknown_encoding = face_recognition.face_encodings(unknown_image)

        if not known_encoding or not unknown_encoding:
            print("face_encoding exception")
            return [False]
        else:
            results = face_recognition.compare_faces([known_encoding[0]], unknown_encoding[0])
            return results
    except ValueError:
        print("exception")
        return [False]

def crop_face_from_image(img, new_file_name):
    source_image = face_recognition.load_image_file(img)
    face_locations = face_recognition.face_locations(source_image, number_of_times_to_upsample=0, model="cnn")
    for face_location in face_locations:
        top, right, bottom, left = face_location
        # print("A face is located at pixel location Top: {}, Left: {}, Bottom: {}, Right: {}".format(top, left, bottom, right))

        face_image = source_image[top:bottom, left:right]
        pil_image = Image.fromarray(face_image)
        pil_image.save(new_file_name)
        pass
    pass

app.run(host='0.0.0.0', port=8080)
