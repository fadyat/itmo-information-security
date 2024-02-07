Без явного указания портов `nmap` не может определить версию ОС, возможно, это связано
зависит от того, что все сервисы запущены в контейнерах без каких-либо дополнительных
настроек.

```shell
nmap -O 172.29.0.3
```

```text
Starting Nmap 7.80 ( https://nmap.org ) at 2024-02-07 00:04 UTC
Nmap scan report for network-security-server.build_container-network (172.29.0.3)
Host is up (0.00028s latency).
Not shown: 998 closed ports
PORT     STATE SERVICE
4000/tcp open  remoteanything
8080/tcp open  http-proxy
MAC Address: 02:42:AC:1D:00:03 (Unknown)
No exact OS matches for host (If you know what OS is running on it, see https://nmap.org/submit/ ).
TCP/IP fingerprint:
OS:SCAN(V=7.80%E=4%D=2/7%OT=4000%CT=1%CU=31819%PV=Y%DS=1%DC=D%G=Y%M=0242AC%
OS:TM=65C2C927%P=aarch64-unknown-linux-gnu)SEQ(SP=108%GCD=1%ISR=10B%TI=Z%CI
OS:=Z%TS=A)SEQ(SP=108%GCD=1%ISR=10B%TI=Z%CI=Z%II=I%TS=A)OPS(O1=M5B4ST11NW7%
OS:O2=M5B4ST11NW7%O3=M5B4NNT11NW7%O4=M5B4ST11NW7%O5=M5B4ST11NW7%O6=M5B4ST11
OS:)WIN(W1=FE88%W2=FE88%W3=FE88%W4=FE88%W5=FE88%W6=FE88)ECN(R=Y%DF=Y%T=40%W
OS:=FAF0%O=M5B4NNSNW7%CC=Y%Q=)T1(R=Y%DF=Y%T=40%S=O%A=S+%F=AS%RD=0%Q=)T2(R=N
OS:)T3(R=N)T4(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)T5(R=Y%DF=Y%T=40%W=0
OS:%S=Z%A=S+%F=AR%O=%RD=0%Q=)T6(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)T7
OS:(R=Y%DF=Y%T=40%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)U1(R=Y%DF=N%T=40%IPL=164%UN=
OS:0%RIPL=G%RID=G%RIPCK=G%RUCK=G%RUD=G)IE(R=Y%DFI=N%T=40%CD=S)

Network Distance: 1 hop

OS detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 11.97 seconds
```

С указанием порта `nmap` определяет версию ОС, но получает несколько вариантов:

```shell
nmap -O 172.29.0.3 -p 8080
```

```text
Starting Nmap 7.80 ( https://nmap.org ) at 2024-02-06 23:32 UTC
Nmap scan report for network-security-server.build_container-network (172.29.0.3)
Host is up (0.00022s latency).

PORT     STATE SERVICE
8080/tcp open  http-proxy
MAC Address: 02:42:AC:1D:00:03 (Unknown)
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Aggressive OS guesses: Linux 2.6.32 (96%), Linux 3.2 - 4.9 (96%), Linux 2.6.32 - 3.10 (96%), Linux 3.4 - 3.10 (95%), Linux 3.1 (95%), Linux 3.2 (95%), AXIS 210A or 211 Network Camera (Linux 2.6.17) (94%), Synology DiskStation Manager 5.2-5644 (94%), Netgear RAIDiator 4.2.28 (94%), Linux 2.6.32 - 2.6.35 (94%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 1 hop

OS detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 3.77 seconds
```

Более точный результат уже на специально подготовленном сервере:

```shell
nmap -O scanme.nmap.org
```

```text
Starting Nmap 7.80 ( https://nmap.org ) at 2024-02-07 00:00 UTC
Nmap scan report for scanme.nmap.org (45.33.32.156)
Host is up (0.0037s latency).
Other addresses for scanme.nmap.org (not scanned): 2600:3c01::f03c:91ff:fe18:bb2f

PORT      STATE SERVICE
1/tcp     open  tcpmux
3/tcp     open  compressnet
4/tcp     open  unknown

...

Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Device type: switch
Running (JUST GUESSING): 3Com embedded (85%)
OS CPE: cpe:/h:3com:superstack_3_switch_3870
Aggressive OS guesses: 3Com SuperStack 3 Switch 3870 (85%)
No exact OS matches for host (test conditions non-ideal).

OS detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 4.20 seconds
```

