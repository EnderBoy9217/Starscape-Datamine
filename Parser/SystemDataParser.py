import json
import os

# Prompt user for folder path
folder_path = input("Enter the folder path containing the JSON files: ").strip()

# File paths
data_path = os.path.join(folder_path, "system_data.json")
links_path = os.path.join(folder_path, "system_links.json")
output_path = os.path.join(folder_path, "system_data_complete.json")

# Load system_data.json
try:
    with open(data_path, "r") as f:
        system_data = json.load(f)
    if not isinstance(system_data, dict):
        raise ValueError("system_data.json is not a dictionary.")
except Exception as e:
    print(f"❌ Error loading system_data.json: {e}")
    exit(1)

# Load system_links.json
try:
    with open(links_path, "r") as f:
        system_links = json.load(f)
    if not isinstance(system_links, dict):
        raise ValueError("system_links.json is not a dictionary.")
except Exception as e:
    print(f"❌ Error loading system_links.json: {e}")
    exit(1)

# Normalize connections: ensure they're bidirectional
original_keys = list(system_links.keys())

for id1 in original_keys:
    connections = system_links[id1].get("connections", [])
    for id2 in connections:
        if id2 not in system_links:
            system_links[id2] = {"connections": []}
        if id1 not in system_links[id2]["connections"]:
            system_links[id2]["connections"].append(id1)

# Map identifiers to system names
identifier_to_name = {
    data["Identifier"]: name
    for name, data in system_data.items()
}

# Combine data with Connections
merged_data = {}

for system_name, data in system_data.items():
    identifier = data.get("Identifier")
    connections = []

    if identifier in system_links:
        for conn_id in system_links[identifier]["connections"]:
            connected_name = identifier_to_name.get(conn_id)
            if connected_name:
                connections.append(connected_name)

    # Copy data and add connections
    merged_data[system_name] = dict(data)
    merged_data[system_name]["Connections"] = connections

# Save output
try:
    with open(output_path, "w") as f:
        json.dump(merged_data, f, indent=4)
    print(f"\n✅ system_data_complete.json created at:\n{output_path}")
except Exception as e:
    print(f"❌ Error writing output file: {e}")