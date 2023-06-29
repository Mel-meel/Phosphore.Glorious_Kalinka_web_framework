## Créé les 3/10/2020 ##

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

proc BaseKalinka_Configs {} {
    global PHCFG
    global ROUTES
    
    set fichier "configs/Phosphore.cfg"
    
    if {[file exists $fichier]} {
        set contenu [BaseKalinka_Fichier_contenu $fichier "r"]
        foreach element [list "ERR" "ERR_MODE" "APP_MODE" "MODE_REWRITE"] {
            set pos [string first $element $contenu]
            set PHCFG($element) [string range $contenu [expr [string first ":" $contenu $pos] + 1] [expr [string first "\n" $contenu $pos] - 1]]
        }
        set pos [string first "ROUTES" $contenu]
        # Lecture des routes
        set routes [string range $contenu [expr [string first "\{" $contenu $pos] + 1] [expr [string first "\}" $contenu $pos] - 1]]
        foreach route [split $routes "\n"] {
            set route [split $route ":"]
            set ROUTES([string range [lindex $route 0] 1 [expr [string length [lindex $route 0]] - 2 ]]) [string range [lindex $route 1] 1 [expr [string length [lindex $route 1]] - 2 ]]
        }
    } else {
        puts "Le fichier \"$fichier\" n'existe pas"
    }
}
