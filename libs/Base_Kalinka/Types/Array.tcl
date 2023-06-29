## Créé le 10/10/2020 ##

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
# Détermine si une clef existe dans un tableau
# Le tableau doit préalablement avoir été transmormé en liste : [array get Le_tableau]
##
proc BaseKalinka_Array_clef_existe_ {liste clef} {
    set res 0
    foreach {index valeur} $liste {
        if {$index == $clef} {
            set res 1
        }
    }
    return $res
}

##
# BaseKalinka_Array_clef_existe_ version anglaise
##
proc BaseKalinka_Array_key_exists_ {liste clef} {
    return [BaseKalinka_Array_clef_existe_ $liste $clef]
}
