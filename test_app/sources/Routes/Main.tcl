# Phosphore Framework TCL

##
# Fonction principale de l'application
##
proc App_main {get post route_html} {
    global ROUTE
    
    set type_retour [lindex $route_html 0]
    set contenu_route [lindex $route_html 1]
    
    if {$type_retour == "encapsuled"} {
        set template "Templates/Main.html"
        #
        # Ajouter ici le code de l'index (traitement des données pour remplir le template, ...)
        # Pour utiliser la route actuelle : "set ma_route [App_route_ma_route]", renverra l'HTML de la route contruit
        #
        # Récupère le titre de la page de la route actuelle
        set titre_page [App_route_titre_$ROUTE]
        # Ajoute l'HTML de la route et le titre de la page aux variables du template Main.html (template principal)
        set vars_main [dict create "route" $contenu_route "titre_page" $titre_page]
        # Contruit l'HTML du Main
        set html [list "encapsuled" [BaseKalinka_TemplateHTML $template $vars_main]]
        # Renvoie l'HTML du Main pour l'affichage
    } else {
        set html [list $type_retour $contenu_route]
    }
    return $html
}

##
# Retourne une liste contenant toutes les sources JS nécessaires à l'application
##
proc App_js {{js "null"}} {
    set js_liste [list "scripts/Prototype.js" "scripts/EventListeners.js"]
    if {$js != "null"} {
        set js_liste [BaseKalinka_List_concat $js_liste $js]
    }
    return $js_liste
}

##
# Retourne une liste contenant toutes les sources CSS nécessaires à l'application
##
proc App_css {{css "null"}} {
    set css_liste [list "styles/Polyushka.css"]
    if {$css != "null"} {
        set css_liste [BaseKalinka_List_concat $css_liste $css]
    }
    return $css_liste
}
