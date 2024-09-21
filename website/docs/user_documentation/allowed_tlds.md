---
sidebar_position: 3
title: Allowed TLDs Detection
description: Configure the detection "Allowed TLDs"
---
# Allowed TLDs Detection
From a list of domains, the TLDs detection will find all the domains that are __NOT__ in the list and raise a `Forbidden TLDs found`.

**When to use**  
Particularly in the profile section, this detection can be very useful for the personal URL. Being strict on profiles helps block spammers early, as it is often the first place they add spam content.

**Outputs of this detection**  
- `Not allowed domain extensions found`: When the detection finds a domain that is not in the list.

## Example of useful allowed domains around here

A list of European domains (you could add `.com`):
```
.ac.im
.am
.at
.ba
.be
.bg
.biz.pl
.biz.tr
.ch
.co.at
.co.ee
.co.gg
.co.gl
.co.hu
.co.il
.co.im
.co.je
.co.nl
.co.no
.co.ro
.co.rs
.co.uk
.com.de
.com.es
.com.gl
.com.gr
.com.hr
.com.im
.com.mk
.com.mt
.com.pl
.com.pt
.com.ro
.com.se
.com.tr
.com.ua
.cz
.de
.de.com
.dk
.ee
.es
.eu
.eu.com
.fi
.fr
.gb.net
.gg
.gr
.gr.com
.hr
.hu
.hu.net
.ie
.im
.in.rs
.info.pl
.info.tr
.is
.it
.je
.li
.lt
.ltd.co.im
.ltd.uk
.lu
.lv
.md
.me.uk
.mk
.mp
.mt
.net.im
.net.mt
.net.pl
.net.ua
.nl
.no
.nom.es
.or.at
.org.es
.org.il
.org.im
.org.mt
.org.pl
.org.ua
.org.uk
.pl
.plc.co.im
.pm
.pt
.re
.ro
.rs
.se
.se.net
.si
.sk
.tf
.tv.tr
.ua
.uk
.uk.com
.uk.net
.web.tr
.wf
.yt
```