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
# Fonction de démarrage du framework Phosphore destinée au développement de l'application
# ! La route d'index doit obligatoirement s'appeler "index"
##
proc BaseKalinka_Index_dev {} {
    # Charge l'index classique
    set html [BaseKalinka_Index]
    #BaseKalinka_Debug_analyse_HTML $html
    #BaseKalinka_Debug_analyse_HTML_dom $html
    # Ajout des paramètres de dévelopement
    #set html [BaseKalinka_Debug_web $html]
    # Affichage
    return $html
}
