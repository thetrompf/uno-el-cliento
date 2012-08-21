define ['stock-knockout'], (ko) ->
	ExtendedNativeTemplateEngine = () ->
		this['allowTemplateRewriting'] = false

	ExtendedNativeTemplateEngine.prototype = new ko.templateEngine()

	ExtendedNativeTemplateEngine.prototype['renderTemplate'] = (template, bindingContext, options, templateDocument) ->
		templateNode = document.createElement 'div'

		templateNode.innerHTML = if koTemplates[template]? then koTemplates[template] else koTemplates['nullTemplate']


		templateSource = new ko.templateSources.domElement templateNode

		return this['renderTemplateSource'](templateSource, bindingContext, options)

	ExtendedNativeTemplateEngine.prototype['renderTemplateSource'] = (templateSource, bindingContext, options) ->
		useNodesIfAvailable = !(ko.utils.ieVersion < 9)
		templateNodesFunc = if useNodesIfAvailable then templateSource['nodes'] else null
		templateNodes = if templateNodesFunc then templateSource['nodes']() else null

		if templateNodes
			return ko.utils.makeArray(templateNodes.cloneNode(true).childNodes)
		else
			templateText = templateSource['text']()
			return ko.utils.parseHtmlFragment(templateText)

	koTemplates = {}
	koTemplates['nullTemplate'] = ''
	oldTemplateUpdate = ko.bindingHandlers['template']['update']
	ko.bindingHandlers['template']['update'] = (element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) ->
		value = valueAccessor()
		bindingValue = ko.utils.unwrapObservable value

		if (typeof bindingValue) == "string"
			templateName = bindingValue
		else
			templateName = bindingValue['name']

		templateName = templateName(bindingContext.$data) if (typeof templateName) == 'function'

		unless templateName?
			return oldTemplateUpdate element, valueAccessor, allBindingsAccessor, viewModel, bindingContext

		templatePath = 'text!'+templateName

		if not koTemplates[templateName]?
			run = false
			require [templatePath], (template) ->
				run = true
				koTemplates[templateName] = template
				# Force the domData to be unset - so that knockout will force a re-rendering of the template
				lastMappingResultDomDataKey = "setDomNodeChildrenFromArrayMapping_lastMappingResult"
				ko.utils.domData.set element, lastMappingResultDomDataKey, []
				oldTemplateUpdate element, valueAccessor, allBindingsAccessor, viewModel, bindingContext
			unless run
				# Always run the old template function to ensure the correct dependencies are set
				oldTemplateUpdate element, valueAccessor, allBindingsAccessor, viewModel, bindingContext
		else
			oldTemplateUpdate element, valueAccessor, allBindingsAccessor, viewModel, bindingContext


	ko.setTemplateEngine(new ExtendedNativeTemplateEngine())

	return ExtendedNativeTemplateEngine