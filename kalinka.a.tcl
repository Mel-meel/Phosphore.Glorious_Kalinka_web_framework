#!/usr/bin/env tclsh

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

# Répertoire racine du script
set rep_kalinka [file dirname [info script]]
# Répertoire racine de l'exécutable
#set rpr [file dirname [file normalize [info nameofexecutable]]]

set ph_rep "/home/era/Projets/Phosphore/tclproject/Phosphore"
set rep_actuel [pwd]

# Initialise la variable de commandes
set commande ""

proc contenu_fichier {fichier acces} {
    if {[file exists $fichier]} {
        set fp [open $fichier $acces]
        set file_data [read $fp]
        close $fp
    } else {
        puts "Le fichier \"$fichier\" n'existe pas"
    }
    return $file_data
}

proc gen_configs {configs} {
    set contenu ""
    foreach {k v} $configs {
        if {$k == "TCLPackages"} {
            #
        } else {
            set tmp "set CONFIG($k) \"$v\"\n"
        }
        set contenu "$contenu$tmp"
    }
    set contenu "$contenu\nset CONFIG(TCLPackages) \[list \"tdbc\" \"tdbc::\$CONFIG(SGBD)\"\]"
    return $contenu
}

proc gen_phcfg {phcfg} {
    set contenu ""
    foreach {k v} $phcfg {
        set tmp "set PHCFG($k) \"$v\"\n"
        set contenu "$contenu$tmp"
    }
    return $contenu
}

##
# Créé une nouvelle application dans le répertoire actuel
##
proc creer_app {nom configs phcfg} {
    global ph_rep
    global rep_actuel
    global rep_kalinka
    global nom_app
    
    set nom_app $nom
    
    file mkdir "Actions" $rep_actuel
    file mkdir "Actions/AJAX" $rep_actuel
    file mkdir "Routes" $rep_actuel
    file mkdir "C" $rep_actuel
    file mkdir "Templates" $rep_actuel
    file mkdir "contenu" $rep_actuel
    file mkdir "configs" $rep_actuel
    file mkdir "scripts" $rep_actuel
    file mkdir "scripts/Actions" $rep_actuel
    file mkdir "styles" $rep_actuel
    file mkdir ".phosphore" $rep_actuel
    file mkdir ".phosphore/models" $rep_actuel
    file mkdir "DEP" $rep_actuel
    file mkdir "Base" $rep_actuel
    file mkdir "Base/Models" $rep_actuel
    # Copie des CSS
    file copy "$rep_kalinka/libs/Sergei.css" "$rep_actuel/styles/Sergei.css"
    file copy "$rep_kalinka/models/app.css" "$rep_actuel/styles/app.css"
    # Copie des bibliothèques JS
    file copy "$rep_kalinka/libs/Prototype.js" "$rep_actuel/scripts/Prototype.js"
    file copy "$rep_kalinka/models/app.js" "$rep_actuel/scripts/app.js"
    # Copie du logo du Phosphore
    file copy "$rep_kalinka/models/phosphore_logo.png" "$rep_actuel/contenu/phosphore_logo.png"
    #file mkdir "models" "$rep_actuel/.phosphore"
    # Copie des models
    file copy "$rep_kalinka/models/route.tcl" "$rep_actuel/.phosphore/models/route.tcl"
    file copy "$rep_kalinka/models/route.html" "$rep_actuel/.phosphore/models/route.html"
    # Copie de la base vierge si SQLite est choisi
    if {[dict get $configs "SGBD"] == "sqlite"} {
        file copy "$rep_kalinka/models/base.db" "$rep_actuel/Base/$nom_app.db"
    }
    # Génération des configurations
    set cfgcontenu [gen_phcfg $phcfg]
    set cfg [open "$rep_actuel/configs/Phosphore.cfg" w+]
    puts $cfg $cfgcontenu
    close $cfg
    set cfgcontenu [gen_configs $configs]
    set cfg [open "$rep_actuel/configs/general.tcl" w+]
    puts $cfg $cfgcontenu
    close $cfg
    # Copie de l'index de base de l'application
    file copy "$rep_kalinka/models/index.tcl" "$rep_actuel/index.tcl"
    # Script des EventListener
    set eventsjs [open "$rep_actuel/scripts/EventListeners.js" w+]
    puts $eventsjs "// Phosphore Framework TCL"
    close $eventsjs
    # Fichier contenant le nom de l'application, nécessaire pour Kalinka
    set k [open "$rep_actuel/.phosphore/kalinka" w+]
    puts $k $nom
    close $k
    if {![file exists "$rep_actuel/Phosphore"]} {
        file copy $ph_rep $rep_actuel
    }
    # Main
    file copy "$rep_kalinka/models/Main.tcl" "$rep_actuel/Routes/Main.tcl"
    file copy "$rep_kalinka/models/Main.html" "$rep_actuel/Templates/Main.html"
    ajouter_route "index"
    puts "L'application '$nom' à été créée."
}

