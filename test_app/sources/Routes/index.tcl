# Phosphore Framework TCL

##
# Traitement de la route
# Lorsque plusieurs routes s'imbrique, l'HTML de la route fille se récupère grâce
# à la variable html, null par défaut
##
proc App_route_index {get post {route_html {"encapsuled" ""}}} {
    set template "Templates/index.html"
    
    set type_retour [lindex $route_html 0]
    set contenu_route [lindex $route_html 1]
    
    if {$type_retour == "encapsuled"} {
        #
        # Ajouter ici le code de la route (traitement des données pour remplir le template, ...)
        #
        set vars [dict create "FILLE" $contenu_route]
        set html [list "encapsuled" [BaseKalinka_TemplateHTML $template $vars]]
    } else {
        set html [list $type_retour $contenu_route]
    }
    
    return $html
}

##
# Retourne le nom de la route actuelle
##
proc App_route_nom_index {} {
    return "index"
}

##
# Retourne le titre de la page générée pour la balise <title>
##
proc App_route_titre_index {} {
    return "index"
}

##
# Retourne une liste contenant toutes les sources JS nécessaires à cette route,
# typiquement, les actions qui lui sont liées
##
proc App_route_js_index {{js "null"}} {
    set js_liste [list]
    if {$js != "null"} {
        set js_liste [BaseKalinka_List_concat $js_liste $js]
    }
    return $js_liste
}

##
# Retourne une liste contenant toutes les sources CSS nécessaires à cette route
##
proc App_route_css_index {{css "null"}} {
    set css_liste [list]
    if {$css != "null"} {
        set css_liste [BaseKalinka_List_concat $css_liste $css]
    }
    return $css_liste
}

