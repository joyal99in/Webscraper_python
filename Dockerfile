# Use a base image with Python
FROM python:3.9

# Set working directory inside the container
WORKDIR /app

# Install required dependencies
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    curl \
    gnupg

# Install Google Chrome
RUN wget -q -O google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    dpkg -i google-chrome.deb || apt-get -fy install && \
    rm google-chrome.deb && \
    google-chrome --version

# Get the correct ChromeDriver version and install it
RUN CHROME_VERSION=$(google-chrome --version | grep -oP '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+') && \
    echo "Detected Chrome version: $CHROME_VERSION" && \
    CHROMEDRIVER_VERSION=$(curl -sS "https://chromedriver.storage.googleapis.com/LATEST_RELEASE") && \
    echo "Downloading ChromeDriver version: $CHROMEDRIVER_VERSION" && \
    wget -q "https://chromedriver.storage.googleapis.com/${CHROMEDRIVER_VERSION}/chromedriver_linux64.zip" -O chromedriver_linux64.zip && \
    unzip chromedriver_linux64.zip && \
    mv chromedriver /usr/local/bin/chromedriver && \
    chmod +x /usr/local/bin/chromedriver && \
    rm -rf chromedriver_linux64.zip

# Install required Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . .

# Set the default command to run the application
CMD ["streamlit", "run", "app.py"]
