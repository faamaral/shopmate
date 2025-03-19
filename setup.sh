#!/bin/bash

echo "Digite a BASE_URL:"
read url

echo "Digite a API_KEY:"
read api_key

touch .env
echo "BASE_URL=$url" >> .env
echo "API_KEY=$api_key" >> .env