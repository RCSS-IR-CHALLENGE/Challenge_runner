#!/bin/bash

while true
do
    python EditMoment.py
    mv G.txt Games.txt
    rm G.txt
    line_count=$(wc -l < Games.txt)
    if [ $line_count -eq 0 ]; then
        echo Breaking
        break;
    fi
    team_one=$(head -n 1 Games.txt)
    team_two=$(sed -n '2p' Games.txt)

    rcssserver server::fullstate_l = true server::fullstate_r = true server::auto_mode = true server::synch_mode = true server::game_log_dir = `pwd` server::keepaway_log_dir = `pwd` server::text_log_dir = `pwd` server::nr_extra_halfs = 2 server::penalty_shoot_outs = true &
    sleep 1
    server_pid=$!
    sleep 1
    cd Bins/$team_one && ./localStartAll &
    sleep 1
    cd Bins/$team_two && ./localStartAll &
    wait $server_pid
    sleep 1
    sed -i '1,2d' Games.txt
    cp *.rc* Analyzer -r
    winner=$(python Analyzer/Say_winner.py)
    rm Analyzer/*.rc*
    echo "$winner"
    python AnalyzeResult.py
    ./LogCompressor.sh
    ./ChangeLogDir.sh
    rm *.rcg *.rcl *.rcg.tar.gz *.rcl.tar.gz


    # Add "hi" to the beginning of Games.txt
    #sed -i '1s/^/$winner\n/' Games.txt
    # Assume 'winner' contains the value you want to write to the file

# Create a temporary file with the value of 'winner' followed by a newline
    echo "$winner" > tmpfile

# Append the contents of Games.txt to the temporary file
    cat Games.txt >> tmpfile

# Overwrite Games.txt with the contents of the temporary file
    mv tmpfile Games.txt
    sleep 1
done