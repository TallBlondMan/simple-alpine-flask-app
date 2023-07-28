FROM alpine:3.18.2

# Add Python dependencies and Flask
RUN apk update && apk add python3 py3-pip


# Copy source-code
WORKDIR /flask_app
COPY . .

# Instaling dependencies
RUN pip install -r requirements.txt

# Expose app port
EXPOSE 8080

# Run the thing
ENTRYPOINT ["flask",  "--app app.py", "run", "--host=0.0.0.0", "--port=8080"]