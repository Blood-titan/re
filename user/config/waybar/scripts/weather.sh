#!/usr/bin/env bash
# put your key into OPENWEATHER_APIKEY or edit the script
APIKEY="${OPENWEATHER_APIKEY:-a1cb970c8087477db6880939251506}"
CITY="${CITY:-Chennai}"
res=$(curl -s "https://api.openweathermap.org/data/2.5/weather?q=${CITY}&units=metric&appid=${APIKEY}")
if [ -z "$res" ]; then
  echo '{"text":"weather:err"}'
  exit
fi
temp=$(echo "$res" | jq ".main.temp" -r)
weather=$(echo "$res" | jq -r ".weather[0].main")
icon="☀"
case "$weather" in
  Rain*) icon="☂";;
  Clouds*) icon="☁";;
  Clear*) icon="☀";;
  Snow*) icon="❄";;
esac
echo "{\"text\":\"${icon} ${temp%.*}°C\",\"tooltip\":\"${weather}\"}"
