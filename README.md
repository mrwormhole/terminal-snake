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

![terminal-snake](https://user-images.githubusercontent.com/22800416/179356533-9a3a1130-bf5e-4163-af3b-ac2f9764c103.gif)

The problems I had:
- TruffleRuby breaks RBS codegen, had to use Ruby 3.1.2 MRI couple of times to generate

