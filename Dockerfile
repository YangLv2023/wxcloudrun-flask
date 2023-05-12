FROM python:3.11 as builder
COPY . /app
WORKDIR /app
ENV PATH="/app/venv/bin:$PATH"

#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tencent.com/g' /etc/apk/repositories
RUN sed -i s/archive.ubuntu.com/mirrors.aliyun.com/g /etc/apt/sources.list
RUN sed -i s/security.ubuntu.com/mirrors.aliyun.com/g /etc/apt/sources.list


RUN apt-get install ca-certificates
RUN apt-get update && apt-get install -y git



#RUN apt-get install ffmpeg -y #issue 445






RUN mkdir -p /usr/app
RUN python -m venv ./venv
RUN pip install --upgrade pip
COPY requirements.txt .

RUN pip install -r requirements.txt

# RUN pip config set global.index-url  https://mirrors.aliyun.com/pypi/simple/
# RUN pip config set global.trusted-host mirrors.aliyun.com

FROM python:3.11

WORKDIR /app
ENV PATH="/app/venv/bin:$PATH"

COPY --from=builder /app/venv ./venv
COPY . .

#RUN cp ./gui/streamlit_app.py .

#CMD ["streamlit", "run", "streamlit_app.py"]
CMD ["python3", "aiSay.py", "0.0.0.0", "80"]

EXPOSE 80
