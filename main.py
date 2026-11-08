import json
import subprocess
import folium

# ==========================================
# 1. BASH-SKRIPT FÜR DATENBESCHAFFUNG AUFRUFEN
# ==========================================
print("1. Führe Bash-Skript zur Datenaktualisierung aus...")
try:
  subprocess.run(["bash", "fetch_data.sh"], check=True)
except subprocess.CalledProcessError as e:
  print(f"Fehler beim Ausführen des Bash-Skripts: {e}")
  exit(1)


# ==========================================
# 2. KARTE AUS DER FRISCHEN APP_DATA.JSON BAUEN
# ==========================================
print("2. Lade app_data.json und generiere OpenTopoMap...")

with open("app_data.json", "r", encoding="utf-8") as f:
  earthquakes = json.load(f)

# Karte zentrieren mit OpenTopoMap
m = folium.Map(
    location=[39.0, 22.0],
    zoom_start=5,
    tiles="https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png",
    attr=(
        'Map data: &copy; <a'
        ' href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>'
        ' contributors, <a href="http://viewfinderpanoramas.org">SRTM</a> | Map'
        ' style: &copy; <a href="https://opentopomap.org">OpenTopoMap</a> (<a'
        ' href="https://creativecommons.org/licenses/by-sa/3.0/">CC-BY-SA</a>)'
    ),
)

# Über alle Erdbeben iterieren und Marker setzen
for eq in earthquakes:
  radius = max(float(eq["mag"]) * 2, 3)

  # Popup um das Datum/Uhrzeit erweitert
  popup_text = (
      f"<b>{eq['ort']}</b><br>Magnitude: {eq['mag']}<br>Zeit: {eq['zeit']} UTC"
  )

  folium.CircleMarker(
      location=[eq["lat"], eq["lon"]],
      radius=radius,
      popup=popup_text,
      color="crimson",
      fill=True,
      fill_color="crimson",
      fill_opacity=0.6,
  ).add_to(m)

# Als HTML-Datei speichern
m.save("earthquake_map.html")
print(
    "Fertig! 'earthquake_map.html' wurde aktualisiert. Bitte öffnen Sie die Datei in einem Webbrowser, um die Karte anzuzeigen."
)