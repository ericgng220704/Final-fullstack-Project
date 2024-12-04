require 'csv'
require 'faker'
require 'open-uri'

# Path to the CSV file
csv_file_path = 'public/ikea2.csv'

# Path to the images directory (only for image names)
images_directory = 'public/img'

# Your S3 bucket details
s3_base_url = "https://railfinalprojectstorage.s3.us-east-2.amazonaws.com/img"

# Read the image files from each category folder
image_files = {}
Dir.glob("#{images_directory}/*").each do |category_folder|
  next unless File.directory?(category_folder)

  category_name = File.basename(category_folder)
  images = Dir.glob("#{category_folder}/*").select do |image_file|
    File.size(image_file) >= 3 * 1024 # Only include images with size >= 3 KB
  end
  image_files[category_name] = images.map { |path| File.basename(path) }.shuffle # Only store file names
end

# Read the CSV file and iterate through rows
product_count = 0
CSV.foreach(csv_file_path, headers: true) do |row|
  # Create or find the category
  category = Category.find_or_create_by(name: row['category'])

  # Create or find the designer
  designer = Designer.find_or_create_by(name: row['designer'])

  # Determine matching image folder by checking if the folder name is included in the category name
  selected_image_name = nil
  selected_folder_name = nil
  image_files.each do |folder_name, images|
    if category.name.downcase.include?(folder_name.downcase)
      selected_image_name = images.sample
      selected_folder_name = folder_name
      break if selected_image_name # Stop as soon as a match is found
    end
  end

  # Construct the S3 URL
  s3_image_url = selected_image_name.present? ? "#{s3_base_url}/#{selected_folder_name}/#{selected_image_name}" : nil
  puts "#{s3_image_url}"

  # Create the product and associate it with the category and designer
  product = Product.create!(
    name: row['name'],
    short_description: row['short_description'],
    description: row['product_description'],
    price: row['price'],
    depth: row['depth'],
    height: row['height'],
    width: row['width'],
    stock_quantity: Faker::Number.between(from: 10, to: 500), # Random stock quantity
    category: category,
    designer: designer
  )

  # Attach the image from S3
  if s3_image_url.present?
    begin
      product.image.attach(
        io: URI.open(s3_image_url),
        filename: selected_image_name,
        content_type: "image/jpeg" # Adjust based on your image type
      )
      puts "Attached image #{selected_image_name} to product: #{product.name}"
    rescue OpenURI::HTTPError => e
      puts "Failed to attach image for product: #{product.name}. Error: #{e.message}"
    end
  else
    puts "No matching image found for product: #{product.name}"
  end

  # Increment the product count
  product_count += 1

  # Log progress every 50 products
  puts "#{product_count} products added so far..." if (product_count % 50).zero?
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
