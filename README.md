# formulae

Custom SeatGeek Formula for Homebrew

## Requirements

- Homebrew
- OS X 10.7. Untested on versions below, YMMV
- Patience

## Installation


You'll want to tap this repository:

    brew tap seatgeek/formulae

And now you can install any of our formula as necessary.


## Available formulae

The following formulae will be available when you tap this repository.

### Nginx-Sg


> Allows for customized nginx installations

Lines 27-33, 66-73, and 82-98 are the patches to the real existing nginx formula in homebrew.

Usage:

* `--add-github-module=USERNAME/REPOSITORY`: Adds an nginx module from github. Requires `git`.
* `--add-mdounin-module=MODULE_NAME`: Adds an nginx module from mdounin's hg repo (http://mdounin.ru/hg/)
* `--include-module-MODULE_NAME`: Adds the `--with-MODULE_NAME` flag for a module that comes with the nginx source but not enabled by default

Example:

		brew install nginx-sg.rb \
	    --add-github-module=agentzh/chunkin-nginx-module \
	    --include-module-http_gzip_static_module \
	    --add-mdounin-module=ngx_http_auth_request_module#a29d74804ff1

Running the above on the commandline produces the following output:

		$ brew install ./nginx-sg.rb --add-github-module=agentzh/chunkin-nginx-module --include-module-http_gzip_static_module --add-mdounin-module=ngx_http_auth_request_module#a29d74804ff1
		==> Downloading http://nginx.org/download/nginx-1.2.4.tar.gz
		Already downloaded: /Library/Caches/Homebrew/nginx-sg-1.2.4.tar.gz
		==> Patching
		patching file conf/nginx.conf
		adding extra modules
		- adding http_gzip_static_module module
		- adding agentzh from github...
		- adding ngx_http_auth_request_module from mdounin...
		==> ./configure --prefix=/usr/local/Cellar/nginx-sg/1.2.4 --with-http_ssl_module --with-pcre --with-ipv6 --with-cc-opt=-I/usr/local/include --with-ld-opt=-L/usr/local/lib --conf-path=/usr/local/etc/nginx/nginx.conf --pid-path=/usr/local/var/run/nginx.pid --lock-path=/
		==> make
		==> make install
		==> Caveats
		In the interest of allowing you to run `nginx` without `sudo`, the default
		port is set to localhost:8080.

		If you want to host pages on your local machine to the public, you should
		change that to localhost:80, and run `sudo nginx`. You'll need to turn off
		any other web servers running port 80, of course.

		You can start nginx automatically on login running as your user with:
		  mkdir -p ~/Library/LaunchAgents
		  cp /usr/local/Cellar/nginx-sg/1.2.4/homebrew.mxcl.nginx-sg.plist ~/Library/LaunchAgents/
		  launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.nginx-sg.plist

		Though note that if running as your user, the launch agent will fail if you
		try to use a port below 1024 (such as http's default of 80.)
		==> Summary
		/usr/local/Cellar/nginx-sg/1.2.4: 9 files, 900K, built in 28 seconds


## License

Copyright (c) 2012 SeatGeek and other contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
