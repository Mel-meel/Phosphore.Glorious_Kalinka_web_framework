## Créé le 1/6/2020 ##

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
# Transforme une liste en dictionnaire 0 : valeur, 1 : valeur, ...
##
proc BaseKalinka_List_dict {liste} {
    set c 0
    foreach element $liste {
        dict set res $c $element
        set c [expr $c + 1]
    }
    unset c element liste
    return $res
}

##
# Nettoie une liste en supprimant les éléments vides
##
proc BaseKalinka_List_supp_espaces {liste} {
    set res [list]
    foreach element $liste {
        if {$element != ""} {
            lappend res $element
        }
    }
    return $res
}

##
# Fusionne deux listes
##
proc BaseKalinka_List_concat {liste1 liste2} {
    foreach element $liste2 {
        lappend liste1 $element
    }
    return $liste1
}

##
# Renverse une liste
##
proc BaseKalinka_List_renverse {liste} {
    set nliste [list]
    set c [expr [llength $liste] - 1]
    while {[llength $nliste] < [llength $liste]} {
        lappend nliste [lindex $liste $c]
        set c [expr $c - 1]
    }
    return $nliste
}
