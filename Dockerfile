FROM python:3.8-slim-buster
WORKDIR /app
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
COPY requirements.txt .
COPY . .
RUN pip install -r requirements.txt
EXPOSE 8000
ENTRYPOINT sh entrypoint.sh
