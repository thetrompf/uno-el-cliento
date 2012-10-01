define [
	'base/viewmodel'
], (ViewModel) ->
	'use strict'
	class FaqViewModel extends ViewModel

		properties: () ->
			_template : @observable 'app/faq/index.jshtml'
			template  : () => @_template()

		constructor: () ->
			super
			log 'init FaqViewModel'