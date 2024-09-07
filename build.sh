#!/bin/bash

# create output directory
if [ -d "./dist" ]; then
  rm -rf "./dist"
fi
mkdir "./dist"

# build & add map
cd "./map"
npm install
npm run build
cp -R ./dist/map/browser/* ../dist
cd ..

# add login
cp -R ./login ./dist

# add api
cp -R ./api ./dist

# add admin
cp -R ./admin ./dist