
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins  'https://young-ravine-88792.herokuapp.com','0.0.0.0'

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: true
  end
 
end

