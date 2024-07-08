from flask import Flask, request, jsonify
import google.generativeai as genai
import PIL.Image
import os
from dotenv import load_dotenv
import constants

app = Flask(__name__)

@app.route("/generateJSON",methods=['POST'])
def generateJSON():
  image_file = request.files['bill']
  image_path = "bill.jpg"
  image_file.save(image_path)
  img = PIL.Image.open(image_path)
  genai.configure(api_key=os.getenv("GOOGLE_GEMINI_API"))
  model = genai.GenerativeModel(model_name="gemini-1.5-flash")
  response = model.generate_content(["Provide me the json representation of the given bill receipt. If the given image does not have a bill receipt in that edge case alone output 'Sorry i can't find a bill receipt in the image!'. Else only give the json representation of the bill. Include only key informations. dont print '''json at beginning and '''at end. !!!Note: You must provide an appropriate title for the file name that must be relevant to the bill. You must specify the file name at the very beginning of the response which must be enclosed within #. Example: #sample.json# if no bill detected make fileName as #Invalid#",img])

  output = response.text
  i = 0
  while (output[i] != '#'):
    i += 1
  i += 1
  title = ""
  while (output[i] != '#'):
    title += output[i]
    i += 1
  length = len(output)



  return jsonify({"Response":response.text[i+1:length],"Title":title})

if __name__ == "__main__":
  app.run(host='0.0.0.0', port=5000, debug=True)