##
# Ajout d'une nouvelle route à l'application
##
proc ajouter_route {nom} {
    global ph_rep
    global rep_actuel
    global rep_kalinka
    global projet
    global nom_app
    
    if {$projet == 1} {
        # Si les models existent dans le dossier .phosphore, copie
        # Fichier de route
        if {[file exists "$rep_actuel/.phosphore/models/route.tcl"]} {
            set rep_route "$rep_actuel/.phosphore/models/route.tcl"
        }
        # Template de la route
        if {[file exists "$rep_actuel/.phosphore/models/route.html"]} {
            set rep_template "$rep_actuel/.phosphore/models/route.html"
        }
    } else {
        set rep_route "$rep_kalinka/models/route.tcl"
        set rep_template "$rep_kalinka/models/route.html"
    }
    
    # Copie les fichiers
    #file copy $rep_route "$rep_actuel/Routes/$nom.tcl"
    set ROUTE [contenu_fichier $rep_route r]
    #file copy $rep_template "$rep_actuel/Templates/$nom.html"
    set TEMPLATE [contenu_fichier $rep_template r]
    
    set route [open "$rep_actuel/Routes/$nom.tcl" w+]
    puts $route [string map [list "ROUTE" $nom] $ROUTE]
    close $route
    
    set template [open "$rep_actuel/Templates/$nom.html" w+]
    puts $template [string map [list "APP" $nom_app] [string map [list "ROUTE" $nom] $TEMPLATE]]
    close $template
    
    # On parle :D
    if {$nom != "index"} {
        puts "La route '$nom' à correctement été ajoutée."
    }
}

##
# Ajoute une nouvelle action
##
proc ajouter_action {nom route ajax} {
    global ph_rep
    global rep_actuel
    global rep_kalinka
    global projet
    global nom_app
    puts "ACTION!! $nom $route $ajax"
    # Si AJAX est utilisé pour cette action
    if {$ajax == 1} {
        # Créé le JS de l'action
        set JS [contenu_fichier "$rep_kalinka/models/action.js" r]
        set js [open "$rep_actuel/scripts/Actions/$nom.js" w+]
        puts $js [string map [list "@PARAMETRES@" "// Ici les paramètres POST"] [string map [list "@ACTION@" $nom] $JS]]
        close $js
        set ACTION [contenu_fichier "$rep_kalinka/models/action_ajax.tcl" r]
        set action [open "$rep_actuel/Actions/AJAX/$nom.tcl" w+]
        close $action
    }
}

##
# Déploiement de l'application
##
proc deployer_app {} {
    global ph_rep
    global rep_actuel
    global rep_kalinka
    global projet
    global nom_app
    
    if {$projet == 1} {
        # Liste tous les builds
        set builds [glob -nocomplain -dir "$rep_actuel/DEP" "build*"]
        set c_builds [expr [llength $builds] + 1]
        # Créé un dossier de build
        file mkdir "$rep_actuel/DEP/build$c_builds" $rep_actuel
        set rep_build "$rep_actuel/DEP/build$c_builds/"
        # Copie des fichiers
        file copy "$rep_actuel/Actions" $rep_build
        file copy "$rep_actuel/Base" $rep_build
        file copy "$rep_actuel/C" $rep_build
        file copy $ph_rep $rep_build
        file copy "$rep_actuel/Routes" $rep_build
        file copy "$rep_actuel/Templates" $rep_build
        file copy "$rep_actuel/configs" $rep_build
        file copy "$rep_actuel/contenu" $rep_build
        file copy "$rep_actuel/scripts" $rep_build
        file copy "$rep_actuel/styles" $rep_build
        file copy "$rep_actuel/index.tcl" $rep_build
    } else {
        puts "Aucune application n'a été détectée dans ce répertoire.\nCréer une application avec la commande suivante :\nkalinka mk app <Le nom de l'application>"
    }
    puts "L'application à été correctement déployée dans :\n$rep_build"
}

