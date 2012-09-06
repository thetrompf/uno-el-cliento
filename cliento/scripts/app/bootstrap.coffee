requirejs.config
	
	baseUrl:            'scripts'
	
	paths:
		'bootstrap'      : 'vendor/bootstrap-2.1.0'
		'jquery'         : 'vendor/jquery-1.8.1'
		'jquery-ui'      : 'vendor/jquery-ui-1.8.23.custom'
		'stock-knockout' : 'vendor/knockout-2.1.0'
		'knockout'       : 'ext/knockout/knockout'
		'moment'         : 'vendor/moment-1.7.0'
		'sammy'          : 'vendor/sammy-0.7.1'
		'underscore'     : 'vendor/underscore-1.3.3'
		'text'           : 'vendor/require/require.text-2.0.3'
		'spinner'        : 'vendor/spin'

	shim:
		'underscore':
			exports       : '_'
		'sammy':
			deps          : ['jquery']
			exports       : 'Sammy'
		'jquery-ui':
			debs          : ['jquery']
			exports       : 'jQuery'
		'spinner':
			exports       : 'Spinner'

# start the main app logic
requirejs [
	'app/application'
], (Application) ->
	'use strict'

	window.DEBUG = true

	window.log = () ->
		if window.DEBUG
			console.log arguments...

	#jQuery, canvas and the app/sub module are all
	#loaded and can be used here now.
	new Application
