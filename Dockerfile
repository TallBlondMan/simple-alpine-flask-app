FROM alpine:3.18.2

# Add Python dependencies and Flask
RUN apk update && apk add python3 py3-pip \
	&& pip install flask

# Copy source-code
COPY . /flask_app/

# Expose app port
EXPOSE 8080

# Run the thing
ENTRYPOINT flask --app /flask_app/app.py run --host=0.0.0.0 --port=8080
