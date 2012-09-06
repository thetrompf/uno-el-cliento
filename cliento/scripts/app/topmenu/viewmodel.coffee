define [
	'base/viewmodel'
	'knockout'
], (ViewModel) ->
	'use strict'
	class TopmenuViewModel extends ViewModel

		constructor: (@url) ->
			log 'init TopmenuViewModel'
			@url = ''
			super

		delegateUrl: (url) ->
			@url = url

		properties: () ->
			tmpl: @observable 'app/topmenu/index.jshtml'
			template: () => @tmpl()
			items: @observable [
				@observable
					content: '#Home'
					href: '/home'
					isActive: @computed () ->
						/^\/home/.test @url()

				@observable
					content: ':ToDo'
					href: '/todo'
					isActive: @computed () ->
						/^\/todo/.test @url()

				@observable
					content: '$FOrum'
					href: '/forum'
					isActive: @computed () ->
						/^\/forum/.test @url()

				@observable
					content: '.faq'
					href: '/faq'
					isActive: @computed () ->
						/^\/faq/.test @url()

				@observable
					content: '/TOOls/'
					href: '/tools'
					isActive: @computed () ->
						/^\/tools/.test @url()
			]