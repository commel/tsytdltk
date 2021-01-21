#!/usr/bin/wish
set result "asking ts..."
set dlmode "Filme Musikvideos Youtube"
set lastupdate "not set"

# upper line
frame .input -borderwidth 1 -relief raised
pack .input -side top

label .input.newvid -text "New Video:"
pack .input.newvid -side left

text .input.t -width 80 -height 1
pack .input.t -side left

listbox .input.l -height 3 -selectmode single -listvariable dlmode -activestyle dotbox
pack .input.l -side left
.input.l selection set 0

button .input.r -text "Refresh" -command ts_read
pack .input.r -side right

button .input.c -text "Clear" -command app_clear
pack .input.c -side right

button .input.b -text "Enqueue" -command {ts_add [.input.t get 1.0 end]}
pack .input.b -side right

# content
frame .show -borderwidth 1 -relief sunken
pack .show -side left

text .show.t
pack .show.t -expand 0 -fill both

label .show.update -textvariable lastupdate
pack .show.update

proc update_time {} {
    global lastupdate
    set systemtime [clock seconds]
    set lastupdate [clock format $systemtime -format %H:%M:%S]
}

# add url to ts
proc ts_add {url} {
    set sel [.input.l get [.input.l curselection]]
    exec /usr/local/bin/ts youtube-dl -o ~/Videos/$sel/%(title)s.%(ext)s $url
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

    update_time

    # restart update process
    after 1000 ts_read
}

# clear input textfield
proc app_clear {} {
    .input.t delete 1.0 end
    .input.l selection set 0
    exec ts -C
}

# start updating process
after 1000 ts_read
