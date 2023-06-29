## Créé le 31/5/2020 ##

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
# Différente façon de récupérer la route demandée :
# 	- Méthode 1 : par index.tcl?route=/chemin/vers/la/route/demandee
# 	- Méthode 2 : par index.tcl/chemin/vers/la/route/demandee
##
proc BaseKalinka_Route {} {
    global CONFIG
    global ROUTES
    
    set route ""
    # Si méthode 1 dans les configurations
    if {$CONFIG(Routage) == 1} {
        if {[BaseKalinka_GET_existe_ "route"] == 1} {
            set route [BaseKalinka_GET "route"]
        } else {
            set route "/"
        }
    # Si méthode 2 dans les configurations
    } elseif {$CONFIG(Routage) == 2} {
        set url [BaseKalinka_ServeurHTTP_ENV "url"]
        set depart [expr [string first "index.tcl" $url] + 9]
        set debut_params [expr [string first "?" $url] - 1]
        if {$debut_params > -1} {
            set fin $debut_params
        } else {
            set fin [string length $url]
        }
        set route [string range $url $depart $fin]
    }
    # Supprime le dernier "/"
    set dernier [string range $route [expr [string length $route] - 1] [string length $route]]
    if {[string length $route] > 1 && $dernier == "/"} {
        set route [string range $route 0 [expr [string length $route] - 2]]
    }
    # Route par défaut
    if {$route == "" || $route == "/"} {
        set route "/index"
    }
    
    return $route
}


##
# Différente façon de récupérer la route demandée :
# 	- Méthode 1 : par index.tcl?route=/chemin/vers/la/route/demandee
# 	- Méthode 2 : par index.tcl/chemin/vers/la/route/demandee
##
proc BaseKalinka_Route_a {} {
    global CONFIG
    
    set route ""
    # Si méthode 1 dans les configurations
    if {$CONFIG(Routage) == 1} {
        if {[BaseKalinka_GET_existe_ "route"] == 1} {
            set route [BaseKalinka_GET "route"]
        } else {
            set route "/"
        }
    # Si méthode 2 dans les configurations
    } elseif {$CONFIG(Routage) == 2} {
        set url [BaseKalinka_ServeurHTTP_ENV "url"]
        set depart [expr [string first "index.tcl" $url] + 9]
        set debut_params [expr [string first "?" $url] - 1]
        if {$debut_params > -1} {
            set fin $debut_params
        } else {
            set fin [string length $url]
        }
        set route [string range $url $depart $fin]
    }
    # Supprime le dernier "/"
    set dernier [string range $route [expr [string length $route] - 1] [string length $route]]
    if {[string length $route] > 1 && $dernier == "/"} {
        set route [string range $route 0 [expr [string length $route] - 2]]
    }
    # Route par défaut
    if {$route == ""} {
        set route "/"
    }
    
    return $route
}

proc BaseKalinka_Routes_controleur_route {} {
    global ROUTES
}

proc BaseKalinka_Routes_route_controleur {} {
    global ROUTES
}

##
# Redirige le navigateur vers la route demandée
##
proc BaseKalinka_route2 {{route "index"}} {
    if {$route == ""} {
        set route "index"
    }
    if {[file exists "sources/Routes/$route.tcl"]} {
        BaseKalinka_Headers_redirect "index.tcl?route=$route"
    } else {
        BaseKalinka_Erreur "Impossible de trouver la route demandée : \"$route\""
    }
}

##
#
##
proc BaseKalinka_route_gen_url {{route "index"}} {
    if {$route == ""} {
        set route "index"
    }
    if {[file exists "sources/Routes/$route.tcl"]} {
        set url "index.tcl?route=$route"
    } else {
        BaseKalinka_Erreur "Impossible de trouver la route demandée : \"$route\""
        set url "index.tcl"
    }
    return $url
}

##
# Liste des routes
##
proc BaseKalinka_liste_routes {} {
    set routes [glob -directory "sources/Routes/" "*.tcl"]
    foreach res $routes {
        if {$res != "sources/Routes/Main.tcl"} {
            lappend liste_routes [lindex [split $res "/"] 0]
        }
    }
    return $liste_routes
}
