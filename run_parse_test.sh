for i in `seq 1 15`;
do
    ./compiler.native -parse "tests/test"$i".arith" > tmp.txt~
    diff tmp.txt~ "tests/test"$i".parse.out"
done    
