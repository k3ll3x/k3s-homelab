function encode
    echo $argv[1] | openssl aes-256-cbc -a -salt -pass pass:$argv[2]
end
