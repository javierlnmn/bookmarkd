# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

def seed_user(email_address)
  User.find_or_create_by!(email_address: email_address) do |user|
    user.password = "1234"
  end
end

def seed_folder(user, name, parent: nil, is_public: false, description: nil)
  Folder.find_or_create_by!(name: name, parent: parent, user: user) do |folder|
    folder.is_public = is_public
    folder.description = description
  end
end

def seed_bookmark(user, name, url, folder: nil, description: nil)
  Bookmark.find_or_create_by!(name: name, url: url, user: user, folder: folder) do |bookmark|
    bookmark.description = description
  end
end

def seed_collaboration(folder, user)
  FolderCollaboration.find_or_create_by!(folder: folder, user: user)
end

alice = seed_user("alice@example.com")
bob   = seed_user("bob@example.com")
carol = seed_user("carol@example.com")
dave  = seed_user("dave@example.com")

# --- Alice ---------------------------------------------------------------

alice_reading_list = seed_folder(alice, "Reading List", is_public: true, description: "Stuff I want to read")
alice_tech = seed_folder(alice, "Tech", parent: alice_reading_list, description: "Engineering articles")
alice_fiction = seed_folder(alice, "Fiction", parent: alice_reading_list, is_public: true, description: "Books and short stories")

seed_bookmark(alice, "Hacker News", "https://news.ycombinator.com", folder: alice_tech)
seed_bookmark(alice, "Rails Guides", "https://guides.rubyonrails.org", folder: alice_tech)
seed_bookmark(alice, "Goodreads", "https://www.goodreads.com", folder: alice_fiction)
seed_bookmark(alice, "r/Fantasy", "https://www.reddit.com/r/Fantasy", folder: alice_fiction)

alice_personal = seed_folder(alice, "Personal", description: "Private stuff")
alice_recipes = seed_folder(alice, "Recipes", parent: alice_personal)

seed_bookmark(alice, "Serious Eats", "https://www.seriouseats.com", folder: alice_recipes)
seed_bookmark(alice, "Bon Appetit", "https://www.bonappetit.com", folder: alice_recipes)

seed_bookmark(alice, "Google", "https://www.google.com")

# --- Bob ------------------------------------------------------------------

bob_work = seed_folder(bob, "Work Projects", description: "Client work")
bob_frontend = seed_folder(bob, "Frontend", parent: bob_work)
bob_backend = seed_folder(bob, "Backend", parent: bob_work)

seed_bookmark(bob, "MDN Web Docs", "https://developer.mozilla.org", folder: bob_frontend)
seed_bookmark(bob, "CSS-Tricks", "https://css-tricks.com", folder: bob_frontend)
seed_bookmark(bob, "Rails API", "https://api.rubyonrails.org", folder: bob_backend)
seed_bookmark(bob, "PostgreSQL Docs", "https://www.postgresql.org/docs", folder: bob_backend)

bob_public_links = seed_folder(bob, "Public Links", is_public: true, description: "Things worth sharing")

seed_bookmark(bob, "Product Hunt", "https://www.producthunt.com", folder: bob_public_links)
seed_bookmark(bob, "GitHub Trending", "https://github.com/trending", folder: bob_public_links)

seed_bookmark(bob, "Bing", "https://www.bing.com")

# --- Carol ------------------------------------------------------------------

carol_design = seed_folder(carol, "Design Inspiration", is_public: true, description: "Visual references")
carol_typography = seed_folder(carol, "Typography", parent: carol_design, is_public: true)
carol_colors = seed_folder(carol, "Color Palettes", parent: carol_design)

seed_bookmark(carol, "Fonts In Use", "https://fontsinuse.com", folder: carol_typography)
seed_bookmark(carol, "Typewolf", "https://www.typewolf.com", folder: carol_typography)
seed_bookmark(carol, "Coolors", "https://coolors.co", folder: carol_colors)
seed_bookmark(carol, "Adobe Color", "https://color.adobe.com", folder: carol_colors)

seed_bookmark(carol, "Behance", "https://www.behance.net")

# --- Dave -------------------------------------------------------------------

dave_vault = seed_folder(dave, "Dave's Vault", description: "Nobody else can see this")
dave_secrets = seed_folder(dave, "Secrets", parent: dave_vault)

seed_bookmark(dave, "Have I Been Pwned", "https://haveibeenpwned.com", folder: dave_secrets)

seed_bookmark(dave, "DuckDuckGo", "https://duckduckgo.com")

# --- Collaborations ----------------------------------------------------------
# Carol collaborates on Alice's whole "Reading List" tree (Tech + Fiction included via cascade).
seed_collaboration(alice_reading_list, carol)

# Bob collaborates only on Alice's "Tech" folder, not the rest of her tree.
seed_collaboration(alice_tech, bob)

# Alice collaborates on Bob's "Frontend" folder.
seed_collaboration(bob_frontend, alice)

# Dave stays fully isolated: no collaborations granted to or by him.
