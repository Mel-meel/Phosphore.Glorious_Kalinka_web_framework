# Phosphore Framework TCL

##
# Traitement de la route
# Lorsque plusieurs routes s'imbrique, l'HTML de la route fille se récupère grâce
# à la variable html, null par défaut
##
proc App_route_404 {get post {html "null"}} {
    set template "Templates/404.html"
    #
    # Ajouter ici le code de la route (traitement des données pour remplir le template, ...)
    #
    set vars [dict create "FILLE" $html]
    set html [BaseKalinka_TemplateHTML $template $vars]
    return $html
}

##
# Retourne le nom de la route actuelle
##
proc App_route_nom_404 {} {
    return "404"
}

##
# Retourne le titre de la page générée pour la balise <title>
##
proc App_route_titre_404 {} {
    return "404"
}

##
# Retourne une liste contenant toutes les sources JS nécessaires à cette route,
# typiquement, les actions qui lui sont liées
##
proc App_route_js_404 {{js "null"}} {
    set js_liste [list]
    if {$js != "null"} {
        set js_liste [BaseKalinka_List_concat $js_liste $js]
    }
    return $js_liste
}

##
# Retourne une liste contenant toutes les sources CSS nécessaires à cette route
##
proc App_route_css_404 {{css "null"}} {
    set css_liste [list]
    if {$css != "null"} {
        set css_liste [BaseKalinka_List_concat $css_liste $css]
    }
    return $css_liste
}

