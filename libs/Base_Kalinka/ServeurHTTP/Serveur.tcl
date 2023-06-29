## Créé les 4/10/2020 ##

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

proc BaseKalinka_ServeurHTTP_ENV {var} {
    global CONFIG
    
    set res "ERR"
    if {$CONFIG(ServeurHTTP) == "apache-rivet"} {
        set en [BaseKalinka_Apache_rivet_load_env]
        if {$var == "url"} {
            set env "REQUEST_URI"
        }
        set res [dict get $en $env]
    }
    
    return $res
}

proc BaseKalinka_ServeurHTTP_chemin_index {} {
    set url [BaseKalinka_ServeurHTTP_ENV "url"]
    set fin [expr [string first "index.tcl" $url] - 1]
    set chemin [string range $url 0 $fin]
    
    return $chemin
}
