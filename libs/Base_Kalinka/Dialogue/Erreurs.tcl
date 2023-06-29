## Créé les 30/5/2020 ##

######################################################
#  ___         __    __  ___         __   ___  ____  #
#  |__| |  |  /  \  /    |__| |  |  /  \  |__| |     #
#  |    |--| |    | ---- |    |--| |    | |\   |--   #
#  |    |  |  \__/  ___/ |    |  |  \__/  | \  |___  #
#                                                    #
######################################################

proc BaseKalinka_Erreur {message_erreur} {
    global PHCFG
    if {$PHCFG(ERR) == "o"} {
        if {$PHCFG(ERR_MODE) == 1} {
            BaseKalinka_Erreur_log $message_erreur
        } elseif {$PHCFG(ERR_MODE) == 2} {
            BaseKalinka_Erreur_puts $message_erreur
        } elseif {$PHCFG(ERR_MODE) == 1} {
            BaseKalinka_Erreur_log $message_erreur
            BaseKalinka_Erreur_puts $message_erreur
        }
    }
}

proc BaseKalinka_Erreur_log {message_erreur} {
    BaseKalinka_log $message_erreur
}

proc BaseKalinka_Erreur_puts {message_erreur} {
    puts "<code>$message_erreur</code>"
}
