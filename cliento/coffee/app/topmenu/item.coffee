define [
	'base/viewmodel'
], (ViewModel) ->

	class MenuItem extends ViewModel

		properties: (activeUrl, url, title) ->
			url: @observable url
			title: @observable title
			isActive: @computed () -> activeUrl() == @url()

