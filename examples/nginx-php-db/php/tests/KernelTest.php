<?php
namespace Webfux\POC\Tests;
use PHPUnit\Framework\TestCase;
use Webfux\POC\Kernel;

class KernelTest extends TestCase {
    public function testHelloWorld() {
        $kernel = new Kernel();
        $this->assertEquals($kernel->HelloWorld(), $kernel::MESSAGE);
    }
}