## Créé les 30/5/2020 ##

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

# RQ : Phosphore/Dialogue/Erreurs.tcl

##
# Lis le contenu d'un fichier
##
proc BaseKalinka_Fichier_contenu {fichier acces} {
    if {[file exists $fichier]} {
        set fp [open $fichier $acces]
        set file_data [read $fp]
        close $fp
    } else {
        Phosphore_erreur "Le fichier \"$fichier\" n'existe pas"
    }
    return $file_data
}

##
# BaseKalinka_Fichier_contenu version anglaise
##
proc BaseKalinka_File_read_content {fichier acces} {
    return [BaseKalinka_Fichier_contenu $fichier $acces]
}

proc BaseKalinka_Fichier_ecrire {fichier acces contenu} {
    if {[file exists $fichier]} {
        set fp [open $fichier $acces]
        puts $fp $contenu
        close $fp
    } else {
        Phosphore_erreur "Le fichier \"$fichier\" n'existe pas"
    }
}

##
# BaseKalinka_Fichier_ecrire version anglaise
##
proc BaseKalinka_File_write {fichier acces contenu} {
    return [BaseKalinka_Fichier_ecrire $fichier $acces $contenu]
}

proc BaseKalinka_Fichier_creer {fichier} {
    if {![file exists $fichier]} {
        set fp [open $fichier w+]
        close $fp
        set res 1
    } else {
        set res 0
    }
    return $res
}

##
# BaseKalinka_Fichier_creer version anglaise
##
proc BaseKalinka_File_create {fichier} {
    return [BaseKalinka_Fichier_creer $fichier]
}
