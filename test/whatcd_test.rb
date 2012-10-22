require 'riot'
require 'whatcd'

username = ENV['WHATCD_USERNAME']
password = ENV['WHATCD_PASSWORD']

context WhatCD do 
	setup { WhatCD }

	asserts('includes HTTParty methods') { topic }.kind_of? HTTParty

	context 'Correct credentials' do
		hookup { topic::authenticate username, password }

		asserts('is authenticated') { topic::authenticated? }
		asserts('requests with parameters') {  topic::User(id: 28747) }.kind_of Hash
		asserts('requests without paramters') { topic::Index }.kind_of Hash
		asserts('raises exceptions') { topic::Xxx }.raises WhatCD::APIError
	end

	context 'Incorrect credentials' do
		hookup { topic::cookies {} }
		
		asserts('raises AuthError') { topic::authenticate '.', '..' }.raises WhatCD::AuthError
		asserts('raises AuthError') { topic::User(id: 28747) }.raises WhatCD::AuthError
	end
end
