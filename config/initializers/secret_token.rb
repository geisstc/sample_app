# Be sure to restart your server when you modify this file.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly, such as by adding
# .secret to your .gitignore file.
#original file:
#Cookbook::Application.config.secret_token = '87d8073d597424c332106284c7a8db9dc4f4835c1bc4c48a470fa994a27e79c9a135c66bc1b6754b7563b253d85a98dd974f2558d99778e53a381f8812a68f6f'

require 'securerandom'

def secure_token
  token_file = Rails.root.join('.secret')
  if File.exist?(token_file)
    # Use the existing token.
    File.read(token_file).chomp
  else
    # Generate a new token and store it in token_file.
    token = SecureRandom.hex(64)
    File.write(token_file, token)
    token
  end
end

SampleApp::Application.config.secret_token = secure_token