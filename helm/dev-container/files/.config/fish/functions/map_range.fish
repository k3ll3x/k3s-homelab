function map_range
    set x $argv[1]
    set a $argv[2]
    set b $argv[3]
    set c $argv[4]
    set d $argv[5]
    math "($x - $a) / ($b - $a) * ($d - $c) + $c"
end
