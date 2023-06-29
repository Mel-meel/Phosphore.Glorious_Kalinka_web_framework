## Créé les 29/5/2020 ##

######################################################
#  ___         __    __  ___         __   ___  ____  #
#  |__| |  |  /  \  /    |__| |  |  /  \  |__| |     #
#  |    |--| |    | ---- |    |--| |    | |\   |--   #
#  |    |  |  \__/  ___/ |    |  |  \__/  | \  |___  #
#                                                    #
######################################################

proc BaseKalinka_Apache_rivet_GET {} {
    set get [dict create]
    if {[::rivet::var number] > 0} {
        set get [::rivet::var all]
    }
    return $get
}

proc BaseKalinka_Apache_rivet_POST {} {
    set post [dict create]
    if {[::rivet::var_post number] > 0} {
        set post [::rivet::var_post all]
    }
    return $post
}

proc BaseKalinka_Apache_rivet_get_cookies {} {
    ::rivet::load_cookies COOKIES
    return [array get COOKIES]
}

proc BaseKalinka_Apache_rivet_set_cookie {nom valeur} {
    ::rivet::headers set Set-Cookie "$nom=$valeur"
}

proc BaseKalinka_Apache_rivet_redirect_url {url} {
    ::rivet::redirect $url
}

proc BaseKalinka_Apache_rivet_load_env {} {
    ::rivet::load_env ENV
    return [array get ENV]
}
