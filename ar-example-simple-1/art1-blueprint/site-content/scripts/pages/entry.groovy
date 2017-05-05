def pokemonModelIds = contentModel.get("models/item")

templateModel.pokemonInstances = []

pokemonModelIds.each { item ->
	def pokemonInstance = [:]
    def modelItemId = item.get("model/item/key").text
    
    pokemonInstance.model = siteItemService.getSiteItem(modelItemId)
    pokemonInstance.xPosition = item.get("xPosition").text
    pokemonInstance.yPosition = item.get("yPosition").text
    pokemonInstance.zPosition = item.get("zPosition").text
    pokemonInstance.scaleMultiplier = item.get("scaleMultiplier").text
	
    templateModel.pokemonInstances.add(pokemonInstance)
}

