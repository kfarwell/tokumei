```
               █                             █
███████        █
   █           █
   █     ███   █  ▒█  █   █  ██▓█▓   ███   ███
   █    █▓ ▓█  █ ▒█   █   █  █▒█▒█  ▓▓ ▒█    █
   █    █   █  █▒█    █   █  █ █ █  █   █    █
   █    █   █  ██▓    █   █  █ █ █  █████    █
   █    █   █  █░█░   █   █  █ █ █  █        █
   █    █▓ ▓█  █ ░█   █▒ ▓█  █ █ █  ▓▓  █    █
   █     ███   █  ▒█  ▒██▒█  █ █ █   ███▒  █████

          Anonymous social networking
```

> What you have to say is more important than who you are.


About
=====
Tokumei is a simple, self-hostable, anonymous microblogging platform.

You can host your own Tokumei site with your own rules and your own
audience. Developers are free to customize their sites with complete
source code access, and beginners can get their own Tokumei site running
in just a few minutes. Get started by visiting
https://tokumei.co/hosting

Microblogging
-------------
Microblogging is a communication format popularized by sites like
Twitter, Mastodon, and GNU Social. Quickly express your thoughts in
short bursts to large audiences. With Tokumei you can discover and share
the most interesting 300-character thoughts on the net.

Anonymity
---------
We believe that what you have to say is more important than who you are.
Tokumei is anonymous and secure by default, with absolutely no user
accounts. Tokumei's account-less system has shown to be an effective way
to avoid bias in discussion, on the premise that when all information is
treated equally, only an interesting post or an accurate argument works.

Building
========

This project is in an odd state in that it is currently not
`go get`-able. The following are the build instructions until such a
time that v2.x replaces v1.x on the master branch of this repository.

The following sequences of commands assume that your `GOPATH` is set
correctly. This is usually `~/go`.

First, checkout the repository and switch to the correct branch.

    git clone https://gitlab.com/tokumei/tokumei \
              $GOPATH/gitlab.com/tokumei/tokumei
    cd $GOPATH/gitlab.com/tokumei/tokumei
    git checkout -b tokumei-go && git pull

Once you have done this, you can use the project's provided Makefile to
automate retrieval of dependancies and to create the server executable.

    make backend    # fetches dependencies and builds server
    make frontend   # installs materialize and jquery to expected paths
    make all        # do it all at once
    make clean      # remove the tokumei binary
    make test       # run `go test -cover` on testable packages

*Note:* The server backend is under heavy development, and the frontend
has not caught up to the changes that have been made to templating since
v1.x. Do not rely on the web GUI for functionality at this time.

Running
=======

Once you've installed `tokumei`, you'll have a single binary sitting at
the path `$GOPATH/gitlab.com/tokumei/tokumei/tokumei`. Whew. It must be
run from its parent directory as follows:

    cd $GOPATH/gitlab.com/tokumei/tokumei
    ./tokumei &     # start server on localhost:3003

Advanced usage can be checked with `./tokumei --help`.


History
=======
version 1.x-
------------
Tokumei v1.x and below was written in `rc`, the Plan 9 shell, using the
werc minimal web framework. It offloaded much functionality to standard
Unix-like utilities found in Plan 9 Port.
While the v1.x series remains fully functional, it is slow, and the
project structure is complex because it required running a set of
non-native tools from Plan9 on a host OS like GNU/Linux.

version 2.x+
------------
Tokumei v2.x is currently being rewritten in [Go](http://golang.org).
The new version of Tokumei aims to be faster, easier to work with,
better organized, and easier to install. It is currently in a
**pre-alpha** development stage.

The v2.x series follows semantic versioning. You can check the current
version of Tokumei with `./tokumei --version`.


Development Roadmap
===================
Tokumei v2.x is under heavy development to bring its feature set back up
to where the 1.x series left off. Once the core features are fully
implemented, we will be looking at:

 * Internationalization:
   + Tokumei has been supported by a global community since its
     inception. We want to support you back by offering proper
     localization, and easy discovery of posts in your language.
 * Server federation:
   + Optionally enrol your server in federation with other Tokumei
     servers; this will add a new "Globe" tab to your Tokumei
     installation which will display Tokumei posts from other servers on
     the net.
 * Web admin interfaces:
   + Though the new Tokumei commandline is very simple (thanks to
     [go-cli](https://github.com/urfave/cli)), a web app is not complete
     with proper web dashboards. It is hoped that all administrative
     tasks will be able to be completed from a web-frontend.
 * Other features:
   + Have a feature request? [Let us know!](https://tokumei.co/contact)

Tokumei 2.x is currently in **pre-alpha**.

License
=======
Tokumei is distributed under the ISC license, reproduced below.

```
Copyright (c) 2015-2018, Keefer Rourke
Copyright (c) 2015-2018, Kyle Farwell

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
```

Tokumei includes some third-party programs which carry their own
licenses. See individual files' license headers for more information.

The Tokumei logo is created by Keefer Rourke and distributed under the
Creative Commons Attribution-ShareAlike 4.0 Internation License,
available at https://creativecommons.org/license/by-sa/4.0/legalcode

The homepage background at public/img/background1.jpg is copyright (c)
2015 JMacPherson and is distributed under the Creative Commons
Attribution 2.0 Generic license.

Other homepage backgrounds under public/img/ are distributed under the
CC0 license, available at
https://creativecommons.org/publicdomain/zero/1.0/legalcode

See https://tokumei.co/assets for more assets.


Contributing
============
v1.x
----
Clone the git repository using:

```
git clone https://gitlab.com/tokumei/tokumei
```

E-mail patches generated with `git format-patch` to
<patches@tokumei.co>. By doing so, you place your patches under the ISC
License.

v2.x-alpha
----------
Follow the instructions above to clone and install Tokumei. You may
follow the same procedure for contributions as above, or submit a merge
request at <https://gitlab.com/tokumei/tokumei/merge_requests>.

Security
--------

If you think you've found a security vulnerability within Tokumei v1.x,
please email <security@tokumei.co> with a description of the problem and
your proposed fixes. They will be addressed as quickly as possible.

For security issues with v2.x alpha, feel free to open an issue on the
GitLab Issue Tracker at <https://gitlab.com/tokumei/tokumei/issues>.

Code of Conduct
---------------
Tokumei deliberately does not have a Code of Conduct. Contributers are
expected to conduct themselves as human beings/robots accordingly. We
reserve the right to reject patches for any reason.

Contact
=======
- [hello@tokumei.co](mailto:hello@tokumei.co)
- [Keefer Rourke](https://krourke.org/contact)
- [Kyle Farwell](https://kfarwell.org/contact)
