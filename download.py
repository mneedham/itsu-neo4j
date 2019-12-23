import requests
from bs4 import BeautifulSoup
import os

def download_file(url):
    local_filename = f"raw/{url.strip('/').split('/')[-1]}"
    if not os.path.exists(local_filename):
        with requests.get(url, stream=True) as r:
            r.raise_for_status()
            with open(local_filename, 'wb') as f:
                for chunk in r.iter_content(chunk_size=8192):
                    if chunk:
                        f.write(chunk)
                        # f.flush()
    return local_filename

for category in ["breakfast", "sushi", "asian-salads", "hot", "sides-snacks"]:
    response = requests.get(f"https://www.itsu.com/menu/{category}/")
    soup = BeautifulSoup(response.text, "html.parser")

    for item in soup.select("div.o__menu-items-wrapper div.m__menu-item-wrapper a"):
        download_file(item["href"])
