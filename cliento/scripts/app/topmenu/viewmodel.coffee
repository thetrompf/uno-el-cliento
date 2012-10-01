define [
	'base/viewmodel'
	'underscore'
], (ViewModel, _) ->
	'use strict'
	class TopmenuViewModel extends ViewModel

		delegateUrl: (url) ->
			@url = url

		constructor: () ->
			super
			log 'init TopmenuViewModel'

		properties: () ->
			_template: @observable 'app/topmenu/index.jshtml'
			template: () => @_template()
			items: @observable [
				@observable
					content: '#Home'
					href: '/home'
					isActive: @computed () ->
						(/^\/home/.test @url()) || (/^\/$/.test @url())

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