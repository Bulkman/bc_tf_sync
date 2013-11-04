module MainHelper

  @@login = ""
  @@pass = ""
  @@base_url = "https://basecamp.com/"
  @@bc_api_v = "/api/v1/"
  @@bc_id = ""
  @@user_agent = { "User-Agent" => "BK_TF_SYNC (bulkman92@gmail.com)" }
  @@tf_endpoint = "http://testflightapp.com/api/builds.json"
  
  def make_bc_request(endpoint_path)
    auth = { :username => @@login, :password => @@pass }
    puts "HTTParty request to: " + @@base_url + @@bc_id + @@bc_api_v + endpoint_path
    #puts "HTTParty request auth: " + auth.inspect
    response = HTTParty.get(@@base_url + @@bc_id + @@bc_api_v + endpoint_path, :headers => @@user_agent, :basic_auth => auth)
    puts "HTTParty response: " + response.inspect
    response
  end
  
  def upload_build_to_tf(params)
    puts "Uploading build to testflight.."
    #puts "HTTParty request auth: " + auth.inspect
    response = HTTParty.post(@@tf_endpoint, params, :headers => { 'Accept' => 'application/json' })
    puts "HTTParty response: " + response.inspect
    response
  end
  
end
