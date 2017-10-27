<?php
echo 'PHP: ' . phpversion() . PHP_EOL;
echo 'phpredis: ' . phpversion('redis') . PHP_EOL;
echo PHP_EOL;

class MyRedis extends \Redis {
    public $dummy;
}

$redis = new MyRedis();
var_dump($redis);
