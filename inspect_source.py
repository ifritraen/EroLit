import json
from scrapling import Fetcher

fetcher = Fetcher()

print("=== 2. HOMEPAGE HTML INSPECTION ===")
r_home = fetcher.get("https://www.desikahani2.net/")
print("Home status:", r_home.status)
print("Home title:", r_home.css("title::text").get())

# Check article containers on homepage
articles = r_home.css("article")
print(f"Number of <article> tags: {len(articles)}")
if not articles:
    # Try div containers
    articles = r_home.css(".post, .type-post, .entry")
    print(f"Fallback post tags: {len(articles)}")

if articles:
    first = articles[0]
    print("First article tag/classes:", first.attrib)
    # Check title, link, date, author, thumbnail
    title_el = first.css("h1 a, h2 a, h3 a, .entry-title a")
    print("Title text:", [t.text for t in title_el])
    print("Title href:", [t.attrib.get('href') for t in title_el])
    date_el = first.css("time, .entry-date, .posted-on, .date")
    print("Date text:", [d.text for d in date_el])
    author_el = first.css(".author, .byline, .vcard, [rel='author']")
    print("Author text:", [a.text for a in author_el])
    img_el = first.css("img")
    print("Img src/attributes:", [img.attrib for img in img_el])
    excerpt_el = first.css(".entry-summary, .entry-content, p")
    print("Excerpt text preview:", [p.text[:60] for p in excerpt_el[:2]])

# Check pagination on homepage
pagination = r_home.css(".pagination, .nav-links, .page-numbers, .pagination-previous, .pagination-next")
print("Pagination elements found:", len(pagination))
for p in pagination:
    print("Pagination link hrefs:", [a.attrib.get('href') for a in p.css('a')])
    print("Pagination link texts:", [a.text for a in p.css('a')])

# Check menu / categories in navigation
menu_items = r_home.css(".menu-item a, nav a, .cat-item a")
print(f"Total nav/menu links: {len(menu_items)}")
cats = []
for m in menu_items:
    href = m.attrib.get('href', '')
    text = m.text.strip()
    if '/category/' in href:
        cats.append((text, href))
print(f"Discovered {len(cats)} category links in nav:")
for c in cats[:15]:
    print(" ", c)
