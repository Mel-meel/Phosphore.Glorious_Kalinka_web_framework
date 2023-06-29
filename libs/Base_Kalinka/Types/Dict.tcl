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

proc BaseKalinka_Dict_ {d} {
    set res 0
    if {[string is list $d] && [expr [llength $d] % 2] == 0} {
        set res 1
    }
    return $res
}

proc BaseKalinka_Dict_clef_existe_ {dic clef} {
    set res 0
    foreach {k v} $dict {
        if {$k == $clef} {
            set res 1
        }
    }
    return $res
}

##
# BaseKalinka_Dict_clef_existe_ version anglaise
##
proc BaseKalinka_Dict_key_exists_ {dic clef} {
    return [BaseKalinka_Dict_clef_existe_ $dic $clef]
}
