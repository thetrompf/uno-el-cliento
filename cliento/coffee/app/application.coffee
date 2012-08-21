define [
	'knockout'
	'jquery'
	'sammy'
	'base/viewmodel'
	'app/topmenu/item'
], (ko, $, Sammy, ViewModel, MenuItem) ->
	'use strict'
	class Application extends ViewModel

		properties: () ->
			url = @observable @getRoute()

			topmenu: [
				new MenuItem(url, '/home', 'Home')
				new MenuItem(url, '/todo', 'Todo')
			]

			isActive: @computed () ->
				console.log arguments...
				false

			page: @observable null
			url: url

		initialize: () ->

			console.log 'init Application'

			@initRouter()

			ko.applyBindings @

			@url.subscribe (value) =>
				if @router.getLocation() != value
					@router.setLocation value

			@router.run()
			@router.bind 'location-changed', () =>
				@url @router.getLocation()


		initRouter: () ->
			console.log 'init Router'
			self = @
			@router = Sammy () ->
				@get '/', () =>
					@runRoute 'get', '/home'
				@get '/home', () =>
					require ['app/home/view_model'], (VM) ->
						self.page(new VM)
				@get '/todo', () =>
					require ['app/todo/view_model'], (VM) ->
						self.page(new VM)

		getRoute: () ->
			path = window.location.pathname
			return path

	return new Application
