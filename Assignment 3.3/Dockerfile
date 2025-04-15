# Using latest base image from DockerHub
FROM python:latest

# Creating working directory inside container
WORKDIR /app

# Copy source code into working directory
COPY . /app

# Install flask inside container
RUN pip install -r requirements.txt

# Expose container port
EXPOSE 8080

# Start flask app
CMD ["python", "app.py"]
