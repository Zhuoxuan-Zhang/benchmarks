## Benchmark Suite

> _It's a suite that has benchmarks in it. For now, only oneliners is set up_

## Running Benchmarks

To run all benchmarks of a specific type

```sh
./benchmark_folder source whole_shebang.sh --flags
```
* Results are stored in outputs folder, within the corresponding benchmark type folder.
<<<<<<< HEAD
* --flags depends on benchmark type. See README's
=======
* --flags is --small or --large for input size. On oneliners there's no size choice.
>>>>>>> 6a27774ba4924f8b2b5ffcf7eb6b8da1d05ac162
* Validation of correct execution is done by time comparison and hash value comparison. Hash value might not work. Please let me know if it produces a "hashes don't match" error when you run it :). 

## Installation

On Ubuntu, Fedora, and Debian run the following to set up benchmarks. Not sure if it works on MACos yet!

```sh
wget https://github.com/binpash/benchmarks/
```


## Suite consists of

* [onliners](./oneliners): text manipulation
* [max-temp](./max-temp): large temperature data set processing
