# Terminal Snake

The purpose:  Beating the snakes and giving RBS and TruffleRuby(GraalVM based blazingly fast ruby) a test ride

The dependencies:
- Rspec (classic BDD)
- RBS (for type hinting)
- Pry (for debugging)
- TTY reader (for reading input)

The tests
```shell
rspec --format doc
```

The look & feel:
``` 
  1 2 3 4 5 6 7 8 9 
1 . . . . . . . . . 
2 . . . . . . . . . 
3 . . . . . . o . . 
4 . . . . . . . . . 
5 . . x x x x . . . 
6 . . . . . . . . . 
7 . . . . . . . . . 
8 . . . . . . . . . 
9 . . . . . . . . .
```

The problems I had:
- TruffleRuby breaks RBS codegen, had to use Ruby 3.1.2 MRI couple of times to generate