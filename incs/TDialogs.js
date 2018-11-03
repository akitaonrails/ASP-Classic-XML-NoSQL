// defines the behavior of a layer-based dialog-box
function TDialogBox( sName ) {
	this.parent = null;
	this.layer = null;
	
	this.Create = TDialogBox_Create;
	this.Show = TDialogBox_Show;
	this.Hide = TDialogBox_Hide;
	this.Name = TDialogBox_Name;
	this.Form = TDialogBox_Form;
	this.Move = TDialogBox_Move;
	
	// constructor handler
	if ( sName ) {
		this.Create( sName );
	}
	
	// adds a new layer to this controller
	function TDialogBox_Create( sName ) {
		this.layer = document.all( sName );
		// force hidding of this dialog
		this.Hide();
	}
	
	// hides the layer
	function TDialogBox_Hide() {
		if ( !this.layer ) { return }
		with ( this.layer.style ) {
			visibility = 'hidden';
			left = -1000;
			top = -1000;
		}
	}
	
	// show the layer
	function TDialogBox_Show() {
		if ( !this.layer ) { return }
		if ( this.parent ) {
			this.parent.HideAll();
		}
		with ( this.layer.style ) {
			visibility = 'visible';
			left = window.event.x + document.body.scrollLeft;
			top = window.event.y + document.body.scrollTop;
		}
	}
	
	// changes the absolute position of the dialog box
	function TDialogBox_Move( intX, intY ) {
		try {
			if ( !isNaN( intX ) ) {
				this.layer.style.left = intX;
			}
			if ( !isNaN( intY ) ) {
				this.layer.style.top = intY;
			}
		} catch( e ) {
		}
	}
	
	// returns the name of the layer
	function TDialogBox_Name() {
		return this.layer.id;
	}
	
	// returns the form object or one of it´s elements
	function TDialogBox_Form() {
		var oForm = null;
		if ( this.layer.document.forms.length > 0 ) {
			oForm = this.layer.document.forms[ 0 ];
		} else {
			return null;
		}
		if ( arguments.length > 0 ) {
			for ( var i = 0; i < oForm.elements.length; i ++ ) {
				if ( oForm.elements[ i ].name == arguments[ 0 ] ) {
					return oForm.elements[ i ];
				}
			}
			return null;
		}
		return oForm;
	}
}

// controls all the current available dialog boxes
function TDialogControl() {
	this.queue = new Array();
	this.objects = new Array();
	
	this.Add = TDialogControl_Add;
	this.Get = TDialogControl_Get;
	this.HideAll = TDialogControl_HideAll;
	
	this.AddQueue = TDialogControl_AddQueue;
	this.RunQueue = TDialogControl_RunQueue;
	
	// add a layer name do an asynchronous queue
	function TDialogControl_AddQueue( sLayer ) {
		this.queue.length ++;
		this.queue[ this.queue.length - 1 ] = sLayer;
	}

	// creates the dialog controllers based on the previous queue	
	function TDialogControl_RunQueue() {
		for ( var i = 0; i < this.queue.length; i ++ ) {
			this.Add( new TDialogBox( this.queue[ i ] ) );
		}
		this.HideAll();
	}
	
	// add a new dialog box to the queue
	function TDialogControl_Add( objDialog ) {
		if ( !objDialog ) { return }
		var i = this.objects.length;
		this.objects.length = i + 1;
		this.objects[ i ] = objDialog;
		objDialog.parent = this;
	}
	
	// return the handler of the dialog box
	function TDialogControl_Get( sLabel ) {
		for ( var i = 0; i < this.objects.length; i ++ ) {
			if ( this.objects[ i ].Name() == sLabel ) {
				return this.objects[ i ];
			}
		}
		return null;
	}
	
	// hide all dialogs controls
	function TDialogControl_HideAll() {
		if ( this.objects.length > 0 ) {
			for ( var i = 0; i < this.objects.length; i ++ ) {
				this.objects[ i ].Hide();
			}
		}
	}
}
