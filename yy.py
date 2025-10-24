import os

# Directory containing your files
directory = "user/.config/current/theme"

# Loop through each file in the directory
for filename in os.listdir(directory):
    if filename.startswith("omarchy-"):
        new_name = filename.replace("omarchy-", "", 1)
        os.rename(os.path.join(directory, filename),
                  os.path.join(directory, new_name))
        print(f'Renamed: {filename} -> {new_name}')

print("All files renamed successfully!")
