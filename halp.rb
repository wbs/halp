require 'rubygems'
require 'sinatra'
require 'gollum'
require 'erb'

class Halp < Sinatra::Base
	# show the homepage
	get '/' do
		show('Home')
	end

	get '/search' do
		@query = params[:search]
		wiki = Gollum::Wiki.new(options.rep)
		@results = wiki.search @query
		@name = @query
		
		erb :results
	end

	# show everything else
	get '/*' do
		show(params[:splat].first)
	end

	# returns a given page (or file) inside our repository
	def show(name)
		wiki = Gollum::Wiki.new(options.rep)
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

	configure :development do
	  set :rep, '~/Projects/gpdocs'
	end

	configure :production do
	  set :rep, '~/gpdocs'
	end

end