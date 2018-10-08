require 'json'
desc "Migrate products data"
task :migrate => :environment do
	file = File.read('products.json')
	data_hash = JSON.parse(file)
	data_hash['products'].each do |data|

		Product.where(name: data['name']).first_or_initialize do |product|
			product.product_type = data['type']
			product.length = data['length']
			product.width = data['width']
			product.height = data['height']
			product.weight = data['weight']

			if product.save
				puts "New product created"
			end
		end

		puts data['name']
		puts data['type']
		puts data['length']
		puts data['width']
		puts data['height']
		puts data['weight']
		puts "--------------------------------"
	end
end