FROM python:3.13-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app.py index.html ./
# The database lives in /data — attach a persistent disk or volume there.
ENV HOST=0.0.0.0 PORT=8080 DATA_DIR=/data PYTHONUNBUFFERED=1
RUN mkdir -p /data
EXPOSE 8080
CMD ["python", "app.py"]
