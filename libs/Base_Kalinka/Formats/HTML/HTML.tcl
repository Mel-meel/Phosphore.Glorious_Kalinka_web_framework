## Créé le 5/6/2020 ##

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
# Liste tous les commentaire d'une chaine HTML
##
proc BaseKalinka_HTML_liste_comm {html} {
    set debut 0
    set res [list]
    while {[string first "<!--" $html $debut] != -1} {
        set ouvre [string first "<!--" $html $debut]
        set ferme [expr [string first "-->" $html $ouvre] + 2]
        set comm [string range $html $ouvre $ferme]
        lappend res $comm
        set fin [expr $ferme + 1]
        set debut $fin
    }
    return $res
}

##
# Supprime tous les commentaire d'une chaine HTML
##
proc BaseKalinka_HTML_supp_comm {html} {
    set comms [BaseKalinka_HTML_liste_comm $html]
    foreach comm $comms {
        set html [string map [list $comm ""] $html]
    }
    return $html
}
