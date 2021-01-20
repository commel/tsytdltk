set result "asking ts..."

# upper line
frame .input -borderwidth 1 -relief raised
pack .input -side top

label .input.newvid -text "New Video:"
pack .input.newvid -side left

text .input.t -width 80 -height 1
pack .input.t -side left

button .input.r -text "Refresh" -command ts_read
pack .input.r -side right

button .input.c -text "Clear" -command tf_clear
pack .input.c -side right

button .input.b -text "Enqueue" -command {ts_add [.input.t get 1.0 end]}
pack .input.b -side right

# content
frame .show -borderwidth 1 -relief sunken
pack .show -side left

text .show.t
pack .show.t -expand 0 -fill both

# add url to ts
proc ts_add {url} {
    exec /usr/local/bin/ts youtube-dl $url
    ts_read
}

# update ts content
proc ts_read {} {
    global result
    set result [exec ts]
    ts_update
}

# update textfield
proc ts_update {} {
    global result
    .show.t configure -state normal
    .show.t delete 1.0 end
    .show.t insert end $result
    .show.t configure -state disabled

    # restart update process
    after 1000 ts_read
}

# clear input textfield
proc tf_clear {} {
    .input.t delete 1.0 end
}

# start updating process
after 1000 ts_read
