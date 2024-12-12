#!/bin/bash
Xvfb :99 -ac &
export DISPLAY=:99
uvicorn api:app --host 0.0.0.0 --port 8000