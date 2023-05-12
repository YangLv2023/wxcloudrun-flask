FROM python:3.11 as builder
COPY . /app
WORKDIR /app
ENV PATH="/app/venv/bin:$PATH"

RUN apt-get update && apt-get install -y git
RUN apt-get update
RUN apt-get install ffmpeg -y #issue 445

RUN mkdir -p /usr/app
RUN python -m venv ./venv

COPY requirements.txt .

RUN pip install -r requirements.txt

 RUN pip config set global.index-url  https://mirrors.aliyun.com/pypi/simple/
 RUN pip config set global.trusted-host mirrors.aliyun.com

FROM python:3.11

WORKDIR /app
ENV PATH="/app/venv/bin:$PATH"

COPY --from=builder /app/venv ./venv
COPY . .


# 暴露端口。
# 此处端口必须与「服务设置」-「流水线」以及「手动上传代码包」部署时填写的端口一致，否则会部署失败。
EXPOSE 80

# 执行启动命令
# 写多行独立的CMD命令是错误写法！只有最后一行CMD命令会被执行，之前的都会被忽略，导致业务报错。
# 请参考[Docker官方文档之CMD命令](https://docs.docker.com/engine/reference/builder/#cmd)
CMD ["python3", "aiSay.py", "0.0.0.0", "80"]
