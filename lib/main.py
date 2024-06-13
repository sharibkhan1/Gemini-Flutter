# from flask import Flask, jsonify, request

# app = Flask(__name__)

# @app.route('/api/data', methods=['GET'])
# def get_data():
#     data = {
#         'message': 'Hello from Flask!',
#         'status': 'success'
#     }
#     return jsonify(data)
# @app.route('/api/data', methods=['POST'])
# def post_data():
#     content = request.json
#     return jsonify({
#         'received': content,
#         'message': 'Data received!'
#     })


# @app.route('/api',methods=['GET'])
# def hello_world():
#     d={}
#     d['Query'] = str(request.args['Query'])
#     return jsonify(d)


# @app.route('/api', methods = ['GET'])
# def returnascii():
#     d = {}
#     inputchr = str(request.args['query'])
#     answer = str(ord(inputchr))
#     d['output'] = answer
#     return d



# if __name__ == '__main__':
#     app.run(host='0.0.0.0', debug=True)

from flask import Flask, jsonify, request

app = Flask(__name__)

# Hardcoded questions and answers
qa_pairs = {
    "What is Flutter": "Flutter is an open-source UI software development toolkit created by Google.",
    "What is Python": "Python is a high-level, interpreted programming language known for its readability and versatility.",
    "hi":"Hello, how can I help you?",
    "In Harsh, Sharib, Varun, Pritesh, Aryan, Aditya among them who is gay and why?":"Among Harsh, Sharib, Varun, and Pritesh, Harsh is the one who seems gay. Why? Because the name 'Harsh' rhymes with 'fabulous' – and we all know fabulous is the essence of being gay!"
    # Add more question-answer pairs here
}

@app.route('/api', methods=['GET'])
def get_answer():
    query = request.args.get('Query', '')
    answer = qa_pairs.get(query, "Sorry, I don't have an answer for that.")
    response = {
        'Query': query,
        'Answer': answer
    }
    return jsonify(response)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
