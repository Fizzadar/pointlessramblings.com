---
title: Lua vs Node vs LuaNginx
date: 2013-03-01
aliases:
    - /posts/Lua_vs_Node_vs_LuaNginx/
---

As part of my final year dissertation I've been learning about building web servers & apps using Lua, LuaJIT, LuaJIT+Nginx & Node. Because it's relatively simple to implement a basic HTTP server in each, I decided to run some benchmarks to compare them.

**Setup/Notes**

+ Nginx+LuaJIT has 1 worker process
+ All three are 'non-blocking' on IO operations
+ Each is set to only write "hello world"
+ Mostly looking at requests/s in results

### Tests & Results

#### Nginx+LuaJIT

**ab -n 100000 -c 30 http://127.0.0.1:8080/**

    Concurrency Level:      30
    Time taken for tests:   4.550 seconds
    Complete requests:      100000
    Failed requests:        0
    Write errors:           0
    Total transferred:      15200000 bytes
    HTML transferred:       1100000 bytes
    Requests per second:    21976.01 [#/sec] (mean)
    Time per request:       1.365 [ms] (mean)
    Time per request:       0.046 [ms] (mean, across all concurrent requests)
    Transfer rate:          3262.06 [Kbytes/sec] received

    Connection Times (ms)
                  min  mean[+/-sd] median   max
    Connect:        0    1   0.1      1       2
    Processing:     0    1   0.2      1       3
    Waiting:        0    1   0.2      1       3
    Total:          1    1   0.2      1       4

    Percentage of the requests served within a certain time (ms)
      50%      1
      66%      1
      75%      1
      80%      1
      90%      2
      95%      2
      98%      2
      99%      2
     100%      4 (longest request)

**ab -n 100000 -c 1000 http://127.0.0.1:8080/**

    Concurrency Level:      1000
    Time taken for tests:   6.575 seconds
    Complete requests:      100000
    Failed requests:        0
    Write errors:           0
    Total transferred:      15200000 bytes
    HTML transferred:       1100000 bytes
    Requests per second:    15210.15 [#/sec] (mean)
    Time per request:       65.746 [ms] (mean)
    Time per request:       0.066 [ms] (mean, across all concurrent requests)
    Transfer rate:          2257.76 [Kbytes/sec] received

    Connection Times (ms)
                  min  mean[+/-sd] median   max
    Connect:        0   43 237.4     13    3020
    Processing:     3   17  12.6     15     322
    Waiting:        2   13  11.4     11     321
    Total:          8   61 240.2     28    3050

    Percentage of the requests served within a certain time (ms)
      50%     28
      66%     41
      75%     45
      80%     47
      90%     52
      95%     58
      98%   1015
      99%   1048
     100%   3050 (longest request)

####Nodejs

**ab -n 100000 -c 30 http://127.0.0.1:8080/**

    Concurrency Level:      30
    Time taken for tests:   11.777 seconds
    Complete requests:      100000
    Failed requests:        0
    Write errors:           0
    Total transferred:      9800000 bytes
    HTML transferred:       1100000 bytes
    Requests per second:    8491.21 [#/sec] (mean)
    Time per request:       3.533 [ms] (mean)
    Time per request:       0.118 [ms] (mean, across all concurrent requests)
    Transfer rate:          812.64 [Kbytes/sec] received

    Connection Times (ms)
                  min  mean[+/-sd] median   max
    Connect:        0    0   0.1      0       2
    Processing:     0    3   2.0      3      17
    Waiting:        0    3   2.0      3      17
    Total:          0    4   2.0      3      17

    Percentage of the requests served within a certain time (ms)
      50%      3
      66%      4
      75%      5
      80%      5
      90%      6
      95%      7
      98%      8
      99%     10
     100%     17 (longest request)


**ab -n 100000 -c 1000 http://127.0.0.1:8080/**

    Concurrency Level:      1000
    Time taken for tests:   11.806 seconds
    Complete requests:      100000
    Failed requests:        0
    Write errors:           0
    Total transferred:      9800000 bytes
    HTML transferred:       1100000 bytes
    Requests per second:    8469.93 [#/sec] (mean)
    Time per request:       118.065 [ms] (mean)
    Time per request:       0.118 [ms] (mean, across all concurrent requests)
    Transfer rate:          810.60 [Kbytes/sec] received

    Connection Times (ms)
                  min  mean[+/-sd] median   max
    Connect:        0   82 455.3      0    7000
    Processing:     0   16  14.3     15     638
    Waiting:        0   16  14.3     15     638
    Total:          1   98 456.3     16    7034

    Percentage of the requests served within a certain time (ms)
      50%     16
      66%     20
      75%     22
      80%     24
      90%     29
      95%   1001
      98%   1025
      99%   3009
     100%   7034 (longest request)

####LuaJIT

**ab -n 100000 -c 30 http://127.0.0.1:8082/**

    Concurrency Level:      30
    Time taken for tests:   4.362 seconds
    Complete requests:      100000
    Failed requests:        0
    Write errors:           0
    Total transferred:      1100000 bytes
    HTML transferred:       0 bytes
    Requests per second:    22926.23 [#/sec] (mean)
    Time per request:       1.309 [ms] (mean)
    Time per request:       0.044 [ms] (mean, across all concurrent requests)
    Transfer rate:          246.28 [Kbytes/sec] received

    Connection Times (ms)
                  min  mean[+/-sd] median   max
    Connect:        0    0   0.1      0       2
    Processing:     0    1   0.1      1       3
    Waiting:        0    1   0.1      1       2
    Total:          1    1   0.2      1       4

    Percentage of the requests served within a certain time (ms)
      50%      1
      66%      1
      75%      1
      80%      1
      90%      1
      95%      2
      98%      2
      99%      2
     100%      4 (longest request)

**ab -n 100000 -c 1000 http://127.0.0.1:8082/**

For some reason the benchmark would *always* slow down and get stuck at the end, no idea why (Lua appears fine). So I ran until 6.7k:

    Concurrency Level:      1000
    Time taken for tests:   4.687 seconds
    Complete requests:      67458
    Failed requests:        0
    Write errors:           0
    Total transferred:      742269 bytes
    HTML transferred:       0 bytes
    Requests per second:    14391.28 [#/sec] (mean)
    Time per request:       69.487 [ms] (mean)
    Time per request:       0.069 [ms] (mean, across all concurrent requests)
    Transfer rate:          154.64 [Kbytes/sec] received

    Connection Times (ms)
                  min  mean[+/-sd] median   max
    Connect:        0   11 100.9      1    3002
    Processing:     0    4  46.5      2    2276
    Waiting:        0    4  46.5      2    2276
    Total:          0   15 124.8      3    3617

    Percentage of the requests served within a certain time (ms)
      50%      3
      66%      4
      75%      4
      80%      4
      90%      5
      95%      6
      98%      6
      99%     21
     100%   3617 (longest request)

####Lua

**ab -n 100000 -c 30 http://127.0.0.1:8082/**

    Concurrency Level:      30
    Time taken for tests:   4.499 seconds
    Complete requests:      100000
    Failed requests:        0
    Write errors:           0
    Total transferred:      1100000 bytes
    HTML transferred:       0 bytes
    Requests per second:    22225.53 [#/sec] (mean)
    Time per request:       1.350 [ms] (mean)
    Time per request:       0.045 [ms] (mean, across all concurrent requests)
    Transfer rate:          238.75 [Kbytes/sec] received

    Connection Times (ms)
                  min  mean[+/-sd] median   max
    Connect:        0    0   0.1      0       2
    Processing:     0    1   0.1      1       2
    Waiting:        0    1   0.1      1       2
    Total:          1    1   0.2      1       3

    Percentage of the requests served within a certain time (ms)
      50%      1
      66%      1
      75%      1
      80%      1
      90%      2
      95%      2
      98%      2
      99%      2
     100%      3 (longest request)

**ab -n 100000 -c 1000 http://127.0.0.1:8082/**

For some reason the benchmark would *always* slow down and get stuck at the end, no idea why (Lua appears fine). So I ran until 7.5k:

    Concurrency Level:      1000
    Time taken for tests:   4.405 seconds
    Complete requests:      75937
    Failed requests:        0
    Write errors:           0
    Total transferred:      835406 bytes
    HTML transferred:       0 bytes
    Requests per second:    17239.30 [#/sec] (mean)
    Time per request:       58.007 [ms] (mean)
    Time per request:       0.058 [ms] (mean, across all concurrent requests)
    Transfer rate:          185.21 [Kbytes/sec] received

    Connection Times (ms)
                  min  mean[+/-sd] median   max
    Connect:        0   16 152.6      2    3003
    Processing:     1    3  23.4      2    3078
    Waiting:        0    2  23.3      2    3077
    Total:          2   19 159.4      4    4082

    Percentage of the requests served within a certain time (ms)
      50%      4
      66%      5
      75%      5
      80%      5
      90%      6
      95%      6
      98%      8
      99%   1004
     100%   4082 (longest request)


### Discussion/Notes

Firstly it's worth mentioning that because this was only a simple "hello world" test this doesn't demonstrate a production environment comparison, only the raw speed of each option with it's default setup.

As for the problem when running 1,000 concurrency on Lua/LuaJIT I've no idea why it fails (because it still worked via a browser). I believe the benchmarks are still reasonably accurate as they were halted before the slowdown.

My Lua/LuaJIT implementations don't process/read any header fields, nor do they send any back (it's a *simple* server) I would expect this is the reason Lua/LuaJIT appears to fast. However it does demonstrate that a single process can easily handle 20,000 requests/s … Not if that single thread is Node, that is, which appears to peak at ~8,000 requests/s on every bit of hardware I've tested(?).

What I find most strange is the drop in performance in LuaJIT when increasing the number of concurrent connections when compared to the same change in Lua (both manage 22k req/s on 30 concurrent connections, but with 1,000: Lua managed 17k while JIT only 14k). This is unexpected/strange for a compiler which is designed speed up not only the compilation time but also the efficiency of the script itself (and it certainly works elsewhere - Luasocket issue?).


### Conclusion

Raw speed isn't everything, and some things (http level) should be left to a dedicated webserver (Nginx). Lua is the perfect language to 'embed' into the webserver to turn it into a webappserver. And Node is perfect because it'll be working with Javascript on the clientside, and not dealing with the http protocol.

So I'm going to be using a combination of LuaJIT+Nginx and Node.
