## Créé les 1/6/2020 ##

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
# Génère automatiquement un formulaire avec les données passées
# Ancien, ne plus utiliser
##
proc BaseKalinka_HTML_form_gen_a {nom action elements {methode "post"}} {
    set html "<form id=\"$nom\" action=\"$action\" methode=\"$methode\">"
    # Balayage des éléments
    foreach element $elements {
        set balise_element [dict get $element "element"]
        # Inputs
        if {$balise_element == "input"} {
            set nom_element [dict get $element "nom"]
            set type_element [dict get $element "type"]
            set valeur_element [dict get $element "val"]
            set plh_element [dict get $element "plh"]
            set element_html "<$balise_element type=\"$type_element\" name=\"$nom_element\" value=\"$valeur_element\" placeholder=\"$plh_element\" />"
        }
        set html "$html\n$element_html"
    }
    set html "$html\n<input type=\"submit\" />\n</form>"
    return $html
}

##
# Génère automatiquement un formulaire avec les données passées
# Structure de 'element' :
# [list \
#       [list \
#           'Type d'élément'
#           'Nom de l'élément'
#           ('Options de l'élément' [list 'options' ...] | pour les radios...)
#           ('Étiquette de description de l'élément' | optionnel)
#       ]
# ]
#
# Types d'éléments possible et leurs équivalents HTML :
#   string              <input type="text" />
#   string/pass         <input type="password" />
#   float               <input type="number" /> TODO
#   string/text         <textarea></textarea> TODO
#   list                <select/></select> TODO
#   radio              <input type="radio" />
#   check              <input type="checkbox" /> TODO
##
proc BaseKalinka_HTML_form_gen {nom_form action elements {methode "post"}} {
    set html "<form id=\"$nom_form\" action=\"$action\" methode=\"$methode\">"
    # Balayage des éléments
    foreach element $elements {
        set type_element [lindex $element 0]
        set nom_element [lindex $element 1]
        if {[llength $element] >= 3} {
            set etiquette_element [lindex $element 2]
        } else {
            set etiquette_element "null"
        }
        set sous_type_element [lindex [__BaseKalinka_HTML_form_sous_type__ $type_element] 1]
        set type_element [lindex [__BaseKalinka_HTML_form_sous_type__ $type_element] 0]
        # Construction de l'élément HTML du formulaire
        set element_html ""
        if {$type_element == "string" && $sous_type_element != "text"} {
            set element_html_tmp [BaseKalinka_HTML_form_input_gen $nom_form $element]
            set element_html "$element_html$element_html_tmp"
        # Boutons de type radio
        } elseif {$type_element == "radio"} {
            set element_html_tmp [BaseKalinka_HTML_form_radio_gen $nom_form $element]
            set element_html "$element_html$element_html_tmp"
        # Textarea
        } elseif {$type_element == "string" && $sous_type_element == "text"} {
            set element_html_tmp [BaseKalinka_HTML_form_textarea_gen $nom_form $element]
            set element_html "$element_html$element_html_tmp"
        # Select
        } elseif {$type_element == "liste"} {
            set element_html_tmp [BaseKalinka_HTML_form_select_gen $nom_form $element]
            set element_html "$element_html$element_html_tmp"
        }
        # Si étiquette
        if {$etiquette_element != "null"} {
            set element_html "\n<p class=\"f-$nom_form-etiquette\"><span>$etiquette_element</span>$element_html</p>"
        } else {
            set element_html "<p>$element_html</p>"
        }
        # Ajout de l'élément html au formulaire
        set html "$html$element_html"
    }
    set html "$html\n<p><input type=\"submit\" /></p>\n</form>"
    return $html
}

##
# Ne pas utiliser cette fonction, seul le framework doit s'en servir
##
proc __BaseKalinka_HTML_form_sous_type__ {type_element} {
    # Si / alors, on détermine le sous type de l'élément
    if {[string first "/" $type_element] != -1} {
        set tmp [split $type_element "/"]
        set type_element [lindex $tmp 0]
        set sous_type_element [lindex $tmp 1]
    } else {
        set sous_type_element "null"
    }
    return [list $type_element $sous_type_element]
}

proc BaseKalinka_HTML_form_input_gen {nom_form element} {
    set element_html ""
    set type_element [lindex $element 0]
    set sous_type_element [lindex [__Phosphore_HTML_form_sous_type__ $type_element] 1]
    set type_element [lindex [__Phosphore_HTML_form_sous_type__ $type_element] 0]
    set nom_element [lindex $element 1]
    # Détermine le type d'input
    switch $sous_type_element {
        null {set type "text"}
        pass {set type "password"}
        mail {set type "mail"}
    }
    set element_html "$element_html\n<input type=\"$type\" id=\"f-$nom_form-$nom_element\" name=\"$nom_element\" />"
}

proc BaseKalinka_HTML_form_radio_gen {nom_form element} {
    set element_html ""
    set type_element [lindex $element 0]
    set nom_element [lindex $element 1]
    set choix [lindex $element 3]
    set c 1
    # Balayage des choix
    foreach ch $choix {
        set nom_radio [lindex $ch 0]
        set val_radio [lindex $ch 1]
        set element_html "$element_html\n<p><input type=\"radio\" id=\"f-$nom_form-$nom_element-$c\" name=\"$nom_element\" value=\"$val_radio\" /><label for=\"f-$nom_form-$nom_element-$c\">$nom_radio</label></p>"
        set c [expr $c + 1]
    }
    return $element_html
}

proc BaseKalinka_HTML_form_textarea_gen {nom_form element} {
    set element_html ""
    set nom_element [lindex $element 1]
    set element_html "$element_html\n<textarea id=\"f-$nom_form-$nom_element\" name=\"$nom_element\"></textarea>"
    return $element_html
}

proc BaseKalinka_HTML_form_select_gen {nom_form element} {
    set element_html ""
    set type_element [lindex $element 0]
    set nom_element [lindex $element 1]
    set choix [lindex $element 3]
    set c 1
    # Balayage des choix
    set element_html "$element_html\n<select id=\"f-$nom_form-$nom_element\" name=\"$nom_element\">"
    foreach ch $choix {
        set nom_option [lindex $ch 0]
        set val_option [lindex $ch 1]
        set element_html "$element_html\n<option value=\"$val_option\">$nom_option</option>"
        set c [expr $c + 1]
    }
    set element_html "$element_html\n</select>"
    return $element_html
}
