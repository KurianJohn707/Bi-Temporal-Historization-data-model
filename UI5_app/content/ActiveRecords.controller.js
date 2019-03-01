// the controller for the view Main
sap.ui.controller("content.ActiveRecords", {

	// controller logic goes here
    
    onInit: function() {
    	// this function is called when the view is instantiated. 
    	// Used to modify the view before displaying
    	 var dataModel = new sap.ui.model.odata.ODataModel("model/GBI.xsodata");
        // after that, we can bind the odata model the
        // SalesOrders view, so controls within the view can use them
        this.getView().setModel(dataModel);
        
    },
    
    _filter : function() {
			var oFilter = null;
/*
			if (this._oGlobalFilter) {
				oFilter = this._oGlobalFilter;
			} */
			if (this._oIDFilter && this._oNameFilter && this._oCityFilter) {
				oFilter = new sap.ui.model.Filter([this._oIDFilter, this._oNameFilter, this._oCityFilter], true);
			}
			else if (this._oIDFilter && this._oNameFilter) {
				oFilter = new sap.ui.model.Filter([this._oIDFilter, this._oNameFilter], true);
			}
			else if (this._oIDFilter && this._oCityFilter) {
				oFilter = new sap.ui.model.Filter([this._oIDFilter, this._oCityFilter], true);
			}
			else if (this._oCityFilter && this._oNameFilter) {
				oFilter = new sap.ui.model.Filter([this._oCityFilter, this._oNameFilter], true);
			}
			else if (this._oIDFilter) {
				oFilter = this._oIDFilter;
			} 
			else if (this._oNameFilter) {
				oFilter = this._oNameFilter;
			} 
			else if (this._oCityFilter) {
				oFilter = this._oCityFilter;
			} 

			this.byId("table").getBinding("rows").filter(oFilter, "Application");
		},
		/*
		filterGlobally : function(oEvent) {
			var sQuery = oEvent.getParameter("query");
			this._oGlobalFilter = null;

			if (sQuery) {
				this._oGlobalFilter = new sap.ui.model.Filter([
					new sap.ui.model.Filter("CUSTOMER_NUMBER", sap.ui.model.FilterOperator.Contains, sQuery.toUpperCase()),
					new sap.ui.model.Filter("CUSTOMER_NAME", sap.ui.model.FilterOperator.Contains, sQuery.toUpperCase()),
					new sap.ui.model.Filter("CITY", sap.ui.model.FilterOperator.Contains, sQuery.toUpperCase())
				], false);
			}

			this._filter();
		},
		*/
		filterID : function(oEvent) {
			var sQuery = oEvent.getParameter("query");
			this._oIDFilter = null;

			if (sQuery) {
				this._oIDFilter = new sap.ui.model.Filter([
					new sap.ui.model.Filter("CUSTOMER_NUMBER", sap.ui.model.FilterOperator.Contains, sQuery.toUpperCase())
				], false);
			}

			this._filter();
		},
		
		filterName : function(oEvent) {
			var sQuery = oEvent.getParameter("query");
			this._oNameFilter = null;

			if (sQuery) {
				this._oNameFilter = new sap.ui.model.Filter([
					new sap.ui.model.Filter("CUSTOMER_NAME", sap.ui.model.FilterOperator.Contains, sQuery.toUpperCase())
				], false);
			}

			this._filter();
		},
		
		filterCity : function(oEvent) {
			var sQuery = oEvent.getParameter("query");
			this._oCityFilter = null;

			if (sQuery) {
				this._oCityFilter = new sap.ui.model.Filter([
					new sap.ui.model.Filter("CITY", sap.ui.model.FilterOperator.Contains, sQuery.toUpperCase())
				], false);
			}

			this._filter();
		},
		
		clearAllFilters : function(oEvent) {
			var oTable = this.byId("table");

			var oUiModel = this.getView().getModel();
			oUiModel.setProperty("/globalFilter", "");
			oUiModel.setProperty("/availabilityFilterOn", false);

			this._oGlobalFilter = null;
			this._filter();

			var aColumns = oTable.getColumns();
			for (var i = 0; i < aColumns.length; i++) {
				oTable.filter(aColumns[i], null);
			}
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
