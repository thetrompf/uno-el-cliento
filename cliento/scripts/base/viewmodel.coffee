define [
	'knockout'
	'underscore'
], (ko, _) ->
	'use strict'
	class ViewModelBase
		constructor: () ->
			_.extend @, @properties(arguments...)

		observable: (val) ->
			return ko.observableArray val if _.isArray val
			return ko.observable val

		computed: (fn, opts = deferEvaluation: true ) -> ko.computed fn, @, opts

		properties: () -> arguments
