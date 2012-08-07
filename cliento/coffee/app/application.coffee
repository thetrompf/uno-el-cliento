define [
	'knockout'
	'jquery'
	'sammy'
	'app/home/view_model'
], (ko, $, Sammy, HomeViewModel) ->
	'use strict'
	class Application

		initialize: () ->
			console.log 'init Application'
			@initRouter()
			@initLinkHandler()
			@router.run @getRoute()

		initRouter: () ->
			console.log 'init Router'
			self = @
			@router = Sammy '#main-container', () ->
				@get '/', () =>
					@runRoute 'get', '#/home'
				@get '#/home', () =>
					self.view_model = new HomeViewModel
					ko.applyBindings self.view_model
					self.view_model.name 'erik'


		initLinkHandler: () ->
			console.log 'rewriting links'
			$('body').delegate 'a[href]:not([target])', 'click', (event) ->
				event.preventDefault()
				event.stopPropagation()
				window.location.hash = '#'+$(this).attr 'href'
				return false

		getRoute: () ->
			path = window.location.pathname
			hash = window.location.hash
			return path+hash if hash isnt ""
			return path+"#"