# !/usr/bin/python3
# -*- coding: utf-8 -*-
"""
# @Project : gpt4free
# @Author : pei
# @Time : 2023-05-09 17:13
# @Describe : 
"""
from gptAi.gpt4free import you
from flask import Flask, jsonify, request, redirect, render_template
import gptAi.gpt4free
from gptAi.gpt4free import Provider, quora, forefront
from gptAi.gpt4free import usesless

app = Flask(__name__)
app.config['JSON_AS_ASCII'] = False
app.debug = True
chat = {}
chat_gpt = []
num = 1
message_id = ""


@app.route('/gpt', methods=['POST'])
def gpt():
    global num, chat, message_id
    if request.method == 'POST':
        prompt = request.form.get('content')
        message_id = request.form.get('message_id')
        response = usesless.Completion.create(prompt=prompt, parentMessageId=message_id)
        print(response)
        message_id = response["id"]
        return jsonify({"response": response['text'], "message_id": message_id})


if __name__ == '__main__':
    app.run('0.0.0.0', 5000)
