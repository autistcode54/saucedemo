# Use Python 3.9 as base image
FROM python:3.9-slim

# Install Chrome and ChromeDriver dependencies
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    unzip \
    xvfb \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

# Set up working directory
WORKDIR /app

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copy test files
COPY . .

# Set display port to avoid crash
ENV DISPLAY=:99

# Create output directory
RUN mkdir -p output

# Command to run tests
CMD ["robot", "--outputdir", "output", "--log", "log.html", "--report", "report.html", "--output", "output.xml", "tests/"]
