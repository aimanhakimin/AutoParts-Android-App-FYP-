from bs4 import BeautifulSoup
import cloudscraper
import json

# Set up CloudScraper
scraper = cloudscraper.create_scraper()

baseurl = 'https://www.carousell.com.my'

headers = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
}

# Request the page
url = 'https://www.carousell.com.my/search/axia%20brake%20pad%20disc?addRecent=true&canChangeKeyword=true&includeSuggestions=true&searchId=Lo7TAI&t-search_query_source=direct_search'
response = scraper.get(url, headers=headers)

# Parse the page content
soup = BeautifulSoup(response.content, 'html.parser')

# Find all product elements
productlist = soup.find_all('div', class_='D_vv D_pp')

# List to store product data
products = []

# Loop through each product
for product in productlist:
    # Extract title
    title_element = product.find('p', class_='D_lg M_gV D_lh M_gW D_ll M_ha D_lo M_he D_lr M_hh D_lt M_hj D_lp M_hf D_me')
    title = title_element.text.strip() if title_element else 'N/A'

    # Extract price
    price_element = product.find('p', class_='D_lg', style='color:#2c2c2d')
    price = price_element['title'].strip() if price_element else 'N/A'

    # Extract image link
    image_element = product.find('img', class_='D_mj M_jf D_Pt M_Jh')
    image_link = baseurl + image_element['src'] if image_element else 'N/A'

    # Extract product link (detail page link)
    link_element = product.find('a', class_='D_mh M_gT')
    product_link = baseurl + link_element['href'] if link_element else 'N/A'

    # Append to products list
    products.append({
        'title': title,
        'price': price,
        'imageLink': image_link,
        'productLink': product_link
    })

# Output the data as JSON
print(json.dumps(products))
