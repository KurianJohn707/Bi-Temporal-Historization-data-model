// the controller for the view Main
sap.ui.controller("content.Main", {

	// controller logic goes here
    
    onInit: function() {
    	// this function is called when the view is instantiated. 
    	// Used to modify the view before displaying
    	 var dataModel = new sap.ui.model.odata.ODataModel("model/GBI.xsodata");
        // after that, we can bind the odata model the
        // SalesOrders view, so controls within the view can use them
        this.getView().setModel(dataModel);
        
    },
    
    onExit: function() {
    	// this function is called when the view is destroyed. 
    	// Used for clean-up activities
    },
    
    onAfterRendering: function() {
    	// this function is called when the view has been rendered. 
    	// Used for post-rendering manipulation of the HTML code
    },
    
    onBeforeRendering: function() {
    	// this function is called before the view is re-rendered 
    	// (not before first rendering)
    }
});
