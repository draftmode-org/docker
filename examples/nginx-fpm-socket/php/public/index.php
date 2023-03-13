<?php
require_once dirname(__DIR__).'/vendor/autoload.php';

use Webfux\POC\Kernel;
$kernel = new Kernel();
echo date("d.m.Y H:i:s").$kernel->HelloWorld();