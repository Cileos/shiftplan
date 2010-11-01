##"Betriebshandbuch"

_Dieses Readme soll für alle als Nachschlagwerk für die Arbeit am Projekt dienen._

###Setup local dev env

Die minimale Mysql-Version ist 5.1. SQLite3 sollte nicht eingesetzt werden, da es hier ein paar Probleme mit Datentypen gibt (die Tests laufen jedenfalls nicht durch). PostgreSQL und Oracle laufen in jeder Version.

Für die lokale database.yml als Adapter mysql2 angeben (siehe config/database.yml.example).

###Setup local test env

Für das lokale Testen gibt es ein Skript im script Verzeichnis mit dem Namen localbuild. Dieses startet den Test-Server, führt die Features und Specs aus und beendet den Server auch wieder.

    ./script/localbuild

Der Browser-Test basiert auf httpunit. Dafür sind folgende Sachen notwendig:
1. RJB (=1.2.9; v1.3.0 läuft im Test nicht -> FIXME; wenn "bundle install" v1.3.0 installiert, das lokale Gemfile.lock auf origin/master resetten und erneut "bundle install" laufen lassen)

Für RJB muss vor dem Installieren des Gems beachtet werden:
    MACOSX:
    zunächst installierte Java-Version checken:
    java -version
    wenn output:
    java version "1.6.0_22"
    Java(TM) SE Runtime Environment (build 1.6.0_22-b04-307-10M3261)
    Java HotSpot(TM) 64-Bit Server VM (build 17.1-b03-307, mixed mode)
	dann hat man das Update 3 über die Systemaktualisierung installiert und muss folgendes machen:
	- ein eventuell gesetztes JAVA_HOME leeren
	- folgenden Artikel beachten:
	http://rubyforge.org/forum/forum.php?forum_id=38127
	"Java update 3 for Snow Leopard removes necessary header files. So installing rjb gem may fail on OS X.
	The solution is to install Java for Mac OS X 10.6 Update 3 Developer Package from http://connect.apple.com before gem install.
	Or if you use original bundled ruby, install rjb-1.3.1-universal-darwin-10.gem from rubygem.org. Because 1.3.1 and 1.3.2 are 
	identical except for compile environment checking."
	- dann das Gemfile.lock checken; wenn da rjb mit Version 1.3.2 angegeben ist, alles klar, ansonsten ändern
	- ein bundle check/bundle install durchführen und alles sollte klar sein
	wenn die Javae Version kleiner ist (Apple Java Update 2 oder kleiner):
	- setzen des JAVA_HOME
	export JAVA_HOME=/System/Library/Frameworks/JavaVM.framework/Home
	- dann das Gemfile.lock checken; wenn da rjb mit Version 1.2.9 angegeben ist, alles klar, ansonsten ändern
	- ein bundle check/bundle install durchführen und alles sollte klar sein
    LINUX:
    export JAVA_HOME=/usr/lib/jvm/java-1.5.0-sun
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${JAVA_HOME}/jre/lib/i386:${JAVA_HOME}/jre/lib/i386/client

2. httpunit

Bei httpunit wird derzeit Version 2.6 benötigt. Das Paket ist nicht im Repo, da zu groß. Also irgendwo ablegen und linken:

    ln -nfs /var/www/shiftplan/shared/vendor/htmlunit-2.6 vendor/htmlunit-2.6

###Git-Workflow

_tbd_

###Setup CI server

Der CI Sever läuft derzeit auf einem Debian Lenny mit Ruby 1.8.7 (REE 2010.2 p253) und cijoe als CI Server. Der Server ist unter IP 85.17.223.63 erreichbar (Zugriffsdaten auf Anfrage bei FT). Das cijoe Interface ist unter ci.shiftplan.de erreichbar (ciadmin/Ogdg05R).

###Deployment

Derzeit hosten wir staging und production bei Heroku. Die Apps heißen shiftplandemo (staging) und shiftplanapp (production). Für das Deployment gibt es einen Rake-Task (lib/tasks/heroku.rake). Da Heroku ein paar Sonderlocken braucht und Bundler noch nicht 100%ig damit umgehen kann, werden während des Deployments lokal einige Änderungen am Repo vorgenommen, die nach Beendigung wieder zurückgesetzt werden. Insofern nach dem Deployment immer auf den Git-Status achten. Wenn master auf ein commit mit der Message "heroku setup" verweist, ist was schiefgelaufen und es sollte manuell ein 

    git reset --hard origin/master" 

durchgeführt werden. Es wird derzeit immer master deployed (dies muss nach Festlegung des Git-Workflows ggf. angepasst werden).

Folgende config var sollte auf alle Fälle vor dem ersten deployment für heroku gesetzt sein:
    heroku config:add BUNDLE_WITHOUT="development test"

Wenn man im Zusammenhang mit Heroku die Kommandos "db:pull" oder "db:push" verwenden will muss man das Gem "taps" zuvor installiert haben.

####Heroku staging (shiftplandemo.[com|de])

Das Deployment für das staging erfolgt mit dem Kommando

    rake deploy:staging

Mit dem Deployment wird HEAD:master mit -f gepushed. Es wird ein db:reset und db:setup ausgeführt. Letzteres kann auch zum zwischenzeitlichen Zurücksetzen der Demo DB genutzt werden:

    heroku rake db:reset --app shiftplandemo
    heroku rake db:setup --app shiftplandemo

####Heroku production (shiftplanapp.[com|de|eu|net|org|info])

Das Deployment für production erfolgt mit dem Kommando

    rake deploy:production

Dieser Deployment-Task macht eine Backup der aktuellen Version auf Heroku, macht ein Download in ein lokales Verzeichnis "backups" (ist vorher zu Fuss anzulegen) und legt dort eine Datei mit folgendem Aufbau ab: shiftplanapp_2010-10-20T124014.tar.gz. Wie wir die Backups zentral organisieren ist noch offen.

Nach dem Backup wird der lokale master mit einem tag versehen, das folgenden Aufbau hat: heroku-2010-10-20T124014. Das Tag wird nach origin gepushed und mit der Version zu Heroku deployed. Anschliessend werden die Migrations laufen gelassen.

Sollte das Deployment schiefgegangen sein, kann man mit 

    heroku bundles:animate myappbaseline --app myapp

das Ganze zurückfahren. (ACHTUNG: bundles:animate ist momentan deaktiviert, da es einen Fehler beim restore gibt. Insofern ist momentan nur möglich, dass man das bundle lokal auspackt, den Code mit klassischem git wieder zurückdreht und den im bundle enthaltenen pgdump in eine lokale PostgreSQL DB  lädt und per "heroku db:push" die Daten zurückspielt.)