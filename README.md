TT-Register
===========
TT-Register is a simple Rails application for registering table tennis players
for tournaments. At least in Switzerland that is not quite as simple als it
sounds as you have to take into account the players ranking to determine the
differnt series in which a player may play. In certain tournaments there are
also doubles series, so you have to register two players in one registration.
Technologies
------------
Basically this is a stock Rails-application with fairly little special gems
in it. It is simple enough to require fairly little javascript. Even though
it started out with Rails 2.3.8 the little JavaScript there was moved over
easily to Rails 3.0.
### Test framework(s)
Even this small application was generated over several years, so there is a
little of a mix in testing technologies that are used. Actually there are to
few tests to start with as I first started to hack the application away (and I
lacked sufficient proficiency with Rails when I started).

Eventually I ended up with some Unit tests in traditional Test::Unit style.
These are useful to test some core special functions of the models. When I
started to move to Rails 3.0 (too late, only in the late 2012) it became all
too obvious that I lacked integration tests. As I had grown to like
MiniTest::Spec in the meantime I used that style for the integration tests which
now work pretty well, I hope they will be useful to quickly migrate to
Rails 3.2 now.
### View framework
Since the beginning TT-register has been an project using the excellent
[erector](http://erector.rubyforge.org) framework for its view layer.
It is basically a DSL for HTML, therefore you will find very little direct
HTML-code in this application
