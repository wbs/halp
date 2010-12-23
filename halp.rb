require 'rubygems'
require 'sinatra'
require 'gollum'
require 'erb'

class Halp < Sinatra::Base
	# show the homepage
	get '/' do
		show('Home')
	end

	# show everything else
	get '/*' do
		show(params[:splat].first)
	end

	# returns a given page (or file) inside our repository
	def show(name)
		wiki = Gollum::Wiki.new('~/Projects/gpdocs')
		if page = wiki.page(name)
			@page = page
			@name = page.title
			@content = page.formatted_data
			erb :show
		elsif file = wiki.file(name)
			content_type file.mime_type
			file.raw_data
		else
			halt 404
		end
	end

end