## Créé les 30/5/2020 ##

######################################################
#  ___         __    __  ___         __   ___  ____  #
#  |__| |  |  /  \  /    |__| |  |  /  \  |__| |     #
#  |    |--| |    | ---- |    |--| |    | |\   |--   #
#  |    |  |  \__/  ___/ |    |  |  \__/  | \  |___  #
#                                                    #
######################################################

#########################################################################
# Phosphore Framework TCL                                              #
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

# RQ : Phosphore/Types/Fichier.tcl

proc BaseKalinka_TemplateHTML {template {vars_o "null"} {stream 0}} {
    # Récupère le contenu du template
    if {$stream == 0} {
        set contenu [BaseKalinka_Fichier_contenu $template "r"]
    } else {
        set contenu $template
    }
    set debut 0
    set caractere_debut_variable "\{"
    set caractere_fin_variable "\}"
    set c 0
    # Recherche des variables du template
    while {$debut < [string length $contenu] && $debut < [string first $caractere_debut_variable $contenu [expr $debut+1]]} {
        set debut [string first $caractere_debut_variable $contenu [expr $debut+1]]
        set fin [string first $caractere_fin_variable $contenu [expr $debut+1]]
        set var [string range $contenu [expr $debut+1] [expr $fin-1]]
        # Ajoute la variable au dictionnaire
        dict set vars $c $var
        set c [expr $c+1]
    }
    set html $contenu
    # Boucle pour remplacer les variables par leurs valeurs
    if {$vars_o != "null"} {
        if {$debut != 0} {
            foreach {k var} $vars {
                set mot "\{$var\}"
                if {[dict exists $vars_o $var]} {
                    set replace [dict get $vars_o $var]
                } else {
                    set replace "\{$var\}"
                }
                set html [string map [list $mot $replace] $html]
            }
        }
    }
    return $html
}
