"""Minimal LSP peer that records process starts without running any Ruby code."""
import json
import os
from pathlib import Path
import sys

with Path(os.environ["RUBY_LSP_START_LOG"]).open("a") as log:
    log.write(str(Path.cwd()) + "\n")

while True:
    headers = {}
    while True:
        line = sys.stdin.buffer.readline()
        if not line:
            sys.exit(0)
        if line in (b"\r\n", b"\n"):
            break
        key, value = line.decode().split(":", 1)
        headers[key.lower()] = value.strip()
    message = json.loads(sys.stdin.buffer.read(int(headers["content-length"])))
    if message.get("method") == "exit":
        break
    if "id" not in message:
        continue
    result = {"capabilities": {"completionProvider": {}}} if message.get("method") == "initialize" else None
    data = json.dumps({"jsonrpc": "2.0", "id": message["id"], "result": result}).encode()
    sys.stdout.buffer.write(f"Content-Length: {len(data)}\r\n\r\n".encode() + data)
    sys.stdout.buffer.flush()