---

```shell
tshark -i eth0 -f 'icmp or tcp port 8080' -w /tshark/http.pcap 
tshark -r /tshark/http.pcap
```

```text
    1 0.000000000   172.29.0.2 → 172.29.0.3   TCP 58 45992 → 8080 [SYN] Seq=0 Win=1024 Len=0 MSS=1460
    2 0.000033917   172.29.0.3 → 172.29.0.2   TCP 58 8080 → 45992 [SYN, ACK] Seq=0 Ack=1 Win=64240 Len=0 MSS=1460
    3 0.000042750   172.29.0.2 → 172.29.0.3   TCP 54 45992 → 8080 [RST] Seq=1 Win=0 Len=0
    4 0.116014500   172.29.0.2 → 172.29.0.3   TCP 74 35511 → 8080 [SYN] Seq=0 Win=1 Len=0 WS=1024 MSS=1460 TSval=4294967295 TSecr=0 SACK_PERM=1
    5 0.116035208   172.29.0.3 → 172.29.0.2   TCP 74 8080 → 35511 [SYN, ACK] Seq=0 Ack=1 Win=65160 Len=0 MSS=1460 SACK_PERM=1 TSval=2114884990 TSecr=4294967295 WS=128
    6 0.116051958   172.29.0.2 → 172.29.0.3   TCP 54 35511 → 8080 [RST] Seq=1 Win=0 Len=0
    7 0.216949208   172.29.0.2 → 172.29.0.3   TCP 74 35512 → 8080 [SYN] Seq=0 Win=63 Len=0 MSS=1400 WS=1 SACK_PERM=1 TSval=4294967295 TSecr=0
    8 0.217020875   172.29.0.3 → 172.29.0.2   TCP 74 8080 → 35512 [SYN, ACK] Seq=0 Ack=1 Win=65160 Len=0 MSS=1460 SACK_PERM=1 TSval=2114885091 TSecr=4294967295 WS=128
    9 0.217051042   172.29.0.2 → 172.29.0.3   TCP 54 35512 → 8080 [RST] Seq=1 Win=0 Len=0
   10 0.319376250   172.29.0.2 → 172.29.0.3   TCP 74 35513 → 8080 [SYN] Seq=0 Win=4 Len=0 TSval=4294967295 TSecr=0 WS=32 MSS=640
   11 0.319429208   172.29.0.3 → 172.29.0.2   TCP 74 8080 → 35513 [SYN, ACK] Seq=0 Ack=1 Win=65160 Len=0 MSS=1460 TSval=2114885193 TSecr=4294967295 WS=128
   12 0.319457625   172.29.0.2 → 172.29.0.3   TCP 54 35513 → 8080 [RST] Seq=1 Win=0 Len=0
   13 0.419961292   172.29.0.2 → 172.29.0.3   TCP 70 35514 → 8080 [SYN] Seq=0 Win=4 Len=0 SACK_PERM=1 TSval=4294967295 TSecr=0 WS=1024
   14 0.420072458   172.29.0.3 → 172.29.0.2   TCP 74 8080 → 35514 [SYN, ACK] Seq=0 Ack=1 Win=65160 Len=0 MSS=1460 SACK_PERM=1 TSval=2114885294 TSecr=4294967295 WS=128
   15 0.420120875   172.29.0.2 → 172.29.0.3   TCP 54 35514 → 8080 [RST] Seq=1 Win=0 Len=0
   16 0.520273458   172.29.0.2 → 172.29.0.3   TCP 74 35515 → 8080 [SYN] Seq=0 Win=16 Len=0 MSS=536 SACK_PERM=1 TSval=4294967295 TSecr=0 WS=1024
   17 0.520361250   172.29.0.3 → 172.29.0.2   TCP 74 8080 → 35515 [SYN, ACK] Seq=0 Ack=1 Win=65160 Len=0 MSS=1460 SACK_PERM=1 TSval=2114885394 TSecr=4294967295 WS=128
   18 0.520415667   172.29.0.2 → 172.29.0.3   TCP 54 35515 → 8080 [RST] Seq=1 Win=0 Len=0
   19 0.620390042   172.29.0.2 → 172.29.0.3   TCP 70 35516 → 8080 [SYN] Seq=0 Win=512 Len=0 MSS=265 SACK_PERM=1 TSval=4294967295 TSecr=0
   20 0.620483458   172.29.0.3 → 172.29.0.2   TCP 70 8080 → 35516 [SYN, ACK] Seq=0 Ack=1 Win=65160 Len=0 MSS=1460 SACK_PERM=1 TSval=2114885494 TSecr=4294967295
   21 0.620553125   172.29.0.2 → 172.29.0.3   TCP 54 35516 → 8080 [RST] Seq=1 Win=0 Len=0
   22 0.647137709   172.29.0.2 → 172.29.0.3   ICMP 162 Echo (ping) request  id=0x80d6, seq=295/9985, ttl=55
   23 0.647207084   172.29.0.3 → 172.29.0.2   ICMP 162 Echo (ping) reply    id=0x80d6, seq=295/9985, ttl=64 (request in 22)
   24 0.672436209   172.29.0.2 → 172.29.0.3   ICMP 192 Echo (ping) request  id=0x80d7, seq=296/10241, ttl=48
   25 0.672529584   172.29.0.3 → 172.29.0.2   ICMP 192 Echo (ping) reply    id=0x80d7, seq=296/10241, ttl=64 (request in 24)
   26 0.697694750   172.29.0.3 → 172.29.0.2   ICMP 370 Destination unreachable (Port unreachable)
   27 0.722697834   172.29.0.2 → 172.29.0.3   TCP 66 35523 → 8080 [SYN, ECN, CWR, Reserved] Seq=0 Win=3 Len=0 WS=1024 MSS=1460 SACK_PERM=1
   28 0.722743209   172.29.0.3 → 172.29.0.2   TCP 66 8080 → 35523 [SYN, ACK, ECN] Seq=0 Ack=1 Win=64240 Len=0 MSS=1460 SACK_PERM=1 WS=128
   29 0.722771209   172.29.0.2 → 172.29.0.3   TCP 54 35523 → 8080 [RST] Seq=1 Win=0 Len=0
   30 0.748107000   172.29.0.2 → 172.29.0.3   TCP 74 35525 → 8080 [<None>] Seq=1 Win=128 Len=0 WS=1024 MSS=265 TSval=4294967295 TSecr=0 SACK_PERM=1
   31 0.773287875   172.29.0.2 → 172.29.0.3   TCP 74 35526 → 8080 [FIN, SYN, PSH, URG] Seq=0 Win=256 Urg=0 Len=0 WS=1024 MSS=265 TSval=4294967295 TSecr=0 SACK_PERM=1
   32 0.798650250   172.29.0.2 → 172.29.0.3   TCP 74 35527 → 8080 [ACK] Seq=1 Ack=1 Win=1024 Len=0 WS=1024 MSS=265 TSval=4294967295 TSecr=0 SACK_PERM=1
   33 0.798716459   172.29.0.3 → 172.29.0.2   TCP 54 8080 → 35527 [RST] Seq=1 Win=0 Len=0
   34 0.900540792   172.29.0.2 → 172.29.0.3   TCP 74 [TCP Dup ACK 30#1] 35525 → 8080 [<None>] Seq=1 Win=131072 Len=0 WS=1024 MSS=265 TSval=4294967295 TSecr=0 SACK_PERM=1
   35 0.925672334   172.29.0.2 → 172.29.0.3   TCP 74 [TCP Retransmission] 35526 → 8080 [FIN, SYN, PSH, URG] Seq=0 Win=256 Urg=0 Len=0 WS=1024 MSS=265 TSval=4294967295 TSecr=0 SACK_PERM=1
   36 1.001708792   172.29.0.2 → 172.29.0.3   TCP 74 [TCP Dup ACK 30#2] 35525 → 8080 [<None>] Seq=1 Win=131072 Len=0 WS=1024 MSS=265 TSval=4294967295 TSecr=0 SACK_PERM=1
   37 1.027016459   172.29.0.2 → 172.29.0.3   TCP 74 [TCP Retransmission] 35526 → 8080 [FIN, SYN, PSH, URG] Seq=0 Win=256 Urg=0 Len=0 WS=1024 MSS=265 TSval=4294967295 TSecr=0 SACK_PERM=1
   38 1.101802500   172.29.0.2 → 172.29.0.3   TCP 74 [TCP Dup ACK 30#3] 35525 → 8080 [<None>] Seq=1 Win=131072 Len=0 WS=1024 MSS=265 TSval=4294967295 TSecr=0 SACK_PERM=1
   39 1.127155042   172.29.0.2 → 172.29.0.3   TCP 74 [TCP Retransmission] 35526 → 8080 [FIN, SYN, PSH, URG] Seq=0 Win=256 Urg=0 Len=0 WS=1024 MSS=265 TSval=4294967295 TSecr=0 SACK_PERM=1
   40 2.276399793   172.29.0.2 → 172.29.0.3   TCP 74 [TCP Port numbers reused] 35511 → 8080 [SYN] Seq=0 Win=1 Len=0 WS=1024 MSS=1460 TSval=4294967295 TSecr=0 SACK_PERM=1
   41 2.276444376   172.29.0.3 → 172.29.0.2   TCP 74 8080 → 35511 [SYN, ACK] Seq=0 Ack=1 Win=65160 Len=0 MSS=1460 SACK_PERM=1 TSval=2114887150 TSecr=4294967295 WS=128
   42 2.276467834   172.29.0.2 → 172.29.0.3   TCP 54 35511 → 8080 [RST] Seq=1 Win=0 Len=0
   43 2.376653918   172.29.0.2 → 172.29.0.3   TCP 74 [TCP Port numbers reused] 35512 → 8080 [SYN] Seq=0 Win=63 Len=0 MSS=1400 WS=1 SACK_PERM=1 TSval=4294967295 TSecr=0
   44 2.376722126   172.29.0.3 → 172.29.0.2   TCP 74 8080 → 35512 [SYN, ACK] Seq=0 Ack=1 Win=65160 Len=0 MSS=1460 SACK_PERM=1 TSval=2114887251 TSecr=4294967295 WS=128
   45 2.376762126   172.29.0.2 → 172.29.0.3   TCP 54 35512 → 8080 [RST] Seq=1 Win=0 Len=0
   46 2.477001459   172.29.0.2 → 172.29.0.3   TCP 74 [TCP Port numbers reused] 35513 → 8080 [SYN] Seq=0 Win=4 Len=0 TSval=4294967295 TSecr=0 WS=32 MSS=640
   47 2.477132501   172.29.0.3 → 172.29.0.2   TCP 74 8080 → 35513 [SYN, ACK] Seq=0 Ack=1 Win=65160 Len=0 MSS=1460 TSval=2114887351 TSecr=4294967295 WS=128
   48 2.477173751   172.29.0.2 → 172.29.0.3   TCP 54 35513 → 8080 [RST] Seq=1 Win=0 Len=0
   49 2.577232376   172.29.0.2 → 172.29.0.3   TCP 70 [TCP Port numbers reused] 35514 → 8080 [SYN] Seq=0 Win=4 Len=0 SACK_PERM=1 TSval=4294967295 TSecr=0 WS=1024
   50 2.577288709   172.29.0.3 → 172.29.0.2   TCP 74 8080 → 35514 [SYN, ACK] Seq=0 Ack=1 Win=65160 Len=0 MSS=1460 SACK_PERM=1 TSval=2114887451 TSecr=4294967295 WS=128
   51 2.577325543   172.29.0.2 → 172.29.0.3   TCP 54 35514 → 8080 [RST] Seq=1 Win=0 Len=0
   52 2.679147959   172.29.0.2 → 172.29.0.3   TCP 74 [TCP Port numbers reused] 35515 → 8080 [SYN] Seq=0 Win=16 Len=0 MSS=536 SACK_PERM=1 TSval=4294967295 TSecr=0 WS=1024
   53 2.679190293   172.29.0.3 → 172.29.0.2   TCP 74 8080 → 35515 [SYN, ACK] Seq=0 Ack=1 Win=65160 Len=0 MSS=1460 SACK_PERM=1 TSval=2114887553 TSecr=4294967295 WS=128
   54 2.679213626   172.29.0.2 → 172.29.0.3   TCP 54 35515 → 8080 [RST] Seq=1 Win=0 Len=0
   55 2.780164626   172.29.0.2 → 172.29.0.3   TCP 70 [TCP Port numbers reused] 35516 → 8080 [SYN] Seq=0 Win=512 Len=0 MSS=265 SACK_PERM=1 TSval=4294967295 TSecr=0
   56 2.780206918   172.29.0.3 → 172.29.0.2   TCP 70 8080 → 35516 [SYN, ACK] Seq=0 Ack=1 Win=65160 Len=0 MSS=1460 SACK_PERM=1 TSval=2114887654 TSecr=4294967295
   57 2.780228793   172.29.0.2 → 172.29.0.3   TCP 54 35516 → 8080 [RST] Seq=1 Win=0 Len=0
   58 2.808700168   172.29.0.2 → 172.29.0.3   ICMP 162 Echo (ping) request  id=0x29e2, seq=295/9985, ttl=55
   59 2.808746126   172.29.0.3 → 172.29.0.2   ICMP 162 Echo (ping) reply    id=0x29e2, seq=295/9985, ttl=64 (request in 58)
   60 2.835706543   172.29.0.2 → 172.29.0.3   ICMP 192 Echo (ping) request  id=0x29e3, seq=296/10241, ttl=37
   61 2.835757668   172.29.0.3 → 172.29.0.2   ICMP 192 Echo (ping) reply    id=0x29e3, seq=296/10241, ttl=64 (request in 60)
   62 2.861246960   172.29.0.3 → 172.29.0.2   ICMP 370 Destination unreachable (Port unreachable)
   63 2.890047376   172.29.0.2 → 172.29.0.3   TCP 66 [TCP Port numbers reused] 35523 → 8080 [SYN, ECN, CWR, Reserved] Seq=0 Win=3 Len=0 WS=1024 MSS=1460 SACK_PERM=1
   64 2.890134543   172.29.0.3 → 172.29.0.2   TCP 66 8080 → 35523 [SYN, ACK, ECN] Seq=0 Ack=1 Win=64240 Len=0 MSS=1460 SACK_PERM=1 WS=128
   65 2.890179835   172.29.0.2 → 172.29.0.3   TCP 54 35523 → 8080 [RST] Seq=1 Win=0 Len=0
   66 2.916369626   172.29.0.2 → 172.29.0.3   TCP 74 35525 → 8080 [<None>] Seq=2287612787 Win=131072 Len=0 WS=1024 MSS=265 TSval=4294967295 TSecr=0 SACK_PERM=1
   67 2.943832501   172.29.0.2 → 172.29.0.3   TCP 74 [TCP Port numbers reused] 35526 → 8080 [FIN, SYN, PSH, URG] Seq=0 Win=256 Urg=0 Len=0 WS=1024 MSS=265 TSval=4294967295 TSecr=0 SACK_PERM=1
   68 2.969232543   172.29.0.2 → 172.29.0.3   TCP 74 35527 → 8080 [ACK] Seq=2287612787 Ack=3629612961 Win=1048576 Len=0 WS=1024 MSS=265 TSval=4294967295 TSecr=0 SACK_PERM=1
   69 2.969297918   172.29.0.3 → 172.29.0.2   TCP 54 8080 → 35527 [RST] Seq=3629612961 Win=0 Len=0
   70 3.073531918   172.29.0.2 → 172.29.0.3   TCP 74 35525 → 8080 [<None>] Seq=2287612787 Win=131072 Len=0 WS=1024 MSS=265 TSval=4294967295 TSecr=0 SACK_PERM=1
   71 3.098872376   172.29.0.2 → 172.29.0.3   TCP 74 [TCP Retransmission] 35526 → 8080 [FIN, SYN, PSH, URG] Seq=0 Win=256 Urg=0 Len=0 WS=1024 MSS=265 TSval=4294967295 TSecr=0 SACK_PERM=1
   72 3.174354460   172.29.0.2 → 172.29.0.3   TCP 74 35525 → 8080 [<None>] Seq=2287612787 Win=131072 Len=0 WS=1024 MSS=265 TSval=4294967295 TSecr=0 SACK_PERM=1
   73 3.200770126   172.29.0.2 → 172.29.0.3   TCP 74 [TCP Retransmission] 35526 → 8080 [FIN, SYN, PSH, URG] Seq=0 Win=256 Urg=0 Len=0 WS=1024 MSS=265 TSval=4294967295 TSecr=0 SACK_PERM=1
   74 3.276048960   172.29.0.2 → 172.29.0.3   TCP 74 35525 → 8080 [<None>] Seq=2287612787 Win=131072 Len=0 WS=1024 MSS=265 TSval=4294967295 TSecr=0 SACK_PERM=1
   75 3.301099001   172.29.0.2 → 172.29.0.3   TCP 74 [TCP Retransmission] 35526 → 8080 [FIN, SYN, PSH, URG] Seq=0 Win=256 Urg=0 Len=0 WS=1024 MSS=265 TSval=4294967295 TSecr=0 SACK_PERM=1
```

