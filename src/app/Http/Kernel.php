<?php

declare(strict_types=1);

namespace ITPM\Http;

use Illuminate\Auth\Middleware\AuthenticateWithBasicAuth;
use Illuminate\Auth\Middleware\Authorize;
use Illuminate\Auth\Middleware\EnsureEmailIsVerified;
use Illuminate\Auth\Middleware\RequirePassword;
use Illuminate\Cookie\Middleware\AddQueuedCookiesToResponse;
use Illuminate\Foundation\Http\Kernel as HttpKernel;
use Illuminate\Foundation\Http\Middleware\ConvertEmptyStringsToNull;
use Illuminate\Foundation\Http\Middleware\ValidatePostSize;
use Illuminate\Http\Middleware\HandleCors;
use Illuminate\Http\Middleware\SetCacheHeaders;
use Illuminate\Routing\Middleware\SubstituteBindings;
use Illuminate\Routing\Middleware\ThrottleRequests;
use Illuminate\Session\Middleware\AuthenticateSession;
use Illuminate\Session\Middleware\StartSession;
use Illuminate\View\Middleware\ShareErrorsFromSession;
use ITPM\Http\Middleware\Authenticate;
use ITPM\Http\Middleware\EncryptCookies;
use ITPM\Http\Middleware\HandleInertiaRequests;
use ITPM\Http\Middleware\PreventRequestsDuringMaintenance;
use ITPM\Http\Middleware\RedirectIfAuthenticated;
use ITPM\Http\Middleware\TrimStrings;
use ITPM\Http\Middleware\TrustProxies;
use ITPM\Http\Middleware\ValidateSignature;
use ITPM\Http\Middleware\VerifyCsrfToken;

class Kernel extends HttpKernel
{
    protected $middleware = [
        TrustProxies::class,
        HandleCors::class,
        PreventRequestsDuringMaintenance::class,
        ValidatePostSize::class,
        TrimStrings::class,
        ConvertEmptyStringsToNull::class,
    ];
    protected $middlewareGroups = [
        "web" => [
            EncryptCookies::class,
            AddQueuedCookiesToResponse::class,
            StartSession::class,
            ShareErrorsFromSession::class,
            VerifyCsrfToken::class,
            SubstituteBindings::class,
            HandleInertiaRequests::class,
        ],
        "api" => [
            ThrottleRequests::class . ":api",
            SubstituteBindings::class,
        ],
    ];
    protected $middlewareAliases = [
        "auth" => Authenticate::class,
        "auth.basic" => AuthenticateWithBasicAuth::class,
        "auth.session" => AuthenticateSession::class,
        "cache.headers" => SetCacheHeaders::class,
        "can" => Authorize::class,
        "guest" => RedirectIfAuthenticated::class,
        "password.confirm" => RequirePassword::class,
        "signed" => ValidateSignature::class,
        "throttle" => ThrottleRequests::class,
        "verified" => EnsureEmailIsVerified::class,
    ];
}
