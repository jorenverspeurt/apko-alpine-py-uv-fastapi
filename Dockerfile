FROM alpine-python-uv:test-amd64 as python-builder
WORKDIR /app
COPY requirements.txt .
RUN uv venv
RUN source ./.venv/bin/activate
RUN uv pip install -r requirements.txt

FROM alpine-python-uv:test-amd64
WORKDIR /app
COPY --from=python-builder /app/.venv /app/.venv
ENV PATH="/app/.venv/bin:$PATH"
COPY main.py .
ENTRYPOINT [ "uvicorn", "main:app", "--host", "0.0.0.0", "--port", "80" ]
