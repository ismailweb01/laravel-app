<?php

namespace Tests\Feature;

use Tests\TestCase;

class ExampleTest extends TestCase
{
    public function test_ci_blocks_bad_code(): void
    {
        $this->assertTrue(false);
    }
}