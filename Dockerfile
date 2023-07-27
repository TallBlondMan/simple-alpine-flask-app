FROM alpine

# Add Python dependencies
RUN apk update && apk add python3 py3-pip 

# Install Flask server
RUN pip install flask 

# Copy source-code
COPY app.py /flask_app/app.py
COPY templates/index.html /flask_app/templates/index.html

# Expose app port
EXPOSE 8080

# Run the thing
ENTRYPOINT flask --app /flask_app/app.py run --host=0.0.0.0 --port=8080
