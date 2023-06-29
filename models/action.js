// Phosphore Framework TCL

/**
 * Simple requête AJAX en méthode post
 */
function @ACTION@() {
    new Ajax.Request('/Actions/AJAX/@ACTION@.tcl', {
        method: 'post',
        parameters: {
            @PARAMETRES@
        }, 
        onSuccess : @ACTION@_success(transport), 
        onFailure : @ACTION@_failure()
    });
}

/**
 * Si la requête résussie
 */
function @ACTION@_success(transport) {
        var reponse = transport.responseText || "no response text" ;
        alert("Success! \n\n" + reponse) ;
}

/**
 * Si la requête échoue
 */
function @ACTION@_failure() {
    alert("Oups...") ;
}