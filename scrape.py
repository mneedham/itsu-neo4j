from bs4 import BeautifulSoup
import glob
import json

with open("import/items.json", "w") as items_file:
    for path in glob.glob("raw/*"):
        with open(path, "r") as file:
            print(path)
            soup = BeautifulSoup(file.read(), 'html.parser')
            title = soup.select("h1")[0].text
            allergens = [item.text for item in soup.select("div.allergen-table span")]

            description_element = soup.select("div.m__item-description p")
            description = soup.select("div.m__item-description p")[1].text if len(description_element) > 0 else ""

            url = soup.select("meta[property='og:url']")[0]["content"]

            document = {
                "title": title,
                "allergens": allergens,
                "description": description,
                "url": url
            }

            items_file.write(f"{json.dumps(document)}\n")
