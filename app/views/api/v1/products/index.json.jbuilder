json.products @products do |product|
  json.id product.id.to_s
  json.name product.name
  json.type product.product_type
  json.length product.length
  json.width product.width
  json.height product.height
  json.weight product.weight
end