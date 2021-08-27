
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins  'http://localhost:3000','http://localhost:4000','http://172.21.0.1:3000','172.21.0.5:3000','172.21.0.5', '172.21.0.1'

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      credentials: true
  end
 
end

