FROM python:3.11 as builder
COPY . /app
WORKDIR /app
ENV PATH="/app/venv/bin:$PATH"

#RUN apt-get update && apt-get install -y git
#RUN apt-get update
#RUN apt-get install ffmpeg -y #issue 445

RUN mkdir -p /usr/app
RUN python -m venv ./venv

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

CMD ["streamlit", "run", "streamlit_app.py"]

EXPOSE 80
