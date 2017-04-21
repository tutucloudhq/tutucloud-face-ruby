# -*- coding: utf-8 -*-
$LOAD_PATH << '.'

require 'TUTUCLOUD/face'

begin
	# 公有 key
	api_key = ''
	# 私有 key
	api_secret = ''

	face = TUTUCLOUD::Face.new(api_key, api_secret)
	detection_data = face.request('analyze/detection', {:url => 'https://files.tusdk.com/img/faces/f-dd1.jpg'})
	# detection_data = face.request('analyze/detection', {:file => 'test.webp'})

	p detection_data

rescue
	puts $@
	puts $!
end
