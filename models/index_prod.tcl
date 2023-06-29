## Créé les 30/5/2020 ##

######################################################
#  ___         __    __  ___         __   ___  ____  #
#  |__| |  |  /  \  /    |__| |  |  /  \  |__| |     #
#  |    |--| |    | ---- |    |--| |    | |\   |--   #
#  |    |  |  \__/  ___/ |    |  |  \__/  | \  |___  #
#                                                    #
######################################################

#########################################################################
# Glorious Kalinka web framework                                        #
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

source "configs/sources.tcl"
source "configs/general.tcl"

set parents [list]

# Variables GET
set get [BaseKalinka_GET]
# Variables POST
set post [BaseKalinka_POST]

# Route
set route [BaseKalinka_Route]

@ROUTES@

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
set chemin_route "Routes/$ROUTE.tcl"
# Si le fichier existe, tout vas bien
if {[file exists $chemin_route]} {
    source $chemin_route
# Si le ficher n'existe pas, erreur
} else {
    BaseKalinka_Erreur "Le fichier de route \"$chemin_route\" n'existe pas ; lors de l'accès à la route \"$route\""
}
# Exécution de la route demandée
set html ""
set js ""
set css ""
foreach parent $parents {
    set html [App_route_$parent $get $post $html]
    set js [App_route_js_$parent $js]
    set js [App_route_css_$parent $css]
}
set html [App_main $get $post $html]

set html [BaseKalinka_TemplateHTML $html [dict create "::INDEX_PATH::" [BaseKalinka_ServeurHTTP_chemin_index]] 1]

puts $html
