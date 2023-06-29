#!/usr/bin/env tclsh

## Créé les 9/10/2020 ##

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

#package require tdbc::mysql
#package require tdbc::sqlite3

# Répertoire racine du script
set rep_kalinka [file dirname [info script]]
# Répertoire racine de l'exécutable
#set rpr [file dirname [file normalize [info nameofexecutable]]]

set rep_ph "$rep_kalinka/libs/Base_Kalinka"
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
        set tmp "$k:$v\n"
        set contenu "$contenu$tmp"
    }
    return $contenu
}

proc get_phcfg {} {
    global rep_actuel
    
    set phcfg [dict create]
    set contenu [contenu_fichier "$rep_actuel/configs/Phosphore.cfg" "r"]
    foreach element [list "ERR" "ERR_MODE" "APP_MODE" "MODE_REWRITE"] {
        set valeur [string range $contenu [expr [string first $element $contenu] + [string length $element] + 1] [expr [string first "\n" $contenu [string first $element $contenu]] - 1]]
        dict set phcfg $element $valeur
    }
    set routes [string range $contenu [expr [string first "\{" $contenu [string first "ROUTES" $contenu]] + 0] [expr [string first "\}" $contenu [string first "ROUTES" $contenu]] - 0]]
    dict set phcfg "ROUTES" $routes
    return $phcfg
}

##
# Créé une nouvelle application dans le répertoire actuel
##
proc Kalinka_creer_app {nom configs phcfg} {
    global rep_ph
    global rep_actuel
    global rep_kalinka
    global nom_app
    
    set nom_app $nom
    
    file mkdir "sources" $rep_actuel
    file mkdir "Templates" $rep_actuel
    file mkdir "sources/Routes" $rep_actuel
    file mkdir "contenu" $rep_actuel
    file mkdir "configs" $rep_actuel
    file mkdir "scripts" $rep_actuel
    file mkdir "scripts/Actions" $rep_actuel
    file mkdir "styles" $rep_actuel
    file mkdir ".phosphore" $rep_actuel
    file mkdir "DEP" $rep_actuel
    if {[dict get $configs "SGBD"] != "non"} {
        file mkdir "Base" $rep_actuel
        file mkdir "Base/Models" $rep_actuel
    }
    # Si les sessions sont gérées par fichiers
    if {[dict get $configs "Session_type"] == "locale"} {
        file mkdir "var" $rep_actuel
        file mkdir "var/sessions" $rep_actuel
    }
    file mkdir "libs" $rep_actuel
    # Copie des bibliothèques externes à Lib_Kalinka
    # SHA1
    file copy "$rep_kalinka/libs/sha1" "$rep_actuel/libs/sha1"
    # Copie des CSS
    file copy "$rep_kalinka/libs/Polyushka.css" "$rep_actuel/styles/Polyushka.css"
    # Copie des bibliothèques JS
    file copy "$rep_kalinka/libs/Prototype.js" "$rep_actuel/scripts/Prototype.js"
    # Copie du logo du Phosphore
    file copy "$rep_kalinka/models/kalinka_logo.png" "$rep_actuel/contenu/kalinka_logo.png"
    # Copie des models
    #file copy "$rep_kalinka/models/route.tcl" "$rep_actuel/.phosphore/models/route.tcl"
    #file copy "$rep_kalinka/models/route.html" "$rep_actuel/.phosphore/models/route.html"
    # Copie de la base vierge si SQLite est choisi
    if {[dict get $configs "SGBD"] == "sqlite"} {
        file copy "$rep_kalinka/models/base.db" "$rep_actuel/Base/[dict get $configs Base].db"
    }
    # Fichier de sources de l'application, à remplir par l'utilisateur
    set sources [open "$rep_actuel/configs/sources.tcl" w+]
    puts $sources "# Sources de l'application"
    close $sources
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
    file copy "$rep_kalinka/models/index_dev.tcl" "$rep_actuel/index.tcl"
    # Script des EventListener
    set eventsjs [open "$rep_actuel/scripts/EventListeners.js" w+]
    puts $eventsjs "// Kalinka Framework TCL"
    close $eventsjs
    # Fichier contenant le nom de l'application, nécessaire pour Kalinka
    set k [open "$rep_actuel/.phosphore/kalinka" w+]
    puts $k $nom
    close $k
    if {![file exists "$rep_actuel/libs/Base_Kalinka"]} {
        file copy $rep_ph "$rep_actuel/libs/Base_Kalinka"
    }
    # Main
    file copy "$rep_kalinka/models/Main.tcl" "$rep_actuel/sources/Routes/Main.tcl"
    file copy "$rep_kalinka/models/Main.html" "$rep_actuel/Templates/Main.html"
    Kalinka_ajouter_route "/index" "index"
    Kalinka_ajouter_route "/404" "404"
    puts "L'application '$nom' à été créée."
}

