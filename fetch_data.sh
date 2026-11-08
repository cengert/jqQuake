#!/bin/bash

# Exit bei Fehlern
set -e

URL="https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.geojson"
FULL_OUTPUT="earthquake.json"      # Die vollständige Original-Datei
COMPRESSED_OUTPUT="app_data.json"  # Deine schlanke Arbeits-Datei

echo "a) Lade vollständige Erdbebendaten herunter..."
curl -s "$URL" -o "$FULL_OUTPUT"
echo "-> '$FULL_OUTPUT' (vollständig) gespeichert."

echo "b) Komprimiere Daten für die Karte..."
jq '[
    .features[]
    | select(.properties.mag != null)
    | {
        lat: .geometry.coordinates[1],
        lon: .geometry.coordinates[0],
        mag: .properties.mag,
        ort: (.properties.place // "Unbekannter Ort"),
        zeit: ((.properties.time / 1000) | todate | .[0:16] | sub("T"; " "))
      }
]' "$FULL_OUTPUT" > "$COMPRESSED_OUTPUT"

echo "-> '$COMPRESSED_OUTPUT' (komprimiert) erfolgreich erstellt."