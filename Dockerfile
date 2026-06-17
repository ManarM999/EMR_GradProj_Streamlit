FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Pre-download the Whisper model at build time so it's baked into the image
# and doesn't need to be fetched over the network on every container restart.
# Match this to whichever size you use in _load_whisper() (e.g. "base").
RUN python -c "import whisper; whisper.load_model('base')"

COPY . .

EXPOSE 8080

CMD streamlit run app.py --server.port=$PORT --server.address=0.0.0.0
