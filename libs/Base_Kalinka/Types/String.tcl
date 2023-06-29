## Créé le 2/6/2020 ##

######################################################
#  ___         __    __  ___         __   ___  ____  #
#  |__| |  |  /  \  /    |__| |  |  /  \  |__| |     #
#  |    |--| |    | ---- |    |--| |    | |\   |--   #
#  |    |  |  \__/  ___/ |    |  |  \__/  | \  |___  #
#                                                    #
######################################################

#########################################################################
# BaseKalinka Framework TCL                                               #
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
# Test si une chaine contient du XML
##
proc BaseKalinka_String_XML_ {chaine} {
    set res 0
    if {[BaseKalinka_String_balise_ $chaine]} {
        set res 1
    }
    return $res
}

##
# Teste si une chaine contient des balises XML valides
##
proc BaseKalinka_String_balise_ {chaine} {
    set res 0
    set debut [string first "<" $chaine]
    set fin [string first ">" $chaine $debut]
    if {$debut != -1 && $fin != -1} {
        set contenu [string range $chaine [expr $debut + 1] [expr $fin - 1]]
        if {[string first "/$contenu" $chaine [expr $fin + 1]] != -1} {
            set res 1
        }
    }
    return $res
}
