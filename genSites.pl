#!/usr/bin/perl
# read in a list of domains
# for each domain create the below directories, if they don't exist, if they do don't create
# write out a file for each domain in the sites-available directory
# create a default index.html if it doesnt exist
# enable the site

while(<>)
{
	chomp;
	my $servername = $_; 
	# base directory
	my $baseDir = "/var/www/"; 

	# create document root
	my $docRoot = $baseDir . $servername . "/htdocs"; 
	system("mkdir -p $docRoot"); 

	# create a default html page
	my $defaultPage = $docRoot . "/index.html"; 
	unless (-e $defaultPage)
	{
		open INDEX , ">", $defaultPage or die $!;
		print INDEX "<html><head><title>" . $servername. "</title></head><body>";
		print INDEX "The web server " . $servername . " is not available or under development.<br>";
		print INDEX "</body></html>"; 
		close INDEX; 
	}	

	# create log directory
	my $logRoot = $baseDir . $servername . "/logs"; 
	system("mkdir -p $logRoot"); 

	my $filename = "/etc/apache2/sites-available/" . $servername; 
	unless (-e $filename) 
	{
		open FILE, ">", $filename or die $!;
		print FILE "# Auto generated file\n"; 
		print FILE "<VirtualHost *>\n";
		print FILE "\tServerAdmin admin@" . $servername . "\n";
		print FILE "\tServerName  www." . $servername. "\n";
		print FILE "\tServerAlias " . $servername. "\n"; 
		print FILE "\n";
		print FILE "\t# Indexes + Directory Root.\n";
		print FILE "\tDirectoryIndex index.html\n";
		print FILE "\tDocumentRoot ". $baseDir . $servername . "/htdocs/\n";
		print FILE "\n";
		print FILE "\t# Logfiles\n";
		print FILE "\tErrorLog  ". $baseDir . $servername. "/logs/error.log\n";
		print FILE "\tCustomLog ". $baseDir . $servername. "/logs/access.log combine\n";
		print FILE "</VirtualHost>\n";
		close FILE; 
		system("a2ensite $servername"); 
 	} 
}
