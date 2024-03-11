#!/bin/bash

# Run mongo
docker compose up mongo -d

# Run mongo-gui
concurrently "mongo-gui" "npm run dev" "open http://localhost:3000/api-docs" "open http://localhost:4321"