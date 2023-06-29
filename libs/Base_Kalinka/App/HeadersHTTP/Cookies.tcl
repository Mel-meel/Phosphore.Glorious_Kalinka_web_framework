## Créé le 29/5/2020 ##

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
# Charge les cookies transmis par le client dans un dictionnaire
##
proc BaseKalinka_Cookies_get_cookies {} {
    global CONFIG
    
    set cookies [dict create]
    # Si Apache Rivet
    if {$CONFIG(ServeurHTTP) == "apache-rivet"} {
        set cookies [BaseKalinka_Apache_rivet_get_cookies]
    }
    return $cookies
}

##
# Charge la valeur du cookie demandé
##
proc BaseKalinka_Cookies_get_cookie {cookie} {
    return [dict get [BaseKalinka_Cookies] $cookie]
}

##
# Créé ou met à jour un cookie existant
##
proc BaseKalinka_Cookies_set_cookie {nom valeur} {
    global CONFIG
    
    # Si Apache Rivet
    if {$CONFIG(ServeurHTTP) == "apache-rivet"} {
        BaseKalinka_Apache_rivet_set_cookie $nom $valeur
    }
}
