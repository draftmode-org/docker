<?php
require_once dirname(__DIR__).'/vendor/autoload.php';

use Webfux\POC\Kernel;
$kernel = new Kernel();

echo "NGINX with PHP fpm and socket on Port 80 (php), ".date("d.m.Y H:i:s")."<hr/>";
echo $kernel->verifyClass()."<hr/>";
echo $kernel->verifyDB()."<hr/>";