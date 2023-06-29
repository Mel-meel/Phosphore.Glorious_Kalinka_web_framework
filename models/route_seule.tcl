# Glorious Kalinka web framework

##
# Traitement de la route
##
proc App_route_ROUTE {get post {route_html {"unencapsuled" ""}}} {
    set contenu_route [lindex $route_html 1]
    

    set html [list "unencapsuled" $contenu_route]
    
    return $html
}

##
# Retourne le nom de la route actuelle
##
proc App_route_nom_ROUTE {} {
    return "ROUTE"
}

##
# Retourne le titre de la page générée pour la balise <title>
##
proc App_route_titre_ROUTE {} {
    return "ROUTE"
}

##
# Retourne une liste contenant toutes les sources JS nécessaires à cette route,
# typiquement, les actions qui lui sont liées
##
proc App_route_js_ROUTE {{js "null"}} {
    set js_liste [list]
    if {$js != "null"} {
        set js_liste [BaseKalinka_List_concat $js_liste $js]
    }
    return $js_liste
}

##
# Retourne une liste contenant toutes les sources CSS nécessaires à cette route
##
proc App_route_css_ROUTE {{css "null"}} {
    set css_liste [list]
    if {$css != "null"} {
        set css_liste [BaseKalinka_List_concat $css_liste $css]
    }
    return $css_liste
}