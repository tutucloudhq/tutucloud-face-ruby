# -*- coding: utf-8 -*-

require 'digest'
require 'json'
require 'rest-client'

module TUTUCLOUD
	
	API_URL = 'https://api.tutucloud.com/v1/face/'

	class Face

		def initialize(api_key, api_secret)
			@api_key = api_key
			@api_secret = api_secret
		end

		def request(method, image = {}, params = {})
			if image.has_key? :url
				@url = image[:url]
			end
			if image.has_key? :file
				@file = image[:file]
			end

			if @api_key == '' || @api_secret == ''
				raise 'api_key and api_secret is required'
			end

			_params = {:api_key => @api_key}
			_params[:t] = Time.now.to_i

			if @url != nil
				_params[:img] = @url
			elsif @file == nil
				raise 'img parameter is required'
			end

			_params.merge!(params)
			_params[:sign] = TUTUCLOUD.signature(_params, @api_secret)

			if @file != nil
				_params[:img] = File.new(@file, 'rb')
			end

			return JSON.parse(post(API_URL + method, _params))
		end

		def post(url, params)		
			rsp = RestClient.post url, params
			if rsp.code != 200
				raise "Error : http response code #{rsp.code}"
			end
			return rsp.to_s
		end
	end

	def TUTUCLOUD.signature(params = {}, api_secret)
		sorted  =  params.sort
		signstr = ''
		sorted.each do |k, v|
			signstr += k.downcase.to_s + v.to_s
		end
		signstr += api_secret
		Digest::MD5.hexdigest(signstr)
	end

end
