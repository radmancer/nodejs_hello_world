# Using Ubuntu
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install -y nodejs
mkdir myapp
cd myapp
npm init
#At "entry point: (index.js)" type "app.js"
npm install express --save
nano
#"var express = require('express');
#var app = express();
#app.get('/', function (req, res) {
#  res.send('Hello World!');
#});
#app.listen(3000, function () {
#  console.log('Example app listening on port 3000!');
#});"
node app.js
#go to your browser and type  http://localhost:3000/ A functioning server!
sudo npm install -g express-generator
#Jade is the default templating engine, we'll be using EJS.
express --view="ejs" nodetest1 #EJS HTML Preprocessor
cd nodetest1
npm install --save monk@^6.0.6 mongodb@^3.1.13
npm install
npm start
#go to your browser and type  http://localhost:3000/ A functioning server!
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list
sudo apt-get update
sudo apt-get install -y mongodb-org
sudo mkdir -p /data/db
sudo chmod -R 775 /data/
sudo touch /etc/systemd/system/mongodb.service
sudo nano /etc/systemd/system/mongodb.service
#Paste all this in nano.
#[Unit]
#Description=High-performance, schema-free document-oriented database
#After=network.target

#[Service]
#User=mongodb
#ExecStart=/usr/bin/mongod --quiet --config /etc/mongod.conf

#[Install]
#WantedBy=multi-user.target
#hit ctrl + shift + t for new terminal tab
sudo systemctl start mongodb
sudo systemctl status mongodb
#to stop mongodb: sudo systemctl stop mongodb
mongo
#in the mongo client, now.
use nodetest1
#adding a new user to the database.
db.usercollection.insert({ "username" : "testuser1", "email" : "testuser1@testdomain.com" })
#show the record with: db.usercollection.find().pretty()
#adding more users:
newstuff = [{ "username" : "testuser2", "email" : "testuser2@testdomain.com" }, { "username" : "testuser3", "email" : "testuser3@testdomain.com" }]
db.usercollection.insert(newstuff);
#add this code to app.js right after logger = require('morgan');
#// New Code
#var monk = require('monk');
#var db = monk('localhost:27017/nodetest1');
#add this code above app.use('/', indexRouter);
#                and app.use('/users', usersRouter);
#// Make our db accessible to our router
#app.use(function(req,res,next){
#    req.db = db;
#    next();
#});
#in routes/index.js, add:
#/* GET Userlist page. */
#router.get('/userlist', function(req, res) {
#    var db = req.db;
#    var collection = db.get('usercollection');
#    collection.find({},{},function(e,docs){
#        res.render('userlist', {
#            "userlist" : docs
#        });
#    });
#});
#create userlist.ejs with this code:
#<!DOCTYPE html>
#<html>
#  <head>
#    <title>User List</title>
#    <link rel='stylesheet' href='/stylesheets/style.css' />
#  </head>
#  <body>
#    <h1>User List</h1>
#    <ul>
#      <%
#        var list = '';
#        for (i = 0; i < userlist.length; i++) {
#          list += '<li><a href="mailto:' + userlist[i].email + '">' + userlist[i].username + '</a></li>';
#        }
#      %>
#      <%- list %>
#    </ul>
#  </body>
#</html>
#go to: http://localhost:3000/userlist
#Paste the following above module.exports in routes/index.js:
#/* GET New User page. */
#router.get('/newuser', function(req, res) {
#    res.render('newuser', { title: 'Add New User' });
#});
#create views/newuser.ejs
#<!DOCTYPE html>
#<html>
#  <head>
#    <title>Add User</title>
#    <link rel='stylesheet' href='/stylesheets/style.css' />
#  </head>
#  <body>
#    <h1><%= title %></h1>
#    <form id="formAddUser" name="adduser" method="post" action="/adduser">
#      <input id="inputUserName" type="text" placeholder="username" name="username" />
#      <input id="inputUserEmail" type="text" placeholder="email" name="useremail" />
#      <button id="btnSubmit" type="submit">Submit</button>
#    </form>
#  </body>
#</html>
#add this to routes/index.js above the module.exports line
#/* POST to Add User Service */
#router.post('/adduser', function(req, res) {
#
#    // Set our internal DB variable
#    var db = req.db;

#    // Get our form values. These rely on the "name" attributes
#    var userName = req.body.username;
#    var userEmail = req.body.useremail;

#    // Set our collection
#    var collection = db.get('usercollection');

#    // Submit to the DB
#    collection.insert({
#        "username" : userName,
#        "email" : userEmail
#    }, function (err, doc) {
#        if (err) {
#            // If it failed, return error
#            res.send("There was a problem adding the information to the database.");
#        }
#        else {
#            // And forward to success page
#            res.redirect("userlist");
#        }
#    });

#});