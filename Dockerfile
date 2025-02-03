FROM python:3.9-slim

# System dependencies
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    unzip \
    fonts-liberation \
    libgl1 \
    libx11-6 \
    libxcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxi6 \
    libxrandr2 \
    libxrender1 \
    libxss1 \
    libxtst6 \
    xdg-utils

# Install Chrome 132.x
RUN wget -q https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_132.0.6834.160-1_amd64.deb \
    && apt-get install -y ./google-chrome-stable_132.0.6834.160-1_amd64.deb \
    && rm google-chrome-stable_*.deb \
    && apt-get clean

# Install matching Chromedriver 132.0.6834.160
RUN wget -q https://chromedriver.storage.googleapis.com/132.0.6834.160/chromedriver_linux64.zip \
    && unzip chromedriver_linux64.zip \
    && mv chromedriver /usr/bin/chromedriver \
    && chmod +x /usr/bin/chromedriver \
    && rm chromedriver_linux64.zip

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["streamlit", "run", "app.py"]