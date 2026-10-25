# Dhana Laxmi Bridal & Festive Crafts – Storefront

Live site: https://kalyanavaibhogam.netlify.app

Static website (HTML + CSS + JS, no build step) hosted on Netlify and auto-deployed from this GitHub repo.

## How it is organised

| Path | What it is |
|---|---|
| `index.html` | The whole page – design, layout and shop logic |
| `products.json` | **The product catalog.** Every product card on the site comes from this file |
| `assets/products/` | Product photos used by `products.json` |
| `assets/images/` | Original WhatsApp photos (source images) |
| `netlify.toml` | Netlify settings |

## Adding or changing a product

Edit `products.json` (or let the n8n automation do it) and commit. Netlify republishes the site in about a minute.

Each product looks like this:

```json
{
  "id": "royal_brass_thali",
  "title": "Royal Brass Aarti Thali",
  "category": "thalis",
  "categoryName": "Aarti Thalis & Platters",
  "price": 1250,
  "priceNote": "complete thali & kalash",
  "badge": "Bestseller",
  "description": "Short description shown on the card.",
  "occasion": ["Wedding", "Pooja"],
  "images": [
    { "color": "Royal Brass & Pearls", "url": "assets/products/item_8.jpeg", "thumb": "#D4AF37" }
  ],
  "inStock": true
}
```

- `id` must be unique, lowercase, with underscores.
- `category` must match one of the filter buttons on the site (pots, floral, garlands, thalis, chowki, accessories, boxes).
- Each entry in `images` is one colour option; the first one is shown by default.

## Run locally

Right-click `start-server.ps1` → **Run with PowerShell**, then open http://localhost:8080.
(Opening `index.html` by double-click will not load products, because browsers block reading `products.json` from disk.)
