define [
	'knockout'
	'jquery'
	'sammy'
	'app/home/view_model'
	'ext/knockout/text-templateengine'
], (ko, $, Sammy, HomeViewModel, TextTemplateEngine) ->
	'use strict'
	class Application

		initialize: () ->
			console.log 'init Application'
			ko.setTemplateEngine(new TextTemplateEngine())
			@initRouter()
			@router.run @getRoute()

		initRouter: () ->
			console.log 'init Router'
			self = @
			@router = Sammy '#main-container', () ->
				@get '/', () =>
					@runRoute 'get', '/home'
				@get '/home', () =>
					self.view_model = HomeViewModel()
					ko.applyBindings self.view_model
				@get '/todos', () =>
					self.view_model = HomeViewModel()
					ko.applyBindings self.view_model


		initLinkHandler: () ->
			console.log 'rewriting links'
			$('body').delegate 'a[href]:not([target])', 'click', (event) ->
				event.preventDefault()
				event.stopPropagation()
				window.location.hash = '#'+$(this).attr 'href'
				return false

		getRoute: () ->
			path = window.location.pathname
			return path