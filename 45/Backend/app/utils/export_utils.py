import csv

def export_csv(data, file_path="attendance.csv"):
    with open(file_path, "w", newline="") as f:
        writer = csv.writer(f)
        writer.writerow(["User ID", "Timestamp"])
        writer.writerows(data)

    return file_path