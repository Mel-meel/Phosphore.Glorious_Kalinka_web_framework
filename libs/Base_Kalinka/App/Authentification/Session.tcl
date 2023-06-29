## Créé les 29/5/2020 ##

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
# Créé un ID de session si le cookie de session n'existe pas, sinon récupère l'ID du cookie de session
##
proc BaseKalinka_Session_id {{session_nom "Kalinka"}} {
    # Chargement des cookies
    set cookies [BaseKalinka_Cookies_get_cookies]
    # Si le tableau des cookies existe
    if {[dict exists $cookies $session_nom]} {
        # Récupère la valeur du cookie de session
        set valeur [dict get $cookies $session_nom]
    } else {
        # ID aléatoire pour la session
        set valeur [expr int([expr rand() * 1000000000000000000])]
        # Création du cookie de session
        BaseKalinka_Cookies_set_cookie $session_nom $valeur
    }
    return $valeur
}

##
# Démarre une session
##
proc BaseKalinka_Session_start {{session_nom "Kalinka"}} {
    global CONFIG
    
    set id [BaseKalinka_Session_id $session_nom]
    
    # Si les sessions sont gérées pas fichiers
    if {$CONFIG(Session_type) == "locale"} {
        set res [BaseKalinka_Fichier_creer "var/sessions/$id"]
    }
    return $id
}

##
# Lis une variable de session
##
proc BaseKalinka_Session_varo {var} {
    global SESSION
    global CONFIG
    
    # Si les sessions sont gérées pas fichiers
    if {$CONFIG(Session_type) == "locale"} {
        set contenu [BaseKalinka_Fichier_contenu "var/sessions/$SESSION" "r"]
        set vars [split $contenu ";;"]
        # Recherche la variable souhaitée
        foreach sess_var $vars {
            set sess_var_nom [lindex [split $sess_var "::"] 0]
            set sess_var_valeur [lindex [split $sess_var "::"] 2]
            if {$sess_var_nom == $var} {
                set res $sess_var_valeur
            }
        }
    }
    return $res
}

##
# Écris une variable de session
##
proc BaseKalinka_Session_vari {var val} {
    global SESSION
    global CONFIG
    
    set session [dict create]
    dict set session $var $val
    
    # Si les sessions sont gérées pas fichiers
    if {$CONFIG(Session_type) == "locale"} {
        set contenu [BaseKalinka_Fichier_contenu "var/sessions/$SESSION" "r"]
        set vars [split $contenu ";;"]
        # Recherche la variable souhaitée
        foreach sess_var $vars {
            if {$sess_var != "" && $sess_var != "\n" && $sess_var != " "} {
                set sess_var_nom [lindex [split $sess_var "::"] 0]
                set sess_var_valeur [lindex [split $sess_var "::"] 2]
                if {$sess_var_nom != $var} {
                    dict set session $sess_var_nom $sess_var_valeur
                }
            }
        }
        # Reconstruit le fichier de session
        set contenu ""
        foreach {k v} $session {
            if {$k != "\n" && $k != "" && $k != " "} {
                set contenu "$contenu$k\::$v;;"
            }
        }
        BaseKalinka_Fichier_ecrire "var/sessions/$SESSION" "w" $contenu
    }
}

##
# Détruit une session
##
proc BaseKalinka_Session_stop {{session_nom "Kalinka"}} {

}

