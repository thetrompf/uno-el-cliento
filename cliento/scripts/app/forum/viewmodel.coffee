define [
	'underscore'
	'base/viewmodel'
], (_, ViewModel) ->
	'use strict'
	class ForumViewModel extends ViewModel

		properties: () ->
			_template : @observable 'app/forum/index.jshtml'
			template  : () => @_template()

			gotoHome: () =>
				@url '/home'

		constructor: () ->
			log 'init ForumViewModel'
			super
			_.extend @, arguments[0]
