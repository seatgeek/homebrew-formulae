require 'formula'

class NginxSg < Formula
  homepage 'http://nginx.org/'
  url 'http://nginx.org/download/nginx-1.2.4.tar.gz'
  sha256 'c587c25f2fa9c9dde6a58cbaf7bf2c808ee360cfa3cdaf00a13a33f728d96c43'

  devel do
    url 'http://nginx.org/download/nginx-1.3.8.tar.gz'
    sha256 '8d68f9224f4616c987208bcb3a0bf1ae03740c5ec313b220f995ba50d826fe1c'
  end

  env :userpaths

  depends_on 'pcre'

  option 'with-passenger', 'Compile with support for Phusion Passenger module'
  option 'with-webdav', 'Compile with support for WebDAV module'

  skip_clean 'logs'

  # Changes default port to 8080
  def patches
    DATA
  end

  def collect_modules regex=nil
    ARGV.select { |arg| arg.match(regex) != nil }.collect { |arg| arg.gsub(regex, '') }
  end

  def nginx_modules; collect_modules(/^--include-module-/); end
  def add_from_github; collect_modules(/^--add-github-module=/); end
  def add_from_mdounin; collect_modules(/^--add-mdounin-module=/); end

  def passenger_config_args
    passenger_root = `passenger-config --root`.chomp

    if File.directory?(passenger_root)
      return "--add-module=#{passenger_root}/ext/nginx"
    end

    puts "Unable to install nginx with passenger support. The passenger"
    puts "gem must be installed and passenger-config must be in your path"
    puts "in order to continue."
    exit
  end

  def install
    args = [
      "--prefix=#{prefix}",
      "--with-http_ssl_module",
      "--with-pcre",
      "--with-ipv6",
      "--with-cc-opt=-I#{HOMEBREW_PREFIX}/include",
      "--with-ld-opt=-L#{HOMEBREW_PREFIX}/lib",
      "--conf-path=#{etc}/nginx/nginx.conf",
      "--pid-path=#{var}/run/nginx.pid",
      "--lock-path=#{var}/run/nginx.lock",
      "--http-client-body-temp-path=#{var}/run/nginx/client_body_temp",
      "--http-proxy-temp-path=#{var}/run/nginx/proxy_temp",
      "--http-fastcgi-temp-path=#{var}/run/nginx/fastcgi_temp",
      "--http-uwsgi-temp-path=#{var}/run/nginx/uwsgi_temp",
      "--http-scgi-temp-path=#{var}/run/nginx/scgi_temp"
    ]

    puts "adding extra modules"

    args << passenger_config_args if build.include? 'with-passenger'
    args << "--with-http_dav_module" if build.include? 'with-webdav'

    nginx_modules.each { |name| args << "--with-#{name}"; puts "- adding #{name} module" }
    add_from_github.each { |name| args <<  "--add-module=#{fetch_from_github(name)}" }
    add_from_mdounin.each { |name| args <<  "--add-module=#{fetch_from_mdounin(name)}" }

    system "./configure", *args
    system "make"
    system "make install"
    man8.install "objs/nginx.8"
    (var/'run/nginx').mkpath
  end

  def fetch_from_github name
    name, repository = name.split('/')
    raise "You must specify a repository name for github modules" if repository.nil?

    puts "- adding #{repository} from github..."
    `git clone -q git://github.com/#{name}/#{repository} modules/#{name}/#{repository}`
    path = Dir.pwd + '/modules/' + name + '/' + repository
  end

  def fetch_from_mdounin name
    name, hash = name.split('#')
    raise "You must specify a commit sha for mdounin modules" if hash.nil?

    puts "- adding #{name} from mdounin..."
    `mkdir -p modules/mdounin && cd $_ ; curl -s -O http://mdounin.ru/hg/#{name}/archive/#{hash}.tar.gz; tar -zxf #{hash}.tar.gz`
    path = Dir.pwd + '/modules/mdounin/' + name + '-' + hash
  end

  def caveats; <<-EOS.undent
    In the interest of allowing you to run `nginx` without `sudo`, the default
    port is set to localhost:8080.

    If you want to host pages on your local machine to the public, you should
    change that to localhost:80, and run `sudo nginx`. You'll need to turn off
    any other web servers running port 80, of course.

    You can start nginx automatically on login running as your user with:
      mkdir -p ~/Library/LaunchAgents
      cp #{plist_path} ~/Library/LaunchAgents/
      launchctl load -w ~/Library/LaunchAgents/#{plist_path.basename}

    Though note that if running as your user, the launch agent will fail if you
    try to use a port below 1024 (such as http's default of 80.)
    EOS
  end

  def startup_plist
    return <<-EOPLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>#{plist_name}</string>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <false/>
    <key>UserName</key>
    <string>#{`whoami`.chomp}</string>
    <key>ProgramArguments</key>
    <array>
        <string>#{HOMEBREW_PREFIX}/sbin/nginx</string>
    </array>
    <key>WorkingDirectory</key>
    <string>#{HOMEBREW_PREFIX}</string>
  </dict>
</plist>
    EOPLIST
  end
end

__END__
--- a/conf/nginx.conf
+++ b/conf/nginx.conf
@@ -33,7 +33,7 @@
     #gzip  on;

     server {
-        listen       80;
+        listen       8080;
         server_name  localhost;

         #charset koi8-r;