proc supp_espaces {commande} {
    set debut 0
    while {[string first "  " $commande $debut] != -1} {
        set debut [expr [string first "  " $commande $debut] + 1]
        string map {"  " " "} $commande
    }
    return $commande
}

proc def_args {commande} {
    set args [split $commande " "]
    return $args
}

proc analyse {commande} {
    global projet
    global rep_actuel
    
    set commande [supp_espaces $commande]
    set args [def_args $commande]
    
    # Création, ajout
    if {[lindex $args 0] == "mk"} {
        if {[lindex $args 1] == "app"} {
            if {$projet == 0} {
                set nom_app [lindex $args 2]
                # Paramètres de l'application
                if {[lsearch -exact $args "-n-config"] == 3} {
                    set configs [dict create]
                    set phcfg [dict create]
                } elseif {[lsearch -exact $args "-d-config"] == 3} {
                    set configs [dict create "ServeurHTTP" "apache-rivet" "Nom" $nom_app "SGBD" "sqlite" "Base" "Base/$nom_app.db" ]
                    set phcfg [dict create "ERR" "o" "ERR_MODE" "2" "APP_MODE" "dev"]
                } else {
                    dict set configs "ServeurHTTP" "apache-rivet"
                    dict set configs "Nom" $nom_app
                    # Base de donnée
                    puts -nonewline "SGBD de l'application (SQLite|MySQL|PostgreSQL|Oracle|SQLServer|Firebird) : "
                    flush stdout
                    dict set configs "SGBD" [gets stdin]
                    # Nom de la base
                    puts -nonewline "Nom de la base à utiliser : "
                    flush stdout
                    dict get configs "Base" [gets stdin]
                }
                creer_app $nom_app $configs $phcfg
            } else {
                puts "Oups!\nUne application à déjà été créée dans ce répertoire"
            }
        # Ajouter d'une nouvelle route
        } elseif {[lindex $args 1] == "route"} {
            if {$projet == 1} {
                set nom_route [lindex $args 2]
                ajouter_route $nom_route
            } else {
                puts "Aucune application n'a été détectée dans ce répertoire.\nCréer une application avec la commande suivante :\nkalinka mk app <Le nom de l'application>"
            }
        # Ajouter d'une nouvelle action
        } elseif {[lindex $args 1] == "action"} {
            if {$projet == 1} {
                # Nom de l'action à ajouter
                set nom_action [lindex $args 2]
                # Si une route est liée à cette action
                if {[lsearch -exact $args "-route"] >= 3} {
                    set route [lindex $args [expr [lsearch -exact $args "-route"] + 1]]
                    # Si il manque un élément de la route spécifiée en arguments, erreur et quitte
                    if {![file exists "$rep_actuel/Routes/$route.tcl"] || ![file exists "$rep_actuel/Templates/$route.html"]} {
                        puts "Il manque un composant de la route spécifiée."
                        exit
                    }
                } else {
                    set route "null"
                }
                # Si l'action n'est pas en AJAX
                if {[lsearch -exact $args "-n-ajax"] >= 3} {
                    set ajax 0
                } else {
                    set ajax 1
                }
                ajouter_action $nom_action $route $ajax
            } else {
                puts "Aucune application n'a été détectée dans ce répertoire.\nCréer une application avec la commande suivante :\nkalinka mk app <Le nom de l'application>"
            }
        }
    # Rélatif à l'application présente
    } elseif {[lindex $args 0] == "app"} {
        if {[lindex $args 1] == "dep"} {
            if {$projet == 1} {
                deployer_app
            } else {
                puts "Aucune application n'a été détectée dans ce répertoire.\nCréer une application avec la commande suivante :\nkalinka mk app <Le nom de l'application>"
            }
        }
    # Quitter
    } elseif {[lindex $args 0] == "q"} {
        puts "Aurevoir!"
    } else {
        puts "Commande inconnue"
    }
}

# Démarrage du programme
# Détermine si le répertoire actuel est la racine du projet
if {[file exists "$rep_actuel/.phosphore/kalinka"]} {
    set projet 1
    set nom_app [string map [list "\n" ""] [contenu_fichier "$rep_actuel/.phosphore/kalinka" r]]
} else {
    set projet 0
}

if {$::argc == 0} {
    while {$commande != "q"} {
        puts -nonewline "Kalinka > "
        flush stdout
        set commande [gets stdin]
    }
} else {
    set commande $argv
}
analyse $commande
