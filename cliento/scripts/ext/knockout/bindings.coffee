define [
	'stock-knockout'
	'underscore'
	'jquery'
	'jquery-ui'
], (ko, _, $) ->

	# HIGHLIGHT BINDING



	ko.bindingHandlers['highlight'] =
		domDataKey: 'highlightText'
		makeBindingValue: (bindingValue) ->
			bindingValue = ko.utils.unwrapObservable bindingValue
			options =
				'on': ''
				'className': 'highlight'
				'inDuration': 200
				'outDuration': 550

			unless _.isObject bindingValue
				options['on'] = bindingValue

			if bindingValue?['text']?
				options['on'] = ko.utils.unwrapObservable bindingValue['text']

			if bindingValue?['on']?
				options['on'] = ko.utils.unwrapObservable bindingValue['on']

			if bindingValue?['className']?
				options['className'] = ko.utils.unwrapObservable bindingValue['className']

			if bindingValue?['inDuration']?
				options['inDuration'] = ko.utils.unwrapObservable bindingValue['inDuration']

			if bindingValue?['outDuration']?
				options['outDuration'] = ko.utils.unwrapObservable bindingValue['outDuration']

			return options
		flashElement: (element, options) ->
			lastValue = (ko.utils.domData.get element, ko.bindingHandlers['highlight'].domDataKey)
			if lastValue != options['on']
				ko.utils.domData.set element, ko.bindingHandlers['highlight'].domDataKey, options['on']
				if lastValue?
					$(element).addClass options['className'], options['inDuration'], () ->
						$(element).removeClass options['className'], options['outDuration']
		'update': (element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) ->
			options = ko.bindingHandlers['highlight'].makeBindingValue valueAccessor()

			ko.bindingHandlers['highlight'].flashElement(element, options)

	ko.bindingHandlers['highlightText'] =
		'update': (element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) ->
			options = ko.bindingHandlers['highlight'].makeBindingValue valueAccessor()

			ko.bindingHandlers['text']['update'](element, (() -> options['on']), allBindingsAccessor, viewModel, bindingContext)

			ko.bindingHandlers['highlight'].flashElement(element, options)


	# ANIMATED TEMPLATE RENDERING
	enableAnimationOnTemplateBinding = (element, bindingValue) ->
			bindingValue = ko.utils.unwrapObservable bindingValue()

			animate = ko.utils.unwrapObservable(bindingValue['animate'] ? true)

			if animate
				orgRender = bindingValue['afterRender']
				bindingValue['afterRender'] = (elements) ->
					elm = if bindingValue['foreach']? then elements else element
					$(elm).hide().fadeIn()
					orgRender elements if orgRender?

				orgAdd = bindingValue['afterAdd']
				bindingValue['afterAdd'] = (elements) ->
					elm = if bindingValue['foreach']? then elements else element
					$(elm).fadeIn()
					orgAdd elements if orgAdd?

				orgRemove = bindingValue['beforeRemove']
				bindingValue['beforeRemove'] = (elements) ->
					elm = if bindingValue['foreach']? then elements else element
					$(elm).fadeOut()
					orgRemove elements if orgRemove?

			return () -> bindingValue


	originalTemplateInit = ko.bindingHandlers['template']['init']
	originalTemplateUpdate = ko.bindingHandlers['template']['update']
	ko.bindingHandlers['template'] =
		'init': (element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) ->
			valueAccessor = enableAnimationOnTemplateBinding element, valueAccessor

			originalTemplateInit element, valueAccessor, allBindingsAccessor, viewModel, bindingContext
		'update': (element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) ->
			valueAccessor = enableAnimationOnTemplateBinding element, valueAccessor

			originalTemplateUpdate element, valueAccessor, allBindingsAccessor, viewModel, bindingContext
