#!/bin/bash

# Run mongo
docker compose up mongo -d

# Run mongo-gui
mongo-gui &

# Run the app
npm run dev