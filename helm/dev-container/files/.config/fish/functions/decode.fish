function decode
    echo $argv[1] | openssl aes-256-cbc -d -a -salt -pass pass:$argv[2]
end
