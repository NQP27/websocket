FROM python:3.12 

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple --timeout=100 -r requirements.txt


COPY . .

CMD ["python", "main_tradingview.py"]
