require 'csv'
require 'faker'

# Path to the CSV file
csv_file_path = 'public/ikea2.csv'

# Path to the images directory
images_directory = 'public/img'

# Read the image files from each category folder
image_files = {}
Dir.glob("#{images_directory}/*").each do |category_folder|
  next unless File.directory?(category_folder)

  category_name = File.basename(category_folder)
  images = Dir.glob("#{category_folder}/*").select do |image_file|
    File.size(image_file) >= 3 * 1024 # Only include images with size >= 3 KB
  end
  image_files[category_name] = images.shuffle # Shuffle to handle any file naming order
end

# Read the CSV file and iterate through rows
product_count = 0
CSV.foreach(csv_file_path, headers: true) do |row|
  # Create or find the category
  category = Category.find_or_create_by(name: row['category'])

  # Create or find the designer
  designer = Designer.find_or_create_by(name: row['designer'])

  # Assign an image if available for the category
  category_images = image_files[category.name.downcase] || []
  image_path = category_images.sample # Randomly pick an image

  # Create the product and associate it with the category and designer
  Product.create!(
    name: row['name'],
    short_description: row['short_description'],
    description: row['product_description'],
    image_path: image_path.present? ? image_path.gsub('public/', '') : nil, # Save relative path
    price: row['price'],
    depth: row['depth'],
    height: row['height'],
    width: row['width'],
    stock_quantity: Faker::Number.between(from: 10, to: 500), # Random stock quantity
    category: category,
    designer: designer
  )

  # Increment the product count
  product_count += 1

  # Log progress every 50 products
  if (product_count % 50).zero?
    puts "#{product_count} products added so far..."
  end
end

# Final log message
puts "Seeding complete! Total products added: #{product_count}"

# Create an admin user if in development mode
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

Page.find_or_create_by(title: "Contact") do |page|
  page.content = "This is the Contact page content. Update it in ActiveAdmin."
end

Page.find_or_create_by(title: "About") do |page|
  page.content = "This is the About page content. Update it in ActiveAdmin."
end
