json.array!(@event_organisers) do |event_organiser|
  json.extract! event_organiser, :id, :firstName, :lastName, :phoneNumber, :password
  json.url event_organiser_url(event_organiser, format: :json)
end
