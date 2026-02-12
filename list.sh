#!/usr/bin/env bash

SOURCES=(http://epg.one/edem_epg_ico.m3u8 \
            http://epg.one/edem_epg_ico2.m3u8 \
            http://epg.one/edem_epg_ico3.m3u8)

for i in "${SOURCES[@]}"
do
    curl -sLO "$i"
done

awk -i inplace '
    BEGIN{
        RS="\r|\n|\r\n|\n\r"
        ORS="\n"
    }
    /^#EXTI/{
        sub(/[^,]+,/, "")
        t = $0
    }
    /^http/{
        sub(/[^0]+\/0+\//, "")
        sub(/\/.*/, "")
        a[$0] = t
    }
    ENDFILE{
        PROCINFO["sorted_in"] = "@ind_num_asc"
        for (i in a) {
            print i","a[i]
        }
    }' ./*.m3u8

cat ./*m3u8 | awk '
    {
        a[$0]++
    }
    END{
        PROCINFO["sorted_in"] = "@ind_num_asc"
        for (i in a) {
            print i
        }
    }' > list.new

# mv diff diff-prv-$(date +%s)
awk '
    BEGIN{
        FS = ","
    }
    NR==FNR{
        c[$1]++
        next
    }
    (c[$1] == 0){
        print
    }' list list.new > ./diff

cat list diff | awk '
    {
        a[$0]++
    }
    END{
        PROCINFO["sorted_in"] = "@ind_num_asc"
        for (i in a) {
            print i
        }
    }' > list.tmp

mv -f list.tmp list
rm -f ./*m3u8 list.new list.tmp