##
# Ajout d'une nouvelle route à l'application
##
proc Kalinka_ajouter_route {chemin nom} {
    global ph_rep
    global rep_actuel
    global rep_kalinka
    global projet
    global nom_app
    
    set phcfg [get_phcfg]
    
    # Ajout de la route dans les configurations
    set routes [dict get $phcfg "ROUTES"]
    set routes [string map -nocase [list "\}" "($chemin):($nom)\n\}"] $routes]
    dict set phcfg "ROUTES" $routes
    # Génération des configurations
    set cfgcontenu [gen_phcfg $phcfg]
    set cfg [open "$rep_actuel/configs/Phosphore.cfg" w+]
    puts $cfg $cfgcontenu
    close $cfg
    
    set rep_route "$rep_kalinka/models/route.tcl"
    set rep_template "$rep_kalinka/models/route.html"
    
    # Copie les fichiers
    set ROUTE [contenu_fichier $rep_route r]
    set TEMPLATE [contenu_fichier $rep_template r]
    
    set route [open "$rep_actuel/sources/Routes/$nom.tcl" w+]
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

##
# Affiche la question passée en paramètre, et attends la réponse de l'utilisateur dans un terminal
##
proc Kalinka_question {question} {
    puts -nonewline $question
    flush stdout
    return [gets stdin]
}

##
# Analyse une commande
##
proc Kalinka_analyse {commande} {
    global projet
    global rep_actuel
    
    set commande [supp_espaces $commande]
    set args [def_args $commande]
    
    # Création, ajout
    if {[lindex $args 0] == "mk"} {
        if {[lindex $args 1] == "app"} {
            if {$projet == 0} {
                set nom_app [lindex $args 2]
                set nom_app [string map {"\_" " "} $nom_app]
                # Paramètres de l'application
                if {[lsearch -exact $args "-n-config"] == 3} {
                    set configs [dict create]
                    set phcfg [dict create]
                } elseif {[lsearch -exact $args "-d-config"] == 3} {
                    set configs [dict create "ServeurHTTP" "apache-rivet" "Nom" $nom_app "SGBD" "sqlite" "Base" $nom_app "Routage" "2"]
                    set phcfg [dict create "ERR" "o" "ERR_MODE" "2" "APP_MODE" "dev" "MODE_REWRITE" "n" "ROUTES" "\{\n(/):(index)\n\}"]
                } else {
                    set phcfg [dict create "ERR" "o" "ERR_MODE" "2" "APP_MODE" "dev" "MODE_REWRITE" "n" "ROUTES" "\{\n(/):(index)\n\}"]
                    # Type de serveur
                    dict set configs "ServeurHTTP" "apache-rivet"
                    dict set configs "Routage" "2"
                    # Nom de l'application
                    dict set configs "Nom" $nom_app
                    # Type de session, par défaut en local dans des fichiers texte
                    dict set configs "Session_type" "locale"
                    # Nom de la session, par défaut celui de l'application
                    dict set configs "Session_nom" "$nom_app\_sessID"
                    # Base de donnée
                    dict set configs "SGBD" [string tolower [Kalinka_question "SGBD de l'application (SQLite|MySQL|PostgreSQL|Oracle|SQLServer|aucun) : "]]
                    if {[dict get $configs "SGBD"] == "aucun"} {
                        dict set configs "SGBD" "non"
                    } else {
                        # Nom de la base
                        dict set configs "Base" [Kalinka_question "Nom de la base à utiliser : "]
                        # Utilisateur de la base de données et mot de passe si nécessaire
                        if {[dict get $configs "SGBD"] != "sqlite"} {
                            # Utilisateur
                            dict set configs "U" [Kalinka_question "Utilisateur de la base de donnée : "]
                            # Mot de passe
                            dict set configs "mdp" [Kalinka_question "Mot de passe : "]
                        }
                    }
                }
                Kalinka_creer_app $nom_app $configs $phcfg
            } else {
                puts "Oups!\nUne application à déjà été créée dans ce répertoire"
            }
        } elseif {[lindex $args 1] == "route"} {
            if {$projet == 0} {
                puts "Aucune application n'a été détectée dans ce répertoire.\nCréer une application avec la commande suivante :\nkalinka mk app <Le nom de l'application>"
            } else {
                set chemin_route [lindex $args 2]
                set nom_route [lindex $args 3]
                if {$chemin_route != "" || $nom_route != ""} {
                    Kalinka_ajouter_route $chemin_route $nom_route
                }
            }
        }
    } elseif {[lindex $args 0] == "bdd"} {
        if {[lindex $args 1] == "migration"} {
            Kalinka_BDD_migration
        }
    } elseif {[lindex $args 0] == "configure"} {
        if {[lindex $args 1] == "sessions"} {
            Kalinka_configure_sessions
        }
    } elseif {[lindex $args 0] == "app"} {
        if {[lindex $args 1] == "dep"} {
            Kalinka_app_dep
        }
    } else {
        puts "Commande inconnue."
    }
}

#########################################################################
#                                                                       #
#                 COMMANDES DE LA BASE DE DONNÉES                       #
#                                                                       #
#########################################################################

##
# Implémente le modèle passé en paramètre
##
proc Kalinka_BDD_migration_model {model} {
    puts $model
}

##
# Implémente les modèles dans la base  de donnée
##
proc Kalinka_BDD_migration {} {
    global projet
    global rep_actuel
    
    if {$projet == 1} {
        # Liste tous les fichiers XML du dossier Base/Models
        set models [glob -nocomplain -dir "$rep_actuel/Base/Models/" "*.xml"]
        foreach model $models {
            Kalinka_BDD_migration_model $model
        }
    } else {
        puts "Aucune application n'a été détectée dans ce répertoire.\nCréer une application avec la commande suivante :\nkalinka mk app <Le nom de l'application>"
    }
}

#########################################################################
#                                                                       #
#             COMMANDES DE CONFIGURATION DES SESSIONS                   #
#                                                                       #
#########################################################################

proc Kalinka_configure_sessions {} {
    set phcfg [get_phcfg]
    puts $phcfg
}

#########################################################################
#                                                                       #
#                   DÉPLOIEMENT DE L'APPLICATION                        #
#                                                                       #
#########################################################################

proc Kalinka_app_dep {} {
    global nom_app
    global rep_actuel
    global rep_ph
    global rep_kalinka
    
    set rep_dep "$rep_actuel/DEP"
    
    # Construction des routes
    set routes_txt ""
    set index_contenu [contenu_fichier "$rep_kalinka/models/index_prod.tcl" r]
    set phcfg [get_phcfg]
    set pos [string first "ROUTES" $phcfg]
    # Lecture des routes
    set routes [string range $phcfg [expr [string first "\{" $phcfg $pos] + 3] [expr [string first "\}" $phcfg $pos] - 2]]
    foreach route [split $routes "\n"] {
        set route [split $route ":"]
        if {$routes_txt == ""} {
            set routes_txt "$routes_txt\# Routes\nif \{\$route == \"[string range [lindex $route 0] 1 [expr [string length [lindex $route 0]] - 2 ]]\"\} \{\n    set ROUTE \"[string range [lindex $route 1] 1 [expr [string length [lindex $route 1]] - 2 ]]\"\n"
        } else {
            set routes_txt "$routes_txt\} elseif \{\$route == \"[string range [lindex $route 0] 1 [expr [string length [lindex $route 0]] - 2 ]]\"\} \{\n    set ROUTE \"[string range [lindex $route 1] 1 [expr [string length [lindex $route 1]] - 2 ]]\"\n"
        }
        #set routes_txt "$routes_txt\set ROUTES([string range [lindex $route 0] 1 [expr [string length [lindex $route 0]] - 2 ]]) [string range [lindex $route 1] 1 [expr [string length [lindex $route 1]] - 2 ]]\n"
    }
    set routes_txt "$routes_txt\} else \{\n    set route \"/404\"\n    set ROUTE \"404\"\n\}"
    #set routes_txt "$routes_txt\nset ROUTE \$ROUTES(\$route)"
    set index_contenu [string map [list "@ROUTES@" $routes_txt] $index_contenu]
    set index [open "$rep_dep/index.tcl" w+]
    puts $index $index_contenu
    close $index
    
    file copy "$rep_actuel/configs" "$rep_dep/configs"
    file copy "$rep_actuel/C" "$rep_dep/C"
    file copy "$rep_actuel/Libs" "$rep_dep/Libs"
    file copy "$rep_actuel/contenu" "$rep_dep/contenu"
    file copy "$rep_actuel/Routes" "$rep_dep/Routes"
    file copy "$rep_actuel/scripts" "$rep_dep/scripts"
    file copy "$rep_actuel/styles" "$rep_dep/styles"
    file copy "$rep_actuel/Templates" "$rep_dep/Templates"
    file copy "$rep_actuel/Libs/Lib_Kalinka/Sources_dev.tcl" "$rep_dep/configs/sources.tcl"
}

#########################################################################
#                                                                       #
#                     EXÉCUTION DU PROGRAMME                            #
#                                                                       #
#########################################################################

# Démarrage du programme
# Détermine si le répertoire actuel est la racine du projet
if {[file exists "$rep_actuel/.phosphore/kalinka"]} {
    set projet 1
    set nom_app [string map [list "\n" ""] [contenu_fichier "$rep_actuel/.phosphore/kalinka" "r"]]
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
Kalinka_analyse $commande
