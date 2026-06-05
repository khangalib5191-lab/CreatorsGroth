<?php

use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;
use Laravel\Sanctum\Http\Middleware\EnsureFrontendRequestsAreStateful;

return Application::configure(basePath: dirname(__DIR__))

    ->withRouting(
        web: __DIR__ . '/../routes/web.php',

        // ✅ API routes (make sure routes/api.php exists)
        api: __DIR__ . '/../routes/api.php',

        commands: __DIR__ . '/../routes/console.php',

        health: '/up',
    )

    ->withMiddleware(function (Middleware $middleware): void {

        // ✅ Sanctum stateful authentication for API (required for Flutter / SPA auth)
        $middleware->api(prepend: [
            EnsureFrontendRequestsAreStateful::class,
        ]);

        // (Optional but safe defaults Laravel uses internally)
        $middleware->api(append: [
            \Illuminate\Routing\Middleware\SubstituteBindings::class,
        ]);

    })

    ->withExceptions(function (Exceptions $exceptions): void {
        //
    })

    ->create();