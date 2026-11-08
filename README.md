# jqQuake 🌋📊

> **From Raw JSON to an Interactive Map** – A live, terminal-based presentation showing how to tame messy GeoJSON data with `jq` and turn it into an interactive map using Python.

---

## 💡 About the Project

`jqQuake` is a live-demo presentation designed for stage performance and instructional walkthroughs. It demonstrates how to transform raw seismic data from the USGS (U.S. Geological Survey) API into a clean, reduced structure using `jq`, which is then rendered on an interactive map using Python and Folium.

*Background:* This tool and presentation were developed as part of the **System-Oriented Programming** course to concisely demonstrate and present a powerful CLI tool in action.

### ⚡ Note on Craftsmanship
> **Built with Vibe-Coding:**  
> This project was proudly vibe-coded with AI assistance. It was developed to maximize stage impact, clear learning, and smooth terminal vibes—letting the creator focus on storytelling, flow, and concepts while leveraging AI for rapid iteration. The learning effect of tackling tools like `jq` project-based in high speed was a fantastic bonus!

---

## 🛠️ Project Structure

- `presentation.sh` — The main Bash presentation script with built-in pauses, visual color highlights, and step-by-step explanations.
- `fetch_data.sh` — Helper script that handles the live `curl` data retrieval and `jq` data transformation.
- `main.py` — Python script that triggers the data routine, builds the Folium map, and generates `earthquake_map.html` from `app_data.json`.
- `earthquake.json` — *(Generated live)* Raw GeoJSON feed from the USGS API.
- `app_data.json` — *(Generated live)* Compressed and structured JSON feed produced by `jq`.
- `earthquake_map.html` — *(Generated live)* Interactive Folium HTML map.

---

## 🚀 Quick Start

### 1. Prerequisites
Ensure you have the following installed on your system:
- `bash`
- `curl`
- `jq`
- `nano` (or any other text editor used during the inspection step)
- `python3` (with `folium` installed: `pip install folium`)
- `firefox` (or adjust the browser executable in `presentation.sh`)

### 2. Run the Presentation
Make the presentation script executable and launch it:

```bash
chmod +x presentation.sh
./presentation.sh
```

Follow the on-screen prompts and press **Enter** to step through the live demonstration.

---

## 📜 Workflow Overview

1. **Setup & Inspection:** Check environment and inspect raw JSON with `nano`.
2. **Structural Exploration:** Access metadata header and inspect array elements with `jq`.
3. **Filtering & Aggregation:** Filter high-magnitude events, count event types, apply regex matching, and combine logical conditions (`select`, `group_by`, `map`, `test`).
4. **Master Transformation:** Compress raw millisecond timestamps, clean missing values (`//`), and map coordinates into `app_data.json`.
5. **Visualization:** Run `main.py` to compile the map and open `earthquake_map.html` in Firefox.

---

## ⚖️ License & Data Attribution

- **Code:** Licensed under the [MIT License](LICENSE).
- **Data Source:** Earthquake data provided by the [U.S. Geological Survey (USGS)](https://earthquake.usgs.gov/). USGS data is in the Public Domain.