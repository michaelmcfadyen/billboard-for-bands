json.array!(@artists) do |artist|
  json.extract! artist, :id, :name, :email, :type, :password
  json.url artist_url(artist, format: :json)
end
