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
#
##
proc BaseKalinka_GET {{var ""}} {
    global CONFIG
    
    set get [dict create]
    if {$CONFIG(ServeurHTTP) == "apache-rivet"} {
        set get [BaseKalinka_Apache_rivet_GET]
    }
    
    if {$var == ""} {
        return $get
    } else {
        return [dict get $get $var]
    }
}

proc BaseKalinka_GET_existe_ {var} {
    set res 0
    set vars [BaseKalinka_GET]
    if {[BaseKalinka_Dict_clef_existe_ $vars $var] == 1} {
        set res 1
    }
    return $res
}

##
# BaseKalinka_GET_existe_ version anglaise
##
proc BaseKalinka_GET_exists_ {var} {
    return [BaseKalinka_GET_existe_ $var]
}

##
#
##
proc BaseKalinka_POST {{var ""}} {
    global CONFIG
    
    set post [dict create]
    if {$CONFIG(ServeurHTTP) == "apache-rivet"} {
        set post [BaseKalinka_Apache_rivet_POST]
    }
    
    if {$var == ""} {
        return $post
    } else {
        return [dict get $post $var]
    }
}
