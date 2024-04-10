#!/bin/bash

chmod +x *.sh

echo Starting a major tournament...
for(( i=1; i <= $(wc -l < Games.txt); i++)) do
    TEAM=$(sed -n "$i"p Games.txt)
	if [ "$TEAM" = --- ]; then
	    continue
    fi
    i=$((i+1))
    TEAMT=$(sed -n "$i"p Games.txt)
    python3 EditMoment.py
    rcssserver server::fullstate_l = true server::fullstate_r = true server::auto_mode = true server::synch_mode = true server::game_log_dir = `pwd` server::keepaway_log_dir = `pwd` server::text_log_dir = `pwd` server::nr_extra_halfs = 0 server::penalty_shoot_outs = false &
    sleep 1
    server_pid=$!
    sleep 1
    cd Bins/$TEAM && ./localStartAll &
    sleep 1
    cd Bins/$TEAMT && ./localStartAll &
    wait $server_pid
    sleep 1
    cp *.rc* Analyzer -r
    python Analyzer/Say_winner.py
    rm Analyzer/*.rc*
    ./LogCompressor.sh
    ./ChangeLogDir.sh
    rm *.rcg.tar.gz *.rcl.tar.gz
done
