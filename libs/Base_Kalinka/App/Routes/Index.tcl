## Créé le 30/5/2020 ##

######################################################
#  ___         __    __  ___         __   ___  ____  #
#  |__| |  |  /  \  /    |__| |  |  /  \  |__| |     #
#  |    |--| |    | ---- |    |--| |    | |\   |--   #
#  |    |  |  \__/  ___/ |    |  |  \__/  | \  |___  #
#                                                    #
######################################################

#########################################################################
# Phosphore Framework TCL                                               #
#                                                                       #
# This program is free software: you can redistribute it and/or modify  #
# it under the terms of the GNU General Public License as published by  #
# the Free Software Foundation, either version 3 of the License, or     #
# (at your option) any later version.                                   #
#                                                                       #
# This program is distributed in the hope that it will be useful,       #
# but WITHOUT ANY WARRANTY; without even the implied warranty of        #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         #
# GNU General Public License for more details.                          #
#                                                                       #
# You should have received a copy of the GNU General Public License     #
# along with this program.  If not, see <http://www.gnu.org/licenses/>. #
#########################################################################

##
# Fonction de démarrage du framework Phosphore
# ! La route d'index doit obligatoirement s'appeler "index"
##
proc BaseKalinka_Index {} {
    global ROUTES
    global ROUTE
    global ERREURS
    global SESSION
    global CONFIG
    
    if {$CONFIG(Session_type) != "non"} {
        set SESSION [BaseKalinka_Session_start $CONFIG(Session_nom)]
    }
    
    BaseKalinka_TCL_packages
    
    set ERREURS [dict create]
    dict set ERREURS "HTML" ""
    dict set ERREURS "SQL" ""
    dict set ERREURS "AJAX" ""
    set parents [list]
    # Template de route, par défaut "index"
    set route [BaseKalinka_Route]
    #puts $route
    if {[BaseKalinka_Array_clef_existe_ [array get ROUTES] $route] == 1} {
        set ROUTE $ROUTES($route)
    } else {
        set route "/404"
        set ROUTE "404"
    }
    # Variables GET
    set get [BaseKalinka_GET]
    # Variables POST
    set post [BaseKalinka_POST]
    # Décompose le chemin de la route et charge tous ses parents
    foreach parent [split $route "/"] {
        if {$parent != ""} {
            lappend parents $parent
        }
    }
    set parents [lreverse $parents]
    # Charge tous les fichiers de route
    foreach parent [glob -directory "sources/Routes/" "*.tcl"] {
        source $parent
    }
    # Chemin de la route
    set chemin_route "sources/Routes/$ROUTES($route).tcl"
    # Si le fichier existe, tout vas bien
    if {[file exists $chemin_route]} {
        source $chemin_route
    # Si le ficher n'existe pas, erreur
    } else {
        BaseKalinka_Erreur "Le fichier de route \"$chemin_route\" n'existe pas ; lors de l'accès à la route \"$route\""
    }
    # Exécution de la route demandée
    #set route_html [list "encapsuled" ""]
    set route_html "null"
    set js "null"
    set css "null"
    foreach parent $parents {
        if {$route_html == "null"} {
            set route_html [App_route_$parent $get $post]
        } else {
            set route_html [App_route_$parent $get $post $route_html]
        }
        set js [App_route_js_$parent $js]
        set css [App_route_css_$parent $css]
        #puts "fdsqfqfs"
    }
    set route_html [App_main $get $post $route_html]
    
    set type_retour [lindex $route_html 0]
    set contenu_route [lindex $route_html 1]
    
    if {$type_retour == "encapsuled"} {
        set vars [dict create "::CSS::" [BaseKalinka_HTML_css_gen [App_css $css]] "::JS::" [BaseKalinka_HTML_js_gen [App_js $js]] "::INDEX_PATH::" [BaseKalinka_ServeurHTTP_chemin_index]]
        
        # Ajoute les chemins des routes
        foreach name [array names ROUTES] {
            if {$CONFIG(Routage) == 1} {
                dict set vars "::ROUTE_PATH::$ROUTES($name)::" "[BaseKalinka_ServeurHTTP_chemin_index]index.tcl?route=$name"
            } elseif {$CONFIG(Routage) == 2} {
                dict set vars "::ROUTE_PATH::$ROUTES($name)::" "[BaseKalinka_ServeurHTTP_chemin_index]index.tcl$name"
            }
        }
        
        set html [BaseKalinka_TemplateHTML $contenu_route $vars 1]
    } else {
        set html $contenu_route
    }
    
    return $html
}
