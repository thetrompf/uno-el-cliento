define ['knockout'], (ko) ->
	ExtendedNativeTemplateEngine = () ->
		this['allowTemplateRewriting'] = false

	ExtendedNativeTemplateEngine.prototype = new ko.templateEngine()

	ExtendedNativeTemplateEngine.prototype['renderTemplate'] = (template, bindingContext, options, templateDocument) ->
		templateNode = document.createElement 'div'

		templateNode.innerHTML = bindingContext['$root']['templates'][template]


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


	return ExtendedNativeTemplateEngine