---

```shell
snort -A console -q -c /etc/snort/snort.conf -i eth0
```

```text
02/07-00:13:26.057343  [**] [1:1421:11] SNMP AgentX/tcp request [**] [Classification: Attempted Information Leak] [Priority: 2] {TCP} 172.29.0.2:52531 -> 172.29.0.3:705
02/07-00:13:26.059277  [**] [1:1418:11] SNMP request tcp [**] [Classification: Attempted Information Leak] [Priority: 2] {TCP} 172.29.0.2:52531 -> 172.29.0.3:161
02/07-00:13:26.707428  [**] [1:365:8] ICMP PING undefined code [**] [Classification: Misc activity] [Priority: 3] {ICMP} 172.29.0.2 -> 172.29.0.3
02/07-00:13:26.707555  [**] [1:409:7] ICMP Echo Reply undefined code [**] [Classification: Misc activity] [Priority: 3] {ICMP} 172.29.0.3 -> 172.29.0.2
02/07-00:13:26.733063  [**] [1:384:5] ICMP PING [**] [Classification: Misc activity] [Priority: 3] {ICMP} 172.29.0.2 -> 172.29.0.3
02/07-00:13:26.733131  [**] [1:408:5] ICMP Echo Reply [**] [Classification: Misc activity] [Priority: 3] {ICMP} 172.29.0.3 -> 172.29.0.2
02/07-00:13:26.760087  [**] [1:402:7] ICMP Destination Unreachable Port Unreachable [**] [Classification: Misc activity] [Priority: 3] {ICMP} 172.29.0.3 -> 172.29.0.2
02/07-00:13:26.941522  [**] [1:1228:7] SCAN nmap XMAS [**] [Classification: Attempted Information Leak] [Priority: 2] {TCP} 172.29.0.2:59779 -> 172.29.0.3:1
02/07-00:13:28.919636  [**] [1:365:8] ICMP PING undefined code [**] [Classification: Misc activity] [Priority: 3] {ICMP} 172.29.0.2 -> 172.29.0.3
02/07-00:13:28.919790  [**] [1:409:7] ICMP Echo Reply undefined code [**] [Classification: Misc activity] [Priority: 3] {ICMP} 172.29.0.3 -> 172.29.0.2
02/07-00:13:28.947505  [**] [1:384:5] ICMP PING [**] [Classification: Misc activity] [Priority: 3] {ICMP} 172.29.0.2 -> 172.29.0.3
02/07-00:13:28.947555  [**] [1:408:5] ICMP Echo Reply [**] [Classification: Misc activity] [Priority: 3] {ICMP} 172.29.0.3 -> 172.29.0.2
02/07-00:13:28.972679  [**] [1:402:7] ICMP Destination Unreachable Port Unreachable [**] [Classification: Misc activity] [Priority: 3] {ICMP} 172.29.0.3 -> 172.29.0.2
02/07-00:13:29.153489  [**] [1:1228:7] SCAN nmap XMAS [**] [Classification: Attempted Information Leak] [Priority: 2] {TCP} 172.29.0.2:59779 -> 172.29.0.3:1
02/07-00:13:31.124007  [**] [1:365:8] ICMP PING undefined code [**] [Classification: Misc activity] [Priority: 3] {ICMP} 172.29.0.2 -> 172.29.0.3
02/07-00:13:31.124069  [**] [1:409:7] ICMP Echo Reply undefined code [**] [Classification: Misc activity] [Priority: 3] {ICMP} 172.29.0.3 -> 172.29.0.2
02/07-00:13:31.150618  [**] [1:384:5] ICMP PING [**] [Classification: Misc activity] [Priority: 3] {ICMP} 172.29.0.2 -> 172.29.0.3
02/07-00:13:31.150665  [**] [1:408:5] ICMP Echo Reply [**] [Classification: Misc activity] [Priority: 3] {ICMP} 172.29.0.3 -> 172.29.0.2
02/07-00:13:31.175938  [**] [1:402:7] ICMP Destination Unreachable Port Unreachable [**] [Classification: Misc activity] [Priority: 3] {ICMP} 172.29.0.3 -> 172.29.0.2
02/07-00:13:31.357435  [**] [1:1228:7] SCAN nmap XMAS [**] [Classification: Attempted Information Leak] [Priority: 2] {TCP} 172.29.0.2:59779 -> 172.29.0.3:1
02/07-00:13:34.817845  [**] [1:365:8] ICMP PING undefined code [**] [Classification: Misc activity] [Priority: 3] {ICMP} 172.29.0.2 -> 172.29.0.3
02/07-00:13:34.817957  [**] [1:409:7] ICMP Echo Reply undefined code [**] [Classification: Misc activity] [Priority: 3] {ICMP} 172.29.0.3 -> 172.29.0.2
02/07-00:13:34.843152  [**] [1:384:5] ICMP PING [**] [Classification: Misc activity] [Priority: 3] {ICMP} 172.29.0.2 -> 172.29.0.3
02/07-00:13:34.843197  [**] [1:408:5] ICMP Echo Reply [**] [Classification: Misc activity] [Priority: 3] {ICMP} 172.29.0.3 -> 172.29.0.2
02/07-00:13:34.869945  [**] [1:402:7] ICMP Destination Unreachable Port Unreachable [**] [Classification: Misc activity] [Priority: 3] {ICMP} 172.29.0.3 -> 172.29.0.2
02/07-00:13:35.048018  [**] [1:1228:7] SCAN nmap XMAS [**] [Classification: Attempted Information Leak] [Priority: 2] {TCP} 172.29.0.2:59779 -> 172.29.0.3:1
02/07-00:13:37.020994  [**] [1:365:8] ICMP PING undefined code [**] [Classification: Misc activity] [Priority: 3] {ICMP} 172.29.0.2 -> 172.29.0.3
02/07-00:13:37.021044  [**] [1:409:7] ICMP Echo Reply undefined code [**] [Classification: Misc activity] [Priority: 3] {ICMP} 172.29.0.3 -> 172.29.0.2
02/07-00:13:37.046498  [**] [1:384:5] ICMP PING [**] [Classification: Misc activity] [Priority: 3] {ICMP} 172.29.0.2 -> 172.29.0.3
02/07-00:13:37.046567  [**] [1:408:5] ICMP Echo Reply [**] [Classification: Misc activity] [Priority: 3] {ICMP} 172.29.0.3 -> 172.29.0.2
02/07-00:13:37.071562  [**] [1:402:7] ICMP Destination Unreachable Port Unreachable [**] [Classification: Misc activity] [Priority: 3] {ICMP} 172.29.0.3 -> 172.29.0.2
02/07-00:13:37.257038  [**] [1:1228:7] SCAN nmap XMAS [**] [Classification: Attempted Information Leak] [Priority: 2] {TCP} 172.29.0.2:59779 -> 172.29.0.3:1
```