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

			home = new MenuItem(url, '/home', 'Home')

			topmenu: [
				home,
				new MenuItem(url, '/todo', 'Todo')
			]

			page: @observable null
			url: url

			homeActive: home.isActive

		initialize: () ->

			console.log 'init Application'
			@url.subscribe (value) =>
				setTimeout () =>
					if @router.getLocation() != value
						@router.setLocation value
				, 0

			@initRouter()



			@router.run()
			@router.bind 'location-changed', () =>
				@url @router.getLocation()
			ko.applyBindings @


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
