<?php

declare(strict_types=1);

namespace ITPM\Http\Middleware;

use Illuminate\Routing\Middleware\ValidateSignature as Middleware;

class ValidateSignature extends Middleware
{
    protected $except = [];
}
