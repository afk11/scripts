#!/usr/bin/env php
<?php

if (count($argv) != 3) {
  throw new \RuntimeException('Must provide two arguments: a % b');
}

$a = $argv[1];
$b = $argv[2];
echo gmp_strval(gmp_mod(gmp_init($a), gmp_init($b)), 10);
