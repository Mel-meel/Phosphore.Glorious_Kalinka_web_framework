## Créé le 4/6/2020 ##

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

proc BaseKalinka_Debug_web {html} {
    global ERREURS
    set err 0
    
    set err_html [llength [dict get $ERREURS "HTML"]]
    set err_sql [llength [dict get $ERREURS "SQL"]]
    set err_ajax [llength [dict get $ERREURS "AJAX"]]
    
    set err [expr $err_html + $err_sql + $err_ajax]
    set err_html " ($err_html)"
    set err_sql " ($err_sql)"
    set err_ajax " ($err_ajax)"
    # Si au moins une erreur, on affiche
    if {$err > 0} {
        set erreurs "<span style=\"background : \white ; padding : 0.6em ; text-decoration : none ;\"><span style=\"color : red ; font-size : 150% ;\">$err</span><span style=\"color : #23433D ;\"> erreur(s)</span></span>"
    } else {
        set erreurs ""
    }
    # Affichage erreurs
    set err_html_html ""
    foreach e [dict get $ERREURS "HTML"] {
        set err_html_html "$err_html_html\n<p style=\"background : #FF9999 ; padding : 0.4em ;\">$e</p>"
    }
    set err_sql_html ""
    foreach e [dict get $ERREURS "SQL"] {
        set err_sql_html "$err_sql_html\n<p style=\"background : #FF9999 ; padding : 0.4em ;\">$e</p>"
    }
    set err_ajax_html ""
    foreach e [dict get $ERREURS "AJAX"] {
        set err_ajax_html "$err_ajax_html\n<p style=\"background : #FF9999 ; padding : 0.4em ;\">$e</p>"
    }
    set console "
<div id=\"ph-debug\">
<div style=\"background : \#45655F ; color : white ; padding : 0.5% ;\">

<p>Kalinka Framework TCL Debug</p>
<p>
$erreurs
<a style=\"background : \#23433D ; padding : 1em ; color : white ; text-decoration : none ;\" href=\"#ph-debug\" onclick=\"document.getElementById('ph-debug-html').style.display = 'block' ; document.getElementById('ph-debug-sql').style.display = 'none' ; document.getElementById('ph-debug-ajax').style.display = 'none' ;\">HTML$err_html</a>
<a style=\"background : \#23433D ; padding : 1em ; color : white ; text-decoration : none ;\" href=\"#ph-debug\" onclick=\"document.getElementById('ph-debug-html').style.display = 'none' ; document.getElementById('ph-debug-sql').style.display = 'block' ; document.getElementById('ph-debug-ajax').style.display = 'none' ;\">SQL$err_sql</a>
<a style=\"background : \#23433D ; padding : 1em ; color : white ; text-decoration : none ;\" href=\"#ph-debug\" onclick=\"document.getElementById('ph-debug-html').style.display = 'none' ; document.getElementById('ph-debug-sql').style.display = 'none' ; document.getElementById('ph-debug-ajax').style.display = 'block' ;\">AJAX$err_ajax</a>
</p>
</div>
<div id=\"ph-debug-html\" style=\"border : 2px solid #23433D ; background : white ; color : #23433D ; padding : 0px ; display : block ;\">
<p>HTML de l'application :</p>
$err_html_html
</div>
</div>
<div id=\"ph-debug-sql\" style=\"border : 2px solid #23433D ; background : white ; color : #23433D ; padding : 0px ; display : none ;\">
<p>SQL de l'application :</p>
$err_sql_html
</div>
</div>
<div id=\"ph-debug-ajax\" style=\"border : 2px solid #23433D ; background : white ; color : #23433D ; padding : 0px ; display : none ;\">
<p>AJAX de l'application :</p>
$err_ajax_html
</div>
</div>
"
    if {[string first "</body>" $html] != -1} {
        set res [string map [list "</body>" "$console\n</body>"] $html]
    } else {
        set res "$html$console"
    }
    return $res
}

proc BaseKalinka_Debug_analyse_HTML {html} {
    global ERREURS
    set err [dict get $ERREURS "HTML"]
    # Doctype de la page
    if {[string first "<!DOCTYPE" $html] != -1} {
        if {[string first "<!DOCTYPE" $html] != 0} {
            lappend err "Le Doctype doit être le premier élément de la page."
        }
    } else {
        lappend err "La page ne contient aucun Doctype."
    }
    # Analyse de HEAD
    # La balise HEAD ouvre?
    if {[string first "<head" $html] != -1} {
        # Elle ferme?
        if {[string first "</head>" $html] != -1} {
            
        } else {
            lappend err "La balise &lt;head&gt; ne ferme pas, là c'est grave"
        }
    } else {
        lappend err "Problème avec la balise &lt;head&gt;"
    }
    dict set ERREURS "HTML" $err
}

##
# Ne pas utiliser
##
proc __BaseKalinka_debug_analyse_HTML_balise__ {balise} {
    set options_balise [split $balise " "]
    set nom_balise [lindex $options_balise 0]
    set statut "null"
    set balises_html [list "a" "abbr" "address" "area" "article" "aside" "audio" "b" "base" "bdo" "blockquote" "body" "br" "button" "canvas" "caption" "cite" "code" "col" "colgroup" "command" "datalist" "dd" "del" "details" "dfn" "div" "dl" "dt" "em" "embed" "fieldset" "figcaption" "figure" "footer" "form" "h1" "h2" "h3" "h4" "h5" "h6" "head" "header" "hgroup" "hr" "html" "i" "iframe" "img" "input" "ins" "keygen" "kdb" "label" "legend" "li" "link" "map" "mark" "math" "menu" "meta" "meter" "nav" "noscript" "object" "ol" "optgroup" "option" "output" "p" "param" "pre" "progress" "q" "rp" "rt" "ruby" "samp" "script" "section" "select" "small" "source" "span" "strong" "style" "sub" "summary" "sup" "svg" "table" "tbody" "td" "textarea" "tfoot" "th" "thead" "time" "title" "tr" "track" "ul" "var" "video" "wbr"]
    # Test si la balise existe
    set ok 0
    foreach b $balises_html {
        if {$nom_balise == $b || $nom_balise == "!DOCTYPE"} {
            set ok 1
        }
    }
    if {$ok == 0} {
        set statut "La balise &lt;$nom_balise&gt; n'existe pas en HTML5."
    }
    return $statut
}

proc BaseKalinka_Debug_analyse_HTML_dom {html} {
    global ERREURS
    set err [dict get $ERREURS "HTML"]
    
    # Suppression des commentaires
    set html [BaseKalinka_HTML_supp_comm $html]
    
    set debut 0
    while {[string first "<" $html $debut] != -1} {
        set ouvre [string first "<" $html $debut]
        set ferme [string first ">" $html $ouvre]
        set balise [string range $html [expr $ouvre + 1] [expr $ferme - 1]]
        set options_balise [split $balise " "]
        set nom_balise [lindex $options_balise 0]
        # Sépare les balises ouvrantes des balises fermantes
        if {[string range $balise 0 0] == "/"} {
            set balise [string range $balise 1 [expr [string length $balise] - 1]]
            lappend balises_fermantes $balise
        } else {
            lappend balises_ouvrantes $balise
        }
        set fin [expr $ferme + 1]
        set debut $fin
    }
    
    # Test la validité des balises ouvrantes
    foreach balise $balises_ouvrantes {
        set statut [__BaseKalinka_debug_analyse_HTML_balise__ $balise]
        if {$statut != "null"} {
            lappend err $statut
        }
    }
    dict set ERREURS "HTML" $err
